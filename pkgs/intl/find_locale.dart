export 'lib/intl_default.dart' // Stub implementation
    // Browser implementation
    if (dart.library.html) 'intl_browser.dart'
    if (dart.library.io) 'intl_standalone.dart';
