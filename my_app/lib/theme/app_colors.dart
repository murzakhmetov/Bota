import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C00);       // Warm orange
  static const Color primaryLight = Color(0xFFFFAD33);   // Light orange
  static const Color primaryDark = Color(0xFFE07800);    // Dark orange
  
  static const Color secondary = Color(0xFF4ECDC4);      // Teal/turquoise
  static const Color secondaryLight = Color(0xFF7EDDD6); // Light teal
  
  static const Color accent = Color(0xFFFF6B6B);         // Coral red
  static const Color accentYellow = Color(0xFFFFE66D);   // Sunny yellow
  static const Color accentPurple = Color(0xFF9B59B6);   // Purple
  static const Color accentGreen = Color(0xFF27AE60);    // Green
  static const Color accentBlue = Color(0xFF3498DB);     // Blue
  
  static const Color bgLight = Color(0xFFFFF8F0);        // Warm white
  static const Color bgCard = Color(0xFFFFFFFF);         // White
  static const Color bgDark = Color(0xFF2C3E50);         // Dark blue-gray
  
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFFFFFFF);
  
  static const Color botakoin = Color(0xFFFFD700);       // Gold for botakoins
  static const Color success = Color(0xFF27AE60);        // Green success
  static const Color error = Color(0xFFE74C3C);          // Red error
  
  static const Color almaty = Color(0xFF27AE60);         // Green - mountains
  static const Color astana = Color(0xFF3498DB);         // Blue - Baiterek
  static const Color turkestan = Color(0xFFE67E22);      // Orange - mausoleum
  static const Color charyn = Color(0xFFE74C3C);         // Red - canyon
  static const Color steppe = Color(0xFFF39C12);         // Yellow - yurt/steppe
  
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
