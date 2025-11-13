import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving the master passcode
class PasscodeService {
  static const String _passcodeKey = 'master_passcode';
  
  /// Saves the master passcode
  static Future<void> savePasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passcodeKey, passcode);
  }
  
  /// Loads the master passcode
  static Future<String?> loadPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passcodeKey);
  }
  
  /// Checks if a passcode has been set
  static Future<bool> hasPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_passcodeKey);
  }
  
  /// Verifies if the provided passcode matches the stored one
  static Future<bool> verifyPasscode(String passcode) async {
    final storedPasscode = await loadPasscode();
    return storedPasscode == passcode;
  }
  
  /// Clears the stored passcode (for reset purposes)
  static Future<void> clearPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_passcodeKey);
  }
}
