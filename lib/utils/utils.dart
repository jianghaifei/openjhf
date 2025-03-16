import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RSUtils {
  /// 隐藏键盘
  static void hideKeyboard() {
    if (Get.context != null) {
      final currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  /// enum to string
  static String enumToString<T>(T enumValue) {
    return enumValue.toString().split('.').last;
  }

  /// string to enum
  static T? enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
        orElse: () => throw Exception('Unable to find $value in enum'));
  }

  /// 截断双精度
  static double truncateDouble(double number, {int fractionDigits = 2}) {
    num mod = pow(10, fractionDigits);
    return ((number * mod).toInt().toDouble()) / mod;
  }

  /// 截断双精度并补零
  static String truncateDoubleToString(double value, {int fractionDigits = 2}) {
    num mod = pow(10, fractionDigits);
    double newValue = ((value * mod).toInt().toDouble()) / mod;
    return newValue.toStringAsFixed(fractionDigits);
  }

  static Future<void> launchURL(String url, VoidCallback errorCallback) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      errorCallback();
    }
  }
}
