import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RSTheme {
  /// key值
  /// 0:auto, 1:Light, 2:Dark
  static const kThemeIndex = 'kThemeIndex';

  /// 用户选择的明暗模式
  int userThemeIndex = 0;

  /// 是否暗黑模式
  static bool isDarkMode = Get.isDarkMode;

  RSTheme() {
    userThemeIndex = SpUtil.getInt(kThemeIndex) ?? 0;
  }

  Future<void> switchDarkMode(int index) async {
    switch (index) {
      case 1:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 2:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }

    // 这里要设置个延迟,在调用切换主题后并不能立刻生效,会有点延迟,
    // 如果不设置延迟会导致取的还是上个主题状态
    Future.delayed(const Duration(milliseconds: 250), () {
      //强制触发 build
      Get.forceAppUpdate();
      debugPrint("RSTheme.switchDarkMode ==> $index ----- Get.isDarkMod:${Get.isDarkMode}");

      isDarkMode = Get.isDarkMode;
    });

    SpUtil.putInt(kThemeIndex, index);
  }

  ThemeMode getCurrentThemeMode() {
    switch (userThemeIndex) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData getCurrentThemeData() {
    switch (userThemeIndex) {
      case 1:
        return lightThemeData;
      case 2:
        return darkThemeData;
      default:
        return Get.isDarkMode ? darkThemeData : lightThemeData;
    }
  }

  static ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    brightness: Brightness.light,
  );

  static ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    brightness: Brightness.dark,
  );

  static ColorScheme lightColorScheme = const ColorScheme.light().copyWith(
    primary: const Color(0xFF5C57E6),
    background: const Color(0xFFFFFFFF),
    // onPrimary: const Color(0xffb00020),
    // primaryContainer: const Color(0xffb00020),
  );

  static ColorScheme darkColorScheme = const ColorScheme.dark().copyWith(
    primary: const Color(0xFF5C57E6),
    background: const Color(0xFF000000),
    // onPrimary: const Color(0xffb00020),
    // primaryContainer: const Color(0xffb00020),
  );

// static const lightColorScheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: Color(0xFF5C57E6),
//   onPrimary: Color(0xFFFFFFFF),
//   //   primaryContainer: Color(0xFFCFE5FF),
//   //   onPrimaryContainer: Color(0xFF001D33),
//   secondary: Color(0xFF526070),
//   onSecondary: Color(0xFFFFFFFF),
//   //   secondaryContainer: Color(0xFFD5E4F7),
//   //   onSecondaryContainer: Color(0xFF0E1D2A),
//   //   tertiary: Color(0xFF695779),
//   //   onTertiary: Color(0xFFFFFFFF),
//   //   tertiaryContainer: Color(0xFFF0DBFF),
//   //   onTertiaryContainer: Color(0xFF231533),
//   error: Color(0xFFBA1A1A),
//   //   errorContainer: Color(0xFFFFDAD6),
//   onError: Color(0xFFFFFFFF),
//   //   onErrorContainer: Color(0xFF410002),
//   background: Color(0xFFFFFFFF),
//   onBackground: Color(0xFFFFFFFF),
//   surface: Color(0xFFFCFCFF),
//   onSurface: Color(0xFFBA1A1A),
//   //   surfaceVariant: Color(0xFFDEE3EB),
//   //   onSurfaceVariant: Color(0xFF42474E),
//   //   outline: Color(0xFF72777F),
//   //   onInverseSurface: Color(0xFFF1F0F4),
//   //   inverseSurface: Color(0xFF2F3033),
//   //   inversePrimary: Color(0xFF99CBFF),
//   //   shadow: Color(0xFF000000),
//   //   surfaceTint: Color(0xFF00629D),
//   //   outlineVariant: Color(0xFFC2C7CF),
//   //   scrim: Color(0xFF000000),
// );

// static const darkColorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: Color(0xFF5C57E6),
//   onPrimary: Color(0xFFFFFFFF),
//   //   primaryContainer: Color(0xFF004A78),
//   //   onPrimaryContainer: Color(0xFFCFE5FF),
//   secondary: Color(0xFFB9C8DA),
//   onSecondary: Color(0xFF243240),
//   //   secondaryContainer: Color(0xFF3A4857),
//   //   onSecondaryContainer: Color(0xFFD5E4F7),
//   //   tertiary: Color(0xFFD4BEE6),
//   //   onTertiary: Color(0xFF392A49),
//   //   tertiaryContainer: Color(0xFF504060),
//   //   onTertiaryContainer: Color(0xFFF0DBFF),
//   error: Color(0xFFBA1A1A),
//   //   errorContainer: Color(0xFF93000A),
//   onError: Color(0xFFFFFFFF),
//   //   onErrorContainer: Color(0xFFFFDAD6),
//   background: Color(0xFF000000),
//   onBackground: Color(0xFF1C1C1D),
//   surface: Color(0xFF1A1C1E),
//   onSurface: Color(0xFFE2E2E5),
//   //   surfaceVariant: Color(0xFF42474E),
//   //   onSurfaceVariant: Color(0xFFC2C7CF),
//   //   outline: Color(0xFF8C9199),
//   //   onInverseSurface: Color(0xFF1A1C1E),
//   //   inverseSurface: Color(0xFFE2E2E5),
//   //   inversePrimary: Color(0xFF00629D),
//   //   shadow: Color(0xFF000000),
//   //   surfaceTint: Color(0xFF99CBFF),
//   //   outlineVariant: Color(0xFF42474E),
//   //   scrim: Color(0xFF000000),
// );
}
