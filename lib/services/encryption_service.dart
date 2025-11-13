import 'dart:convert';

/// Service for encrypting and decrypting text using custom shift cipher + Base64 + ROT13
class EncryptionService {
  /// Encrypts text using custom shift cipher, Base64, then ROT13
  static String encrypt(String plainText, String passcode) {
    if (plainText.isEmpty) return '';
    if (passcode.isEmpty) return '';
    
    // Step 1: Apply custom shift cipher based on passcode
    String shiftedText = _applyCustomShift(plainText, passcode, false);
    
    // Step 2: Apply Base64 encoding
    String base64Text = base64.encode(utf8.encode(shiftedText));
    
    // Step 3: Apply ROT13
    String rot13Text = _applyRot13(base64Text);
    
    return rot13Text;
  }
  
  /// Decrypts text that was encrypted with custom shift cipher + Base64 + ROT13
  static String decrypt(String encryptedText, String passcode) {
    if (encryptedText.isEmpty) return '';
    if (passcode.isEmpty) return '';
    
    try {
      // Step 1: Reverse ROT13
      String base64Text = _applyRot13(encryptedText);
      
      // Step 2: Decode Base64
      String shiftedText = utf8.decode(base64.decode(base64Text));
      
      // Step 3: Reverse custom shift cipher
      String plainText = _applyCustomShift(shiftedText, passcode, true);
      
      return plainText;
    } catch (e) {
      return 'Error: Invalid encrypted text or wrong passcode';
    }
  }
  
  /// Applies custom shift cipher based on passcode digits
  /// Each character is shifted by the corresponding passcode digit
  /// The passcode pattern repeats for the entire text
  static String _applyCustomShift(String input, String passcode, bool reverse) {
    StringBuffer output = StringBuffer();
    List<int> shifts = passcode.split('').map((c) => int.tryParse(c) ?? 0).toList();
    
    if (shifts.isEmpty) return input;
    
    for (int i = 0; i < input.length; i++) {
      int char = input.codeUnitAt(i);
      int shift = shifts[i % shifts.length];
      
      if (reverse) shift = -shift;
      
      // Uppercase letters (A-Z)
      if (char >= 65 && char <= 90) {
        output.writeCharCode(((char - 65 + shift) % 26 + 26) % 26 + 65);
      }
      // Lowercase letters (a-z)
      else if (char >= 97 && char <= 122) {
        output.writeCharCode(((char - 97 + shift) % 26 + 26) % 26 + 97);
      }
      // Non-alphabetic characters remain unchanged
      else {
        output.writeCharCode(char);
      }
    }
    
    return output.toString();
  }
  
  /// Applies ROT13 cipher to the input string
  /// ROT13 rotates letters by 13 positions in the alphabet
  static String _applyRot13(String input) {
    StringBuffer output = StringBuffer();
    
    for (int i = 0; i < input.length; i++) {
      int char = input.codeUnitAt(i);
      
      // Uppercase letters (A-Z)
      if (char >= 65 && char <= 90) {
        output.writeCharCode(((char - 65 + 13) % 26) + 65);
      }
      // Lowercase letters (a-z)
      else if (char >= 97 && char <= 122) {
        output.writeCharCode(((char - 97 + 13) % 26) + 97);
      }
      // Non-alphabetic characters remain unchanged
      else {
        output.writeCharCode(char);
      }
    }
    
    return output.toString();
  }
}
