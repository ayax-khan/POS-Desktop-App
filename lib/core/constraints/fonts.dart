import 'package:flutter/material.dart';
import 'package:pos/core/constraints/colors.dart';

class AppFonts {
  static const String primaryFont = 'Roboto';

  static TextStyle get appBarTitle => const TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle get appBarSecondary => const TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );
  static const TextStyle bodyExcelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyText => const TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    color: Colors.black87,
  );
}
