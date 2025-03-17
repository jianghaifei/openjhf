import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/utils/network/app_compile_env.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';
import '../generated/l10n.dart';
import '../router/app_routes.dart';
import '../utils/app_info.dart';
import '../utils/logger/logger_helper.dart';
import '../utils/network/server_url.dart';
import '../utils/toast_manager.dart';
import '../widget/popup_widget/rs_alert/rs_alert_view.dart';

class RSConfig {
  /// 同意隐私协议Key
  static const String hasAgreedToPrivacyPolicy = "hasAgreedToPrivacyPolicy";

  // AI入口开关
  static const String aiSwitch = "PERMISSION_AI_ASSISTANT";

  init() async {
    // 渠道信息
    RSAppInfo().getChannelInfo();

    // 强制竖屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Android 顶部状态栏、底部安全区
    /// 参考文档：https://juejin.cn/post/7090900994023751688
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // 初始化存储
    await flustars.SpUtil.getInstance();

    // 自定义Loading
    ToastManager.configLoading();

    // 软件包信息
    await RSAppInfo().getPackageInfo();

    // 初始化APP环境配置
    await RSAppCompileEnv.initEnvConfig();

    // 隐私协议弹窗
    await privacyAgreementPopUp();
  }

  /// 隐私协议弹窗
  Future<void> privacyAgreementPopUp() async {
    bool hasAgreed = flustars.SpUtil.getBool(RSConfig.hasAgreedToPrivacyPolicy, defValue: false) ?? false;
    if (hasAgreed) {
      await startInitSDK();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bool hasAgreed = flustars.SpUtil.getBool(RSConfig.hasAgreedToPrivacyPolicy, defValue: false) ?? false;

        if (!hasAgreed) {
          Get.dialog(
              RSAlertPopup(
                  title: S.current.rs_login_privacy_agreement,
                  customContentWidget: createPrivacyTextWidget(),
                  alertPopupType: RSAlertPopupType.normal,
                  leftButtonTitle: S.current.rs_disagree,
                  rightButtonTitle: S.current.rs_agree,
                  cancelCallback: () {
                    exit(0);
                  },
                  doneCallback: () async {
                    flustars.SpUtil.putBool(RSConfig.hasAgreedToPrivacyPolicy, true);
                    await RSConfig().startInitSDK();
                    Get.back();
                  }),
              barrierDismissible: false);
        }
      });
    }
  }

  Widget createPrivacyTextWidget() {
    String clickableText = '《${S.current.rs_login_privacy_agreement}》';

    String headString = '${S.current.rs_launch_privacy_alert_head}$clickableText\n';
    String bodyString = headString + S.current.rs_launch_privacy_alert_body;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: bodyString.substring(0, bodyString.indexOf(clickableText)),
            style: TextStyle(
              color: RSColor.color_0x60000000,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: clickableText,
            style: TextStyle(
              color: RSColor.color_0xFF5C57E6,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.webViewPage, arguments: {"url": RSServerUrl.appUserPrivacyPolicyUrl});
              },
          ),
          TextSpan(
            text: bodyString.substring(bodyString.indexOf(clickableText) + clickableText.length),
            style: TextStyle(
              color: RSColor.color_0x60000000,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 开始初始化SDK
  Future<void> startInitSDK() async {
    // logger
    String filePath = await LoggerHelper.getFilePath();
    LoggerHelper.init(finalPath: filePath);

    // 设备信息
    await RSAppInfo().getDeviceInfo();

    // 初始化firebase
    if (RSAppInfo().channel == RSAppInfoChannel.global) {
      initFirebase();
    }
  }

  /// 初始化firebase
  Future<void> initFirebase() async {
    logger.d("初始化 Firebase", StackTrace.current);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      logger.e(errorDetails, StackTrace.current);
    };
    // 将Flutter框架未处理的所有未捕获的异步错误传递给Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      logger.e(error, stack);
      return true;
    };
  }
}
