import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _preferences; // Agregamos 'late' para diferir la inicialización

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String get authToken => _preferences.getString('authToken') ?? '';

  set authToken(String value) {
    _preferences.setString('authToken', value);
  }

  Map<String, dynamic> get userData {
    final jsonString = _preferences.getString('userData');
    return jsonString != null ? jsonDecode(jsonString) : {};
  }

  set userData(Map<String, dynamic> value) {
    final jsonString = jsonEncode(value);
    _preferences.setString('userData', jsonString);
  }
}