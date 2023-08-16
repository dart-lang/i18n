export 'src/intl_default.dart' // Stub implementation
    // Browser implementation
    if (dart.library.html) 'intl_browser.dart'
    // Native implementation
    if (dart.library.io) 'intl_standalone.dart';
