import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C00);
  static const Color primaryLight = Color(0xFFFFAD33);
  static const Color primaryDark = Color(0xFFE07800);

  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color(0xFF7EDDD6);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentYellow = Color(0xFFFFE66D);
  static const Color accentPurple = Color(0xFF9B59B6);
  static const Color accentGreen = Color(0xFF27AE60);
  static const Color accentBlue = Color(0xFF3498DB);

  static const Color bgLight = Color(0xFFFFF8F0);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgDark = Color(0xFF2C3E50);

  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color botakoin = Color(0xFFFFD700);
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);

  static const Color almaty = Color(0xFF27AE60);
  static const Color astana = Color(0xFF3498DB);
  static const Color turkestan = Color(0xFFE67E22);
  static const Color charyn = Color(0xFFE74C3C);
  static const Color steppe = Color(0xFFF39C12);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFFF6B6B), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient desertGradient = LinearGradient(
    colors: [Color(0xFFFFF8F0), Color(0xFFFFE4B5), Color(0xFFFFD700)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
