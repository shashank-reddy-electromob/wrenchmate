import 'dart:convert';
import 'package:flutter/services.dart';

class ApiKeyService {
  static Future<String> loadApiKey() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/M22JKU8ER0YL4_1.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData['key'];
  }

  static Future<int> loadApiKeyIndex() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/M22JKU8ER0YL4_1.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData['keyIndex'];
  }
}
