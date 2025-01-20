import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';

class AppTextStyles {
  static TextStyle customStyle({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static const TextStyle whiteBoldText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  static const TextStyle blueBoldText = TextStyle(
    color: AppColors.backgroundBlue,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  static const TextStyle whiteText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );
  static const TextStyle whiteBoldTitleText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
  );

  static const TextStyle whiteBoldCreditText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
    fontFamily: "Baskervville-Regular",
  );
}
