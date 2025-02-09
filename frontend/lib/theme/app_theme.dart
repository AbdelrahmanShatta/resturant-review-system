import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines the application's theme including colors, text styles, and component themes.
/// This class provides a centralized location for all theme-related configurations.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color constants for the application theme
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2D3142);
  static const Color subtitleColor = Color(0xFF9E9E9E);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);

  /// Returns the light theme configuration for the application.
  /// This includes settings for colors, text styles, and component themes.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // Card theme configuration
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Text theme configuration using Google Fonts
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: const TextStyle(
          color: textColor,
        ),
        bodyMedium: const TextStyle(
          color: subtitleColor,
        ),
      ),
      
      // AppBar theme configuration
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: textColor,
        ),
      ),
      
      // Input decoration theme configuration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(true),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      // Elevated button theme configuration
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Helper method to build consistent input borders
  static OutlineInputBorder _buildInputBorder([bool isFocused = false]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: isFocused 
          ? const BorderSide(color: primaryColor, width: 2)
          : BorderSide.none,
    );
  }
} 