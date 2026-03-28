import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark theme ────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkText = Color(0xFFE6EDF3);
  static const Color darkTextSecondary = Color(0xFF8B949E);

  // ── Light theme ───────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // ── Shared ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);
  static const Color accent = Color(0xFFFF6584);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ── Blur / Glass ──────────────────────────────────────────────────────────
  static const Color blurDark = Color(0x1AFFFFFF); // white 10%
  static const Color blurLight = Color(0xB3FFFFFF); // white 70%
  static const Color blurBorderDark = Color(0x33FFFFFF); // white 20%
  static const Color blurBorderLight = Color(0x66FFFFFF); // white 40%

  // ── Gradient ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFAA8FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF161B2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
