import 'dart:math';
import 'dart:ui';

import '../config/rs_color.dart';

class RSColorUtil {
  /// 格式："0C99FF"、"ff0C99FF"、"#0C99FF"
  /// 透明度：.alpha(0.8)
  static Color hexToColor(String hexString, {double? alpha}) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    if (alpha != null) {
      return Color(int.parse(buffer.toString(), radix: 16)).withOpacity(alpha);
    } else {
      return Color(int.parse(buffer.toString(), radix: 16));
    }
  }

  /// 随机色
  static Color getRandomColor() {
    return Color.fromARGB(
      255,
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
    );
  }

  /// 字符串转颜色：0xFF666666
  static Color convertStringToColor(String? colorString) {
    var tmpColor = RSColor.color_0x60000000;
    if (colorString != null) {
      var colorValue = int.tryParse(colorString);
      if (colorValue != null) {
        tmpColor = Color(colorValue);
      }
    }

    return tmpColor;
  }
}
