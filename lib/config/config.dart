import 'package:flutter/services.dart';
import 'dart:convert';

class Config {
  static Future<Map<String, dynamic>> getConfig() async {
    String jsonString = await rootBundle.loadString('assets/config/config.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
