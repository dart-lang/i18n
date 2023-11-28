[![package:messages](https://github.com/dart-lang/i18n/actions/workflows/messages.yml/badge.svg)](https://github.com/dart-lang/i18n/actions/workflows/messages.yml)
<!-- [![Pub](https://img.shields.io/pub/v/messages.svg)](https://pub.dev/packages/messages) -->
<!-- [![package publisher](https://img.shields.io/pub/publisher/intl4x.svg)](https://pub.dev/packages/intl4x/publisher) -->

A lightweight modular library for localization (l10n) functionality.

## Goals

To enable localization which supports

 - Localized file update without recompile,
 - Easy and safe use through named method and argument generation,
 - Small file size, treeshaking both unused locales and unused messages.

## Status - experimental

 - Serialize to binary: -
 - Serialize to JSON: :heavy_check_mark:
 - Deserialize JSON: :heavy_check_mark:
 - Deserialize JSON using browser JS: -
 - Deserialize binary: -
 - Tree shake message files: -

## Partitioning

The package is partitioned to allow a package to consume some parts of the library only as a `dev_dependency`, not including the message building and serialization packages in the dependencies for the application.

### `messages`
Contains the interface for a `MessageList` and the different subtypes of `Message`s as well as the functionality to parse a data file into a `MessageList`.
### `messages_builder`
The `builder` to generate the named methods and data files from the input `arb` translation files. Has a dependency on `messages_serializer` and `messages`.

### `messages_serializer`
The logic for serializing `arb` message files into data files.

## Example

Given translation message files such as these `.arb`s:

```json
{
    "@@locale":"en",
    "@@context": "AboutPage",
    "aboutMessage": "About {website}",
    "@aboutMessage": {
        "placeholders": {
            "website" : {
                "type":"string"
            }
        }
    }
}
```

```json
{
    "@@locale":"fr",
    "@@context": "AboutPage",
    "aboutMessage": "À propos de {website}",
}
```

insert the message in your Dart application through

```dart
import 'dart:io';

import 'package:example/aboutpage_arb_file.g.dart';
import 'package:messages/messages_native.dart';
import 'package:messages/package_intl_object.dart';

void main() {
  final aboutPageMessages = AboutPageMessages(
    (String id) => File('lib/$id').readAsBytesSync(),
    OldIntlObject(),
  );
  aboutPageMessages.loadLocale('fr');
  print(aboutPageMessages.aboutMessage(website: 'mywebsite.com')); // 'À propos de mywebsite.com'
  aboutPageMessages.loadLocale('en');
  print(aboutPageMessages.aboutMessage(website: 'mywebsite.com')); // 'About mywebsite.com'
}
```