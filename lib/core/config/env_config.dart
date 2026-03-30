import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get msg91WidgetId {
    final value = dotenv.env['MSG91_WIDGET_ID'];
    if (value == null || value.isEmpty) {
      throw Exception("MSG91_WIDGET_ID not found in .env");
    }
    return value;
  }

  static String get msg91AuthToken {
    final value = dotenv.env['MSG91_AUTH_TOKEN'];
    if (value == null || value.isEmpty) {
      throw Exception("MSG91_AUTH_TOKEN not found in .env");
    }
    return value;
  }

  static String get countryCode =>
      dotenv.env['COUNTRY_CODE'] ?? '91';
}