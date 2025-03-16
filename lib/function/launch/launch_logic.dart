import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:get/get.dart';

import '../../config/rs_locale.dart';
import '../../utils/network/app_compile_env.dart';
import '../../utils/network/server_url.dart';
import 'launch_state.dart';

class LaunchLogic extends GetxController {
  final LaunchState state = LaunchState();

  @override
  void onReady() {
    reloadEnv();
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  void refreshCurrentLanguage() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      state.currentLanguage.value = state.languages[RSLocale().localeIndex];
    });
  }

  void reloadEnv() {
    state.envList = RSAppCompileEnv.getCurrentEnvList();
  }

  // 切换APP域名配置
  void switchEnvType(String envString) {
    RSAppCompileEnv.modifyEnvType(envString);
    RSServerUrl.initDomainUrl();
  }
}
