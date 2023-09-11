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
import 'package:messages/messages_native.dart';
import 'package:messages/package_intl_object.dart';
import 'package:messages/file_loading.dart';

void main() {
  final aboutPageMessages = AboutPageMessages(fileLoaderSync, OldIntlObject());
  aboutPageMessages.loadLocale('fr');
  final message = aboutPageMessages.aboutMessage(website: 'mywebsite.com');
  print(message); // 'À propos de mywebsite.com'
  aboutPageMessages.loadLocale('en');
  print(message); // 'About mywebsite.com'
}
```
