import 'package:flutter/material.dart';

const PRIMARY_COLOR = Color(0xFF0DB2B2);
final LIGHT_GREY_COLOR = Colors.grey[200]!;
final DARK_GREY_COLOR = Colors.grey[600]!;
final TEXT_FIELD_FILL_COLOR = Colors.grey[300]!;

class AppThemeColors {
  static const pastelPeach = Color(0xFFFFE0B2);   // 살구
  static const softMint = Color(0xFFB2DFDB);      // 민트
  static const babyPurple = Color(0xFFE1BEE7);    // 연보라
  static const softCream = Color(0xFFFFF9C4);     // 크림
  static const skyBlue = Color(0xFFB3E5FC);       // 하늘
}

class AppTheme { // 앱의 테마 1개를 정의하는 틀.
  final String name;
  final Color primaryColor;
  final Color backgroundColor;

  const AppTheme({ // 테마의 이름, 사용하는 색상, 배경 색상이 필요하다고 선언
    required this.name,
    required this.primaryColor,
    required this.backgroundColor,
  });
}

final List<AppTheme> availableThemes = [ // 사용자가 고를 수 있는 테마 목록
  AppTheme(
    name: 'Peach',
    primaryColor: AppThemeColors.pastelPeach,
    backgroundColor: Colors.white,
  ),
  AppTheme(
    name: 'Mint',
    primaryColor: AppThemeColors.softMint,
    backgroundColor: Colors.white,
  ),
  AppTheme(
    name: 'Purple',
    primaryColor: AppThemeColors.babyPurple,
    backgroundColor: Colors.white,
  ),
  AppTheme(Sㅎ
    name: 'Cream',
    primaryColor: AppThemeColors.softCream,
    backgroundColor: Colors.white,
  ),
  AppTheme(
    name: 'Sky Blue',
    primaryColor: AppThemeColors.skyBlue,
    backgroundColor: Colors.white,
  ),
];
