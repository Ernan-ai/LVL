import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for storing and retrieving chat messages
/// Note: This is a local-only implementation for demo purposes
/// Real chat would require a backend server for real-time messaging
class ChatService {
  static const String _messagesPrefix = 'chat_messages_';
  
  /// Saves a message to a conversation
  static Future<void> sendMessage({
    required String friendUsername,
    required String message,
    required bool isSentByMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _messagesPrefix + friendUsername;
    
    final messages = await getMessages(friendUsername);
    messages.add({
      'message': message,
      'isSentByMe': isSentByMe,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    final serialized = messages.map((msg) => jsonEncode(msg)).toList();
    await prefs.setStringList(key, serialized);
  }
  
  /// Retrieves all messages for a conversation
  static Future<List<Map<String, dynamic>>> getMessages(String friendUsername) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _messagesPrefix + friendUsername;
    
    final serialized = prefs.getStringList(key);
    if (serialized == null) return [];
    
    return serialized.map((item) {
      return Map<String, dynamic>.from(jsonDecode(item));
    }).toList();
  }
  
  /// Clears all messages for a conversation
  static Future<void> clearConversation(String friendUsername) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _messagesPrefix + friendUsername;
    await prefs.remove(key);
  }
}
