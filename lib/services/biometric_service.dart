import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// Service for biometric authentication (Face ID / Fingerprint)
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if device supports biometric authentication
  static Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Gets list of available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticates user with biometrics
  /// Returns true if authentication successful
  static Future<bool> authenticate({
    String reason = 'Authenticate to access your secure vault',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: true,
        ),
      );
    } on Exception catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }

  /// Stops any ongoing authentication
  static Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      print('Error stopping authentication: $e');
    }
  }

  /// Gets human-readable biometric type name
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
      default:
        return 'Biometric';
    }
  }

  /// Gets icon name for biometric type
  static String getBiometricIcon(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'face';
      case BiometricType.fingerprint:
        return 'fingerprint';
      default:
        return 'security';
    }
  }

  /// Checks if Face ID is available
  static Future<bool> isFaceIDAvailable() async {
    final types = await getAvailableBiometrics();
    return types.contains(BiometricType.face);
  }

  /// Checks if fingerprint is available
  static Future<bool> isFingerprintAvailable() async {
    final types = await getAvailableBiometrics();
    return types.contains(BiometricType.fingerprint);
  }
}
