import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hive_service.dart';

/// Service for security features: auto-lock, panic button, screenshot protection
class SecurityService {
  static Timer? _autoLockTimer;
  static int _autoLockMinutes = 5;
  static bool _isLocked = true;
  static VoidCallback? _onAutoLock;
  static DateTime? _lastActivityTime;

  // Panic button state
  static DateTime? _volumeDownPressStart;
  static const Duration _panicButtonDuration = Duration(seconds: 5);
  static VoidCallback? _onPanicActivated;

  /// Initializes security service
  static Future<void> init({
    VoidCallback? onAutoLock,
    VoidCallback? onPanicActivated,
  }) async {
    _onAutoLock = onAutoLock;
    _onPanicActivated = onPanicActivated;
    _autoLockMinutes = await HiveService.getAutoLockTime();
    _isLocked = true;
  }

  /// Unlocks the vault and starts auto-lock timer
  static void unlock() {
    _isLocked = false;
    _lastActivityTime = DateTime.now();
    startAutoLockTimer();
  }

  /// Locks the vault
  static void lock() {
    _isLocked = true;
    stopAutoLockTimer();
  }

  /// Checks if vault is locked
  static bool isLocked() => _isLocked;

  /// Updates auto-lock time in minutes
  static Future<void> setAutoLockTime(int minutes) async {
    _autoLockMinutes = minutes;
    await HiveService.setAutoLockTime(minutes);
    
    if (!_isLocked) {
      // Restart timer with new duration
      startAutoLockTimer();
    }
  }

  /// Gets current auto-lock time
  static int getAutoLockTime() => _autoLockMinutes;

  /// Starts or restarts the auto-lock timer
  static void startAutoLockTimer() {
    stopAutoLockTimer();
    
    if (_autoLockMinutes <= 0) return; // Auto-lock disabled

    _autoLockTimer = Timer(
      Duration(minutes: _autoLockMinutes),
      () {
        if (!_isLocked) {
          lock();
          _onAutoLock?.call();
        }
      },
    );
  }

  /// Stops the auto-lock timer
  static void stopAutoLockTimer() {
    _autoLockTimer?.cancel();
    _autoLockTimer = null;
  }

  /// Records user activity to reset auto-lock timer
  static void recordActivity() {
    if (_isLocked) return;
    
    _lastActivityTime = DateTime.now();
    startAutoLockTimer(); // Reset timer
  }

  /// Gets time until auto-lock (in seconds)
  static int getTimeUntilLock() {
    if (_isLocked || _lastActivityTime == null) return 0;
    
    final elapsed = DateTime.now().difference(_lastActivityTime!);
    final remaining = Duration(minutes: _autoLockMinutes) - elapsed;
    
    return remaining.inSeconds.clamp(0, _autoLockMinutes * 60);
  }

  // ============ PANIC BUTTON ============

  /// Handles volume button press (for panic button)
  /// Returns true if panic button activated
  static bool handleVolumeButtonPress(bool isVolumeDown) {
    if (!isVolumeDown) {
      _volumeDownPressStart = null;
      return false;
    }

    if (_volumeDownPressStart == null) {
      _volumeDownPressStart = DateTime.now();
      return false;
    }

    final pressDuration = DateTime.now().difference(_volumeDownPressStart!);
    
    if (pressDuration >= _panicButtonDuration) {
      _volumeDownPressStart = null;
      activatePanicButton();
      return true;
    }

    return false;
  }

  /// Activates panic button - wipes all data
  static Future<void> activatePanicButton() async {
    print('PANIC BUTTON ACTIVATED - WIPING ALL DATA');
    
    // Close vault first
    await HiveService.closeVault();
    
    // Wipe all data
    await HiveService.selfDestruct();
    
    // Notify callback
    _onPanicActivated?.call();
  }

  // ============ SCREENSHOT PROTECTION ============

  /// Method channel for platform-specific features
  static const MethodChannel _securityChannel = MethodChannel('com.encryp.security');

  /// Enables screenshot blocking (Android)
  static Future<void> enableScreenshotProtection() async {
    try {
      // For Android: Add FLAG_SECURE to window
      // For iOS: Not possible, but we can detect screenshot events
      await _securityChannel.invokeMethod('enableScreenshotProtection');
    } catch (e) {
      print('Screenshot protection not available: $e');
    }
  }

  /// Disables screenshot blocking
  static Future<void> disableScreenshotProtection() async {
    try {
      await _securityChannel.invokeMethod('disableScreenshotProtection');
    } catch (e) {
      print('Error disabling screenshot protection: $e');
    }
  }

  // ============ FAILED ATTEMPTS ============

  /// Checks if device should self-destruct due to failed attempts
  static Future<bool> checkFailedAttempts() async {
    final attempts = await HiveService.getFailedAttempts();
    
    if (attempts >= 10) {
      // Self-destruct triggered
      await HiveService.selfDestruct();
      return true;
    }
    
    return false;
  }

  /// Gets remaining attempts before self-destruct
  static Future<int> getRemainingAttempts() async {
    final attempts = await HiveService.getFailedAttempts();
    return (10 - attempts).clamp(0, 10);
  }

  /// Disposes resources
  static void dispose() {
    stopAutoLockTimer();
    _volumeDownPressStart = null;
    _onAutoLock = null;
    _onPanicActivated = null;
  }
}
