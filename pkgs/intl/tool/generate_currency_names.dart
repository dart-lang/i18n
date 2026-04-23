import 'dart:convert';
import 'dart:io';

/// Core locales to fetch from CLDR.
const locales = ['en', 'es', 'fr', 'de', 'hi', 'zh', 'ja'];

/// Major currency codes to extract.
const currencies = ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'CNY', 'AUD', 'CAD', 'CHF'];

/// Base URL for CLDR JSON data.
const cldrBaseUrl = 'https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-numbers-full/main';

void main() async {
  final Map<String, Map<String, String>> localizedCurrencyNames = {};

  final client = HttpClient();

  try {
    for (final locale in locales) {
      print('Fetching currencies for locale: $locale...');
      final url = Uri.parse('$cldrBaseUrl/$locale/currencies.json');
      
      try {
        final request = await client.getUrl(url);
        final response = await request.close();

        if (response.statusCode != 200) {
          print('Failed to load locale $locale: ${response.statusCode}');
          continue;
        }

        final content = await response.transform(utf8.decoder).join();
        final data = json.decode(content) as Map<String, dynamic>;
        
        // Navigate through CLDR JSON structure:
        // main -> {locale} -> numbers -> currencies
        final currencyData = data['main'][locale]['numbers']['currencies'] as Map<String, dynamic>;

        final Map<String, String> extracted = {};
        for (final code in currencies) {
          if (currencyData.containsKey(code)) {
            extracted[code] = currencyData[code]['displayName'] as String;
          }
        }
        
        localizedCurrencyNames[locale] = extracted;
      } catch (e) {
        print('Error fetching $locale: $e');
      }
    }

    await generateDartFile(localizedCurrencyNames);
    print('Generation complete.');
  } finally {
    client.close();
  }
}

Future<void> generateDartFile(Map<String, Map<String, String>> data) async {
  final buffer = StringBuffer();
  buffer.writeln('// Generated file. Do not edit manually.');
  buffer.writeln();
  buffer.writeln('const Map<String, Map<String, String>> localizedCurrencyNames = {');

  data.forEach((locale, currencies) {
    buffer.writeln("  '$locale': {");
    currencies.forEach((code, name) {
      // Escape single quotes in names if they exist
      final escapedName = name.replaceAll("'", "\\'");
      buffer.writeln("    '$code': '$escapedName',");
    });
    buffer.writeln('  },');
  });

  buffer.writeln('};');

  final outputFile = File('lib/src/data/currency_names_data.dart');
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(buffer.toString());
  print('Data written to ${outputFile.path}');
}
