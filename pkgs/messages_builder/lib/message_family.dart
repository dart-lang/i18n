// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:messages/messages.dart';

import 'located_message_file.dart';
import 'message_file.dart';
import 'parameterized_message.dart';

/// The message file which is the source of truth for a context, together
/// with its translations.
class MessageFamily {
  /// The file which the translations are based on, for example `en.arb`.
  final LocatedMessageFile template;

  /// All files in this family, including the [template], sorted by locale.
  final List<LocatedMessageFile> files;

  MessageFamily(this.template, this.files);
}

/// Groups [messageFiles] by their context, and aligns the translations in
/// each group with the group's template.
///
/// The generated code looks up messages by their index in the template, and
/// passes arguments in the order of the template's placeholders. Therefore,
/// every translation is rewritten to
/// * contain exactly the messages of the template, in the same order.
///   Messages missing from a translation fall back to the template's message,
///   and messages which are not in the template are dropped.
/// * use the argument indices of the template, even if the translation
///   reorders the placeholders.
///
/// All files in a family get the same [MessageFile.hash], which only depends
/// on the message names and placeholders of the template. This way, changing
/// a translation does not change the generated code.
///
/// Problems with translations are reported to [warn].
List<MessageFamily> groupIntoFamilies(
  List<LocatedMessageFile> messageFiles, {
  void Function(String message)? warn,
}) {
  final groups = messageFiles
      .groupListsBy((messageFile) => findTemplate(messageFiles, messageFile));
  return [
    for (final MapEntry(key: template, value: members) in groups.entries)
      _alignFamily(template, members, warn),
  ];
}

/// Either get the referenced template file of [currentFile], or try to infer
/// which it might be.
LocatedMessageFile findTemplate(
  List<LocatedMessageFile> messageFiles,
  LocatedMessageFile currentFile,
) {
  // Try to infer by looking at which files contain metadata, which is a sign
  // they might be the references for others in the same context.
  final filesInContext = messageFiles.where(
      (messageFile) => messageFile.file.context == currentFile.file.context);
  final potentialParent =
      filesInContext.firstWhereOrNull((element) => element.file.hasMetadata);
  if (potentialParent == null && filesInContext.length > 1) {
    throw ArgumentError('''
The files $filesInContext have no metadata, so it is not clear which one is the main source of truth.''');
  }
  return potentialParent ?? currentFile;
}

/// A hash of the message names and placeholders of [template], which is all
/// that the generated code depends on.
String templateHash(MessageFile template) {
  final shape = [
    for (final message in template.messages)
      [
        message.name,
        for (final placeholder in message.placeholders)
          '${placeholder.name}:${placeholder.type}',
      ],
  ];
  final digest = sha1.convert(utf8.encode(jsonEncode(shape)));
  return base64Encode(digest.bytes).substring(0, 8);
}

MessageFamily _alignFamily(
  LocatedMessageFile template,
  List<LocatedMessageFile> members,
  void Function(String message)? warn,
) {
  final hash = templateHash(template.file);
  final alignedTemplate = LocatedMessageFile(
    path: template.path,
    file: template.file.copyWith(hash: hash),
  );
  final files = [
    for (final member in members)
      if (identical(member, template))
        alignedTemplate
      else
        LocatedMessageFile(
          path: member.path,
          file: _alignTranslation(template.file, member, warn)
              .copyWith(hash: hash),
        ),
  ]..sortBy((messageFile) => messageFile.locale);
  return MessageFamily(alignedTemplate, files);
}

MessageFile _alignTranslation(
  MessageFile template,
  LocatedMessageFile translation,
  void Function(String message)? warn,
) {
  final translatedMessages = {
    for (final message in translation.file.messages) message.name: message,
  };
  final missing = <String>[];
  final unknownPlaceholders = <String>[];
  final messages = <ParameterizedMessage>[];
  for (final templateMessage in template.messages) {
    final translatedMessage = translatedMessages.remove(templateMessage.name);
    if (translatedMessage == null) {
      missing.add(templateMessage.name);
      messages.add(templateMessage);
      continue;
    }
    final templatePlaceholders =
        templateMessage.placeholders.map((p) => p.name).toList();
    final newIndices = [
      for (final placeholder in translatedMessage.placeholders)
        templatePlaceholders.indexOf(placeholder.name),
    ];
    if (newIndices.contains(-1)) {
      unknownPlaceholders.add(templateMessage.name);
      messages.add(templateMessage);
      continue;
    }
    messages.add(ParameterizedMessage(
      remapArguments(translatedMessage.message, newIndices),
      templateMessage.name,
      templateMessage.placeholders,
    ));
  }

  final path = translation.path;
  if (missing.isNotEmpty) {
    warn?.call('$path: ${missing.length} message(s) are not translated, '
        'using the template instead: ${missing.join(', ')}');
  }
  if (unknownPlaceholders.isNotEmpty) {
    warn?.call('$path: ${unknownPlaceholders.length} message(s) use '
        'placeholders which are not in the template, using the template '
        'instead: ${unknownPlaceholders.join(', ')}');
  }
  if (translatedMessages.isNotEmpty) {
    warn?.call('$path: dropping ${translatedMessages.length} message(s) '
        'which are not in the template: '
        '${translatedMessages.keys.join(', ')}');
  }
  return translation.file.copyWith(messages: messages);
}

/// Returns a copy of [message] in which every argument index `i` is replaced
/// by `newIndices[i]`.
Message remapArguments(Message message, List<int> newIndices) {
  Message remap(Message submessage) => remapArguments(submessage, newIndices);
  Map<K, Message> remapAll<K>(Map<K, Message> submessages) =>
      submessages.map((key, submessage) => MapEntry(key, remap(submessage)));
  return switch (message) {
    StringMessage(:final value, :final argPositions, :final id) =>
      StringMessage(
        value,
        argPositions: [
          for (final position in argPositions)
            (
              stringIndex: position.stringIndex,
              argIndex: newIndices[position.argIndex],
            ),
        ],
        id: id,
      ),
    CombinedMessage(:final id, :final messages) =>
      CombinedMessage(id, messages.map(remap).toList()),
    PluralMessage() => PluralMessage(
        numberCases: remapAll(message.numberCases),
        wordCases: remapAll(message.wordCases),
        few: message.few == null ? null : remap(message.few!),
        many: message.many == null ? null : remap(message.many!),
        other: remap(message.other),
        argIndex: newIndices[message.argIndex],
        id: message.id,
      ),
    SelectMessage() => SelectMessage(
        remap(message.other),
        remapAll(message.cases),
        newIndices[message.argIndex],
        message.id,
      ),
  };
}
