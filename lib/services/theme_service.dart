import 'package:flutter/material.dart';

/// Service providing custom themes for cybersecurity aesthetics
class ThemeService {
  /// Available theme modes
  static const Map<String, AppTheme> themes = {
    'kali_purple': AppTheme(
      id: 'kali_purple',
      name: 'Kali Purple',
      description: 'Inspired by Kali Linux Purple',
      background: Color(0xFF0B0B0F),
      surface: Color(0xFF1A1A24),
      primary: Color(0xFF7B68EE),
      secondary: Color(0xFFAB7FFF),
      accent: Color(0xFF9370DB),
      textPrimary: Color(0xFFE0E0E0),
      textSecondary: Color(0xFFB0B0B0),
      success: Color(0xFF7FFF00),
      error: Color(0xFFFF4444),
      warning: Color(0xFFFFA500),
    ),
    'parrot_os': AppTheme(
      id: 'parrot_os',
      name: 'Parrot OS',
      description: 'Inspired by Parrot Security OS',
      background: Color(0xFF0D1117),
      surface: Color(0xFF161B22),
      primary: Color(0xFF00D9FF),
      secondary: Color(0xFF00C2FF),
      accent: Color(0xFF00BFFF),
      textPrimary: Color(0xFFF0F0F0),
      textSecondary: Color(0xFFB8B8B8),
      success: Color(0xFF00FF88),
      error: Color(0xFFFF3366),
      warning: Color(0xFFFFCC00),
    ),
    'black_hat': AppTheme(
      id: 'black_hat',
      name: 'Black Hat',
      description: 'Pure black terminal aesthetic',
      background: Color(0xFF000000),
      surface: Color(0xFF0A0A0A),
      primary: Color(0xFF00FF00),
      secondary: Color(0xFF33FF33),
      accent: Color(0xFF00DD00),
      textPrimary: Color(0xFF00FF00),
      textSecondary: Color(0xFF00AA00),
      success: Color(0xFF00FF00),
      error: Color(0xFFFF0000),
      warning: Color(0xFFFFFF00),
    ),
    'matrix': AppTheme(
      id: 'matrix',
      name: 'Matrix',
      description: 'The Matrix green theme',
      background: Color(0xFF000000),
      surface: Color(0xFF001100),
      primary: Color(0xFF00FF41),
      secondary: Color(0xFF00DD33),
      accent: Color(0xFF00FF00),
      textPrimary: Color(0xFF00FF41),
      textSecondary: Color(0xFF008F11),
      success: Color(0xFF00FF00),
      error: Color(0xFFFF0000),
      warning: Color(0xFFFFAA00),
    ),
    'cyberpunk': AppTheme(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      description: 'Neon cyberpunk aesthetic',
      background: Color(0xFF0A0A1F),
      surface: Color(0xFF141428),
      primary: Color(0xFFFF00FF),
      secondary: Color(0xFF00FFFF),
      accent: Color(0xFFFF00AA),
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFCCCCFF),
      success: Color(0xFF00FF88),
      error: Color(0xFFFF0080),
      warning: Color(0xFFFFFF00),
    ),
    'redteam': AppTheme(
      id: 'redteam',
      name: 'Red Team',
      description: 'Offensive security red theme',
      background: Color(0xFF0F0000),
      surface: Color(0xFF1A0505),
      primary: Color(0xFFFF0000),
      secondary: Color(0xFFCC0000),
      accent: Color(0xFFFF3333),
      textPrimary: Color(0xFFFFDDDD),
      textSecondary: Color(0xFFCCAAAA),
      success: Color(0xFF00FF00),
      error: Color(0xFFFF0000),
      warning: Color(0xFFFF6600),
    ),
    'blueteam': AppTheme(
      id: 'blueteam',
      name: 'Blue Team',
      description: 'Defensive security blue theme',
      background: Color(0xFF000510),
      surface: Color(0xFF050A1A),
      primary: Color(0xFF0080FF),
      secondary: Color(0xFF0066CC),
      accent: Color(0xFF3399FF),
      textPrimary: Color(0xFFDDEEFF),
      textSecondary: Color(0xFFAABBCC),
      success: Color(0xFF00CC00),
      error: Color(0xFFFF4444),
      warning: Color(0xFFFFAA00),
    ),
    'dracula': AppTheme(
      id: 'dracula',
      name: 'Dracula',
      description: 'Popular Dracula theme',
      background: Color(0xFF282A36),
      surface: Color(0xFF343746),
      primary: Color(0xFFBD93F9),
      secondary: Color(0xFFFF79C6),
      accent: Color(0xFF8BE9FD),
      textPrimary: Color(0xFFF8F8F2),
      textSecondary: Color(0xFF6272A4),
      success: Color(0xFF50FA7B),
      error: Color(0xFFFF5555),
      warning: Color(0xFFFFB86C),
    ),
    'nord': AppTheme(
      id: 'nord',
      name: 'Nord',
      description: 'Arctic nord theme',
      background: Color(0xFF2E3440),
      surface: Color(0xFF3B4252),
      primary: Color(0xFF88C0D0),
      secondary: Color(0xFF81A1C1),
      accent: Color(0xFF5E81AC),
      textPrimary: Color(0xFFECEFF4),
      textSecondary: Color(0xFFD8DEE9),
      success: Color(0xFFA3BE8C),
      error: Color(0xFFBF616A),
      warning: Color(0xFFEBCB8B),
    ),
    'hacker_green': AppTheme(
      id: 'hacker_green',
      name: 'Hacker Green',
      description: 'Classic terminal green on black',
      background: Color(0xFF000000),
      surface: Color(0xFF0A0F0A),
      primary: Color(0xFF33FF33),
      secondary: Color(0xFF00DD00),
      accent: Color(0xFF00FF00),
      textPrimary: Color(0xFF33FF33),
      textSecondary: Color(0xFF00AA00),
      success: Color(0xFF00FF00),
      error: Color(0xFFFF3333),
      warning: Color(0xFFFFDD00),
    ),
  };

  /// Gets theme by ID
  static AppTheme? getTheme(String id) {
    return themes[id];
  }

  /// Gets all available themes
  static List<AppTheme> getAllThemes() {
    return themes.values.toList();
  }

  /// Converts AppTheme to Flutter ThemeData
  static ThemeData toThemeData(AppTheme appTheme) {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        background: appTheme.background,
        surface: appTheme.surface,
        primary: appTheme.primary,
        secondary: appTheme.secondary,
        tertiary: appTheme.accent,
        error: appTheme.error,
        onBackground: appTheme.textPrimary,
        onSurface: appTheme.textPrimary,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: appTheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: appTheme.background,
        foregroundColor: appTheme.textPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: appTheme.textPrimary,
          letterSpacing: 3,
        ),
      ),
      cardTheme: CardThemeData(
        color: appTheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: appTheme.textPrimary, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appTheme.surface,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: appTheme.textPrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: appTheme.textPrimary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: appTheme.primary, width: 3),
        ),
        labelStyle: TextStyle(
          fontFamily: 'monospace',
          color: appTheme.textPrimary,
          letterSpacing: 2,
        ),
        hintStyle: TextStyle(
          fontFamily: 'monospace',
          color: appTheme.textSecondary.withOpacity(0.5),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontFamily: 'monospace', color: appTheme.textPrimary),
        bodyMedium: TextStyle(fontFamily: 'monospace', color: appTheme.textPrimary),
        bodySmall: TextStyle(fontFamily: 'monospace', color: appTheme.textSecondary),
        titleLarge: TextStyle(
          fontFamily: 'monospace',
          color: appTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'monospace',
          color: appTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(fontFamily: 'monospace', color: appTheme.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appTheme.primary,
          side: BorderSide(color: appTheme.primary, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appTheme.surface,
        contentTextStyle: TextStyle(
          fontFamily: 'monospace',
          color: appTheme.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: appTheme.primary, width: 2),
        ),
      ),
      dividerColor: appTheme.textSecondary.withOpacity(0.3),
      iconTheme: IconThemeData(color: appTheme.textPrimary),
    );
  }
}

/// App theme model
class AppTheme {
  final String id;
  final String name;
  final String description;
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color error;
  final Color warning;

  const AppTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.error,
    required this.warning,
  });
}
