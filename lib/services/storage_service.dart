import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving encrypted login credentials
class StorageService {
  static const String _credentialsKey = 'encrypted_credentials';
  static const String _usernameKey = 'user_name';
  static const String _profilePictureKey = 'profile_picture_path';
  static const String _friendsKey = 'friends_list';
  static const String _encryptCountKey = 'encrypt_count';
  static const String _decryptCountKey = 'decrypt_count';
  static const String _encryptedBytesKey = 'encrypted_bytes';
  static const String _decryptedBytesKey = 'decrypted_bytes';
  
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
  
  /// Saves profile picture path
  static Future<void> saveProfilePicture(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePictureKey, path);
  }
  
  /// Retrieves profile picture path
  static Future<String?> getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePictureKey);
  }
  
  /// Saves friends list (list of usernames)
  static Future<void> saveFriends(List<String> friends) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_friendsKey, friends);
  }
  
  /// Loads friends list
  static Future<List<String>> loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_friendsKey) ?? [];
  }
  
  /// Adds a friend
  static Future<void> addFriend(String friendUsername) async {
    final friends = await loadFriends();
    if (!friends.contains(friendUsername)) {
      friends.add(friendUsername);
      await saveFriends(friends);
    }
  }
  
  /// Removes a friend
  static Future<void> removeFriend(String friendUsername) async {
    final friends = await loadFriends();
    friends.remove(friendUsername);
    await saveFriends(friends);
  }
  
  /// Increments encryption count
  static Future<void> incrementEncryptCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_encryptCountKey) ?? 0;
    await prefs.setInt(_encryptCountKey, current + 1);
  }
  
  /// Increments decryption count
  static Future<void> incrementDecryptCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_decryptCountKey) ?? 0;
    await prefs.setInt(_decryptCountKey, current + 1);
  }
  
  /// Adds encrypted bytes to total
  static Future<void> addEncryptedBytes(int bytes) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_encryptedBytesKey) ?? 0;
    await prefs.setInt(_encryptedBytesKey, current + bytes);
  }
  
  /// Adds decrypted bytes to total
  static Future<void> addDecryptedBytes(int bytes) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_decryptedBytesKey) ?? 0;
    await prefs.setInt(_decryptedBytesKey, current + bytes);
  }
  
  /// Gets encryption statistics
  static Future<Map<String, int>> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'encryptCount': prefs.getInt(_encryptCountKey) ?? 0,
      'decryptCount': prefs.getInt(_decryptCountKey) ?? 0,
      'encryptedBytes': prefs.getInt(_encryptedBytesKey) ?? 0,
      'decryptedBytes': prefs.getInt(_decryptedBytesKey) ?? 0,
    };
  }
}
