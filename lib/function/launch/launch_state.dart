import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/config/rs_locale.dart';
import 'package:flutter_report_project/utils/network/app_compile_env.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

class LaunchState {
  var currentLanguage = ''.obs;

  var currentEnvIndex = 0.obs;

  List<String> get languages {
    debugPrint("languages = ${S.current.rs_languages_auto}");

    var list = [S.current.rs_languages_auto];
    list.addAll(RSLocale.languagesTitle);

    return list;
  }

  List<String> envList = RSAppCompileEnv.getCurrentEnvList();

  LaunchState() {
    ///Initialize variables
    currentEnvIndex.value = RSAppCompileEnv.getCurrentEnvListIndex();

    currentLanguage.value = languages[RSLocale().localeIndex];
  }
}
