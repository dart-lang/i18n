import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

Future<Map<String, Set<String>>> getMessages(
  String path,
  List<String> messageClassNames,
) async {
  final AnalysisContextCollection collection = AnalysisContextCollection(
    includedPaths: [path],
  );
  final AnalysisContext context = collection.contextFor(path);
  final AnalysisSession session = context.currentSession;
  final result = await session.getResolvedUnit(path);
  if (result is ResolvedUnitResult) {
    final messageFinder = MessageFinder(messageClassNames);
    result.unit.visitChildren(messageFinder);
    return messageFinder.getMessages;
  } else {
    throw Error();
  }
}

class MessageFinder extends RecursiveAstVisitor {
  final List<String> messageClassNames;
  MessageFinder(this.messageClassNames)
      : foundMessages = {
          for (final className in messageClassNames) className: {}
        };

  final Map<String, Set<String>> foundMessages;

  Map<String, Set<String>> get getMessages =>
      foundMessages.map((className, messageMethods) => MapEntry(
          className,
          messageMethods
              .where((messageMethod) => messageMethod != 'loadLocale')
              .toSet()));

  @override
  visitMethodInvocation(MethodInvocation node) {
    node.visitChildren(this);
    final target = node.target;
    if (target is SimpleIdentifier) {
      final type = target.staticType;
      if (type is InterfaceType) {
        final className = type.element.name;
        if (messageClassNames.contains(className)) {
          foundMessages[className]!.add(node.methodName.name);
        }
      }
    }
  }
}
