import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RSLocale {
  ///配置语言语种
  static const localeValueList = ['', 'zh_CN', 'en_US', 'es', 'it_IT', 'nl', 'de_DE', 'vi_VN', 'ru'];

  ///支持切换的语言列表
  static const languagesTitle = [
    '简体中文',
    'English',
    'Español',
    'Italiano',
    'Nederlands',
    'Deutsch',
    'Tiếng Việt',
    'Русский язык'
  ];

  ///本地语言选择的 key值
  static const kLocaleIndex = 'kLocaleIndex';

  int _localeIndex = 0;

  int get localeIndex => _localeIndex;

  Locale? get locale {
    if (_localeIndex > 0) {
      var value = localeValueList[_localeIndex].split("_");
      var tmpLocale = Locale(value[0], value.length == 2 ? value[1] : null);
      return tmpLocale;
    }

    // 跟随系统
    var deviceLocale = Get.deviceLocale;
    for (var element in localeValueList) {
      if (element.startsWith("${deviceLocale?.languageCode}")) {
        var value = element.split("_");
        return Locale(value.first, value.last);
      }
    }

    // 跟随系统
    return Get.deviceLocale;
  }

  RSLocale() {
    _localeIndex = SpUtil.getInt(kLocaleIndex) ?? 0;
  }

  Future<void> switchLocale(int index) async {
    debugPrint("RSLocale.switchLocale ==> $index");
    _localeIndex = index;

    SpUtil.putInt(kLocaleIndex, index);

    if (locale != null) {
      await Get.updateLocale(locale!);
    }
  }
}
