import 'package:flutter/services.dart';
import 'dart:convert';

class Config {
  static Future<Map<String, dynamic>> getConfig() {
    return rootBundle.loadString('../assets/config/config.json').then(
      (value) {
        return jsonDecode(value) as Map<String, dynamic>;
      },
    );
  }
}
