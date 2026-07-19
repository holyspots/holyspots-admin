import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // HolySpots design tokens (from mockup)
  static const primary = Color(0xFF00ACE8);       // cyan accent, active tabs
  static const primaryLight = Color(0xFF47BFED); // action buttons (Save, OK)
  static const primaryDark = Color(0xFF0090C4);
  static const menu = Color(0xFFDCE8EC);          // horizontal nav background
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const sidebar = Color(0xFFDCE8EC);       // (legacy) menu background
  static const border = Color(0xFFDCE8EC);        // input borders
  static const inputBorder = Color(0xFFDCE8EC);
  static const textPrimary = Color(0xFF575F6A);   // body text
  static const textSecondary = Color(0xFF9B9B9B); // hints, muted
  static const titleBar = Color(0xFFF5F5F5);
  static const titleBarBorder = Color(0xFFE1E1E1);
  static const error = Color(0xFFFE835D);         // orange error, delete buttons
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const tableHeader = Color(0xFFF5F5F5);
  static const tableRowAlt = Color(0xFFFAFAFA);
}
