/*
 * #                                                   #
 * #                       _oo0oo_                     #
 * #                      o8888888o                    #
 * #                      88" . "88                    #
 * #                      (| -_- |)                    #
 * #                      0\  =  /0                    #
 * #                    ___/`---'\___                  #
 * #                  .' \\|     |// '.                #
 * #                 / \\|||  :  |||// \               #
 * #                / _||||| -:- |||||- \              #
 * #               |   | \\\  -  /// |   |             #
 * #               | \_|  ''\---/''  |_/ |             #
 * #               \  .-\__  '-'  ___/-. /             #
 * #             ___'. .'  /--.--\  `. .'___           #
 * #          ."" '<  `.___\_<|>_/___.' >' "".         #
 * #         | | :  `- \`.;`\ _ /`;.`/ - ` : | |       #
 * #         \  \ `_.   \_ __\ /__ _/   .-` /  /       #
 * #     =====`-.____`.___ \_____/___.-`___.-'=====    #
 * #                       `=---='                     #
 * #     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #
 * #                                                   #
 * #              佛祖保佑            永无BUG            #
 * #                                                   #
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_report_project/config/rs_theme.dart';
import 'package:flutter_report_project/router/app_routes.dart';
import 'package:flutter_report_project/utils/app_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'binding/all_controller_binding.dart';
import 'config/rs_config.dart';
import 'config/rs_locale.dart';
import 'function/login/account_manager/account_manager.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RSConfig().init();

  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 隐藏底部操作栏、保留顶部状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return GetMaterialApp(
            title: RSAppInfo().appName,
            theme: RSTheme.lightThemeData,
            initialBinding: AllControllerBinding(),
            initialRoute:
                RSAccountManager().userInfoEntity?.accessToken != null ? AppRoutes.mainPage : AppRoutes.launchPage,
            getPages: AppRoutes.routes,
            locale: RSLocale().locale,
            fallbackLocale: RSAppInfo().channel == RSAppInfoChannel.global
                ? const Locale.fromSubtags(languageCode: 'en')
                : const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            builder: EasyLoading.init(),
            defaultTransition: Transition.rightToLeft,
          );
        });
  }
}

class AppCatchError {
  void run(Widget app) {
    /* 参考文章

     */
    /**
     * 参考文章
     * https://www.sohu.com/a/507677603_612370
     *
     * 从 Flutter 3.10 开始，框架在使用 Zones 时会检测到不匹配，并在调试版本中将其报告给控制台。
     * https://docs.flutter.dev/release/breaking-changes/zone-errors
     */

    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = (FlutterErrorDetails details) {
          debugPrint("当前环境：$kReleaseMode");
          String errorString = "";
          if (details.stack != null) {
            errorString = details.stack.toString();
          } else {
            errorString = details.exception.toString();
          }

          debugPrint("❌ 发现错误:\n$errorString");
          // RTCrashHandler.uploadCrashInfo(errorString);
        };
        runApp(app);
      },
      (Object error, StackTrace stack) {
        catchError(error, stack);
      },
    );
  }

  /// 对搜集的 异常进行处理  上报等等
  void catchError(Object error, StackTrace stack) {
    String errorStr = "${error.toString()}\n${stack.toString()}";
    debugPrint("AppCatchError >>>>>>>>>>: $kReleaseMode \n $errorStr");
    // RTCrashHandler.uploadCrashInfo(errorStr);
  }
}
