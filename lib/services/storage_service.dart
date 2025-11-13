import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving encrypted login credentials
class StorageService {
  static const String _credentialsKey = 'encrypted_credentials';
  static const String _usernameKey = 'user_name';
  
  /// Saves encrypted credentials to local storage
  static Future<void> saveCredentials(List<Map<String, String>> credentials) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> serialized = credentials.map((cred) {
      return '${cred['title']}|||${cred['username']}|||${cred['password']}';
    }).toList();
    await prefs.setStringList(_credentialsKey, serialized);
  }
  
  /// Loads encrypted credentials from local storage
  static Future<List<Map<String, String>>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? serialized = prefs.getStringList(_credentialsKey);
    
    if (serialized == null) return [];
    
    return serialized.map((item) {
      List<String> parts = item.split('|||');
      return {
        'title': parts[0],
        'username': parts[1],
        'password': parts[2],
      };
    }).toList();
  }
  
  /// Clears all stored credentials
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }
  
  /// Saves username to local storage
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }
  
  /// Retrieves username from local storage
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
  
  /// Checks if username exists
  static Future<bool> hasUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_usernameKey);
  }
}
