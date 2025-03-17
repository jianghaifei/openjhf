import 'package:flutter/material.dart';

class RSColor {
  static const Color color_0xFFD54941 = Color(0xFFD54941);
  static const Color color_0xFF2BA471 = Color(0xFF2BA471);
  static const Color color_0xFF5C57E6 = Color(0xFF5C57E6);
  static const Color color_0xFFFFFFFF = Color(0xFFFFFFFF);
  static const Color color_0xFF000000 = Color(0xFF000000);

  static const Color color_0xFFF9F9F9 = Color(0xFFF9F9F9); // Gray1
  static const Color color_0xFFF3F3F3 = Color(0xFFF3F3F3); // Gray2
  static const Color color_0xFFE7E7E7 = Color(0xFFE7E7E7); // Gray3
  static const Color color_0xFFDCDCDC = Color(0xFFDCDCDC); // Gray4

  static const Color color_0x90000000 = Color(0xE6000000); // Font Gy1
  static const Color color_0x60000000 = Color(0x99000000); // Font Gy2
  static const Color color_0x40000000 = Color(0x66000000); // Font Gy3
  static const Color color_0x26000000 = Color(0x42000000); // Font Gy4

  // static const Color chartOriginalColor = color_0xFF5C57E6;
  // static const Color chartDayCompareColor = Color(0xFFFFA800);
  // static const Color chartWeekCompareColor = Color(0xFF14C9C9);
  // static const Color chartMonthCompareColor = Color(0xFFB062FF);
  // static const Color chartYearCompareColor = Color(0xFFFFD916);

  static const Color dataGridFooterCellColor = Color(0xFFFCF1E8);

  static const listColor1 = color_0xFF5C57E6;
  static const listColor2 = Color(0xFFFFA800);
  static const listColor3 = Color(0xFF14C9C9);
  static const listColor4 = Color(0xFFB062FF);
  static const listColor5 = Color(0xFFFFD916);
  static const listColor6 = Color(0xFF3490F9);
  static const listColor7 = Color(0xFF35EBB5);
  static const listColor8 = Color(0xFFEB6C99);
  static const listColor9 = Color(0xFFEAFB86);
  static const listColor10 = Color(0xFF6CA5AB);
  static const listColor11 = Color(0xFF81D065);
  static const listColor12 = Color(0xFFF45757);
  static const listColorOther = color_0xFFF3F3F3;

  static const chartColors = [
    RSColor.listColor1,
    RSColor.listColor2,
    RSColor.listColor3,
    RSColor.listColor4,
    RSColor.listColor5,
    RSColor.listColor6,
    RSColor.listColor7,
    RSColor.listColor8,
    RSColor.listColor9,
    RSColor.listColor10,
    RSColor.listColor11,
    RSColor.listColor12,
  ];

  static Color getChartColor(int index) {
    // 使用取模运算计算有效下标
    int validIndex = index % chartColors.length;
    var tmpColor = chartColors[validIndex];
    return tmpColor;
  }

/*
  // static Color get color_0xFFFFFFFF => getColor('primary');

  // static Color get color_0xFFFFFFFF => getColor('cardColor');

  // static Color get card_0x0D000000 => getColor('cardShadow');

  // static Color get color_0xFF000000 => getColor('blackTitle');

  // static Color get color_0xFFFFFFFF => getColor('whiteTitle');

  // static Color get color_0xFF333333 => getColor('title');

  // static Color get color_0xFF666666 => getColor('content');

  // static Color get color_0xFF939DA7 => getColor('smallText');

  // static Color get color_0xFF5C57E6 => getColor('themeColor');

  // static Color get color_0xFF6F77A4 => getColor('optionText');

  // static Color get color_0xFFF7F8FB => getColor('optionBgColor');


  static Color getColor(String colorName) {
    if (RSTheme.isDarkMode) {
      return RSColor.darkColorScheme[colorName]!;
    } else {
      return RSColor.lightColorScheme[colorName]!;
    }
  }

  static const lightColorScheme = {
    'primary': Color(0xFFFFFFFF),
    'cardColor': Color(0xFFFFFFFF),
    'cardShadow': Color(0x0D000000),
    'blackTitle': Color(0xFF000000),
    'whiteTitle': Color(0xFFFFFFFF),
    'title': Color(0xFF333333),
    'content': Color(0xFF666666),
    'smallText': Color(0xFF939DA7),
    'themeColor': Color(0xFF5C57E6),
    'optionText': Color(0xFF6F77A4),
    'optionBgColor': Color(0xFFF7F8FB),
  };

  static const darkColorScheme = {
    'primary': Color(0xFF000000),
    'cardColor': Color(0xFF1C1C1D),
    'cardShadow': Color(0x00000000),
    'blackTitle': Color(0xFFFFFFFF),
    'whiteTitle': Color(0xFF000000),
    'title': Color(0xFFFFFFFF),
    'content': Color(0xFF666666),
    'smallText': Color(0xFF939DA7),
    'themeColor': Color(0xFF5C57E6),
    'optionText': Color(0xFF5C57E6),
    'optionBgColor': Color(0xFF3A3E49),
  };

   */
}
