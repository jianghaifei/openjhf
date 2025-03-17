import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/app_info.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:flutter_report_project/utils/version_check/rs_app_version_entity.dart';
import 'package:get/get.dart';

import '../../config/rs_locale.dart';
import '../../function/login/account_manager/account_manager.dart';
import '../../generated/l10n.dart';
import '../../router/app_routes.dart';
import '../network/exception.dart';
import '../network/models/api_response_entity.dart';
import '../utils.dart';
import 'app_version_update_dialog.dart';

// 应用包类型	 枚举: setup,upgrade
enum RSUpgradePackageTye {
  setup,
  upgrade,
}

class RSAPPVersionCheck {
  // TODO: 此处修改是否切换app内升级
  static const bool isStartInAppUpgrade = true;

  /// 版本检测总入口
  static void checkVersion() {
    if (Platform.isAndroid) {
      if (isStartInAppUpgrade) {
        // 检查官网发布平台（支持app内更新）
        RSAPPVersionCheck.checkOfficialPlatform(null, showDialog: true);
      } else {
        // 检查私有发布平台
        RSAPPVersionCheck.checkPrivatePlatform();
      }
    } else {
      // 检查私有发布平台
      RSAPPVersionCheck.checkPrivatePlatform();
    }
  }

  // -----------------------------我是分割线-----------------------------

  /// 检查官网发布平台（支持app内更新）
  static Future<void> checkOfficialPlatform(Function(ApiException? error, RSAppVersionEntity? entity)? callback,
      {bool showDialog = false}) async {
    // 非Android 直接返回
    if (!Platform.isAndroid) return;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // 获取设备的操作系统架构
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    Map<String, dynamic> params = {
      "app_sub_type": 'Android_Boss',
      "app_type": 'Boss',
      "current_version": RSAppInfo().version,
      "device_id": RSAppInfo().deviceId,
      "group_id": RSAccountManager().userInfoEntity?.employee?.corporationId,
      "shop_id": '0',
      "os": Platform.operatingSystem,
      "os_arch": androidInfo.supportedAbis.firstOrNull,
      "os_version": androidInfo.version.sdkInt.toString(),
      "package_type": RSUpgradePackageTye.setup.name,
      "strict": false,
      "version_code": int.parse(RSAppInfo().buildNumber),
    };

    try {
      var dio = Dio();
      var proxy = SpUtil.getString("CharlesNetwork") ?? "";
      if (proxy.isNotEmpty) {
        dio.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            final client = HttpClient();
            client.findProxy = (url) => "PROXY $proxy";
            // 忽略证书
            client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

            return client;
          },
        );
      }

      // 多语言
      var languageCode = RSLocale().locale?.languageCode;

      if (RSLocale().locale?.countryCode != null) {
        var countryCode = RSLocale().locale?.countryCode;
        languageCode = "${languageCode}_$countryCode";
      }

      // 发送POST请求
      var response = await dio.post(
        RSServerUrl.clientUpgrade,
        data: params,
        options: Options(
            contentType: 'application/json', // 设置请求头的Content-Type
            headers: {
              "Language-Code": languageCode,
            }),
      );

      var entity = RSAppVersionEntity.fromJson(response.data);

      if (showDialog) {
        if (entity.nextVersion != null && entity.nextVersion!.isNotEmpty && entity.versions != null) {
          var versionEntity = entity.versions?.firstWhere((e) => e.version == entity.nextVersion);
          if (versionEntity != null) {
            Get.dialog(
                RSAppVersionUpdateDialog(
                  isForce: versionEntity.forceUpgrade,
                  updateContent: [versionEntity.releaseNote ?? ''],
                  updateCallback: () {
                    RSAPPVersionCheck.inAppUpdate(versionEntity);
                  },
                ),
                barrierDismissible: false);
          }
        }
      } else {
        callback?.call(null, entity);
      }
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        Map<String, dynamic> response = e.response?.data;
        String? code, message;
        if (response.containsKey("code")) {
          code = response["code"];
        }
        if (response.containsKey("msg")) {
          message = response["msg"];
        }
        callback?.call(ApiException(code, message), null);
      } else {
        callback?.call(ApiException('${e.response?.statusCode}', e.message), null);
      }
    }
  }

  // -----------------------------我是分割线-----------------------------

  /// 检查私有发布平台——非官网
  static checkPrivatePlatform() async {
    String platform = "0";
    if (Platform.isAndroid) {
      platform = "1";
    } else if (Platform.isIOS) {
      platform = "2";
    }

    Map<String, dynamic> params = {
      "platform": platform,
      "version": RSAppInfo().version,
    };

    await request(() async {
      await requestClient.request(RSServerUrl.checkVersion, method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');

        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');

        var tmpResponseData = response.data;
        if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
          Map<String, dynamic> dataDic = response.data;

          // 审核状态 0未审核中 1审核中
          if (dataDic.containsKey("checkStatus")) {}
          // 需要更新到的版本
          if (dataDic.containsKey("updateVersion")) {}

          int updateStatus = 0;
          List<String> updateInfo = [];

          // 更新状态 0不处理  1软更  2强更
          if (dataDic.containsKey("updateStatus")) {
            updateStatus = dataDic["updateStatus"];
          }

          // 更新内容【List<String>】
          if (dataDic.containsKey("updateInfo")) {
            if (dataDic["updateInfo"] != null && dataDic["updateInfo"] is List<dynamic>) {
              List<dynamic> tmpList = dataDic["updateInfo"];
              for (var element in tmpList) {
                updateInfo.add(element);
              }
            }
          }
          if (updateStatus != 0) {
            Get.dialog(
                RSAppVersionUpdateDialog(
                  isForce: updateStatus == 2,
                  updateContent: updateInfo,
                  updateCallback: () {
                    if (Platform.isAndroid) {
                      RSAPPVersionCheck.upgradeFromAndroidStore();
                    } else if (Platform.isIOS) {
                      RSAPPVersionCheck.upgradeFromAppStore();
                    }
                  },
                ),
                barrierDismissible: false);
          }
        }
      });
    }, showLoading: false);
  }

  /// 跳转到AppStore进行更新
  static void upgradeFromAppStore() async {
    RSUtils.launchURL(RSServerUrl.iOSStoreUrl, () {
      EasyLoading.showToast(S.current.rs_update_tip);
    });
  }

  /// Android 跳转到应用商店升级
  static void upgradeFromAndroidStore() async {
    RSUtils.launchURL(RSServerUrl.androidStoreUrl, () {
      EasyLoading.showToast(S.current.rs_update_tip);
    });
  }

  /// APP内升级
  static void inAppUpdate(RSAppVersionVersions entity) {
    Get.toNamed(AppRoutes.versionUpdatePage, arguments: {"entity": entity, "isDialogSource": true});
  }
}
