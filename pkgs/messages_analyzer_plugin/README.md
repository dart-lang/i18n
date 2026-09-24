# `messages_analyzer_plugin`

An analysis server plugin for `package:messages` that provides lint rules and IDE quick fixes to extract hardcoded string literals from Dart code into `.arb` files.

## Features

### Lint Rule: `literal_string_outside_l10n`
Flags hardcoded string literals and string interpolations in application source files that should be extracted to localization (`.arb`) files.

#### Exclusions
The lint automatically ignores strings in contexts where localization is unnecessary or invalid:
- **`print(...)` statements**: Debug or logging print calls.
- **Direct variable assignments / declarations**: e.g. `final key = 'dadasda';` or `var x = 'hello';`.
- **Annotations & Metadata**: e.g. `@Deprecated('...')`.
- **`assert(...)` messages**: Condition error messages in assert statements.
- **Exceptions & Errors**: e.g. `throw Exception('...')` or `Error('...')`.
- **Directives**: Import, export, and part string literals.
- **Test files**: Any file under a `/test/`, `/integration_test/`, or `/test_driver/` directory.
- **Generated files**: Any file ending in `.g.dart` or `.freezed.dart`.

### Quick Fix: `Extract string to '<file>.arb'`
Provides an IDE Quick Fix (lightbulb action) on reported string literals:
1. **Discovers ARB Target**: Reads `pubspec.yaml` under `package_options -> messages_builder -> arb_input_folder` (defaulting to `assets/l10n/`). Targets existing `.arb` files in that folder or creates `en.arb` if none exist.
2. **Generates ARB Key**: Derives a `camelCase` message ID from the first few words of the string (e.g. `'Hello world'` $\rightarrow$ `helloWorld`, `'Hello $name'` $\rightarrow$ `helloName`). Automatically handles duplicate keys by appending a numeric suffix (`helloWorld2`).
3. **Supports String Interpolations**: Converts Dart interpolations (`'Hello $name, welcome to $appName!'`) to ARB placeholder syntax (`'Hello {name}, welcome to {appName}!'`) and generates the corresponding `@key` metadata block with placeholder types.
4. **Replaces Dart Expression**: Replaces the literal in Dart code with a method invocation on `messages` (e.g. `messages.helloName(name: name)`).

## Configuration

Enable the plugin in your project's `analysis_options.yaml`:

```yaml
plugins:
  messages_analyzer_plugin:
    path: path/to/messages_analyzer_plugin # Or version when published
```
