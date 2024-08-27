import 'dart:io';

class AppConfig {
  static String apiBase =
      Platform.environment["API_BASE"] ?? "http://0.0.0.0:5000";
}
