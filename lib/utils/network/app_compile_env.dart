import 'package:flustars/flustars.dart';
import 'package:flutter_report_project/utils/app_info.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';

import '../utils.dart';

enum EnvType {
  us,
  eu,
  sea,
  cn,
  uat,
  test,
  dev,
}

class RSAppCompileEnv {
  static EnvType enumEnvType = EnvType.us;

  /// 国外
  static List<String> envReleaseGlobal = ['us', 'eu', 'sea', 'cn'];

  static List<String> envDebugGlobal = [
    'us',
    'eu',
    'sea',
    'cn',
    'uat',
    'test',
    'dev',
  ];

  /// 国内
  static List<String> envReleaseCn = ['cn'];

  static List<String> envDebugCn = [
    'cn',
    'uat',
    'test',
    'dev',
  ];

  /// Key
  static const String appCompileEnvKey = "RSAppCompileEnvKeyString";

  /// Debug开关 Key
  static const String appCompileEnvDebugKey = "RSAppCompileEnvDebugKey";

  static Future<void> initEnvConfig() async {
    var envString = SpUtil.getString(appCompileEnvKey);

    if (RSAppInfo().channel == RSAppInfoChannel.global) {
      if (envString == null || envString.isEmpty) {
        resetEnvString();
      }
    } else {
      if (envString == null || envString.isEmpty) {
        resetEnvString();
      }
    }

    // 初始化APP域名配置
    await RSServerUrl.initDomainUrl();
  }

  /// 查询当前环境类型，返回enum
  static EnvType getCurrentEnvType() {
    // 获取本地存储的value
    var envString = SpUtil.getString(appCompileEnvKey) ?? EnvType.values.first.name;

    // string to enum
    var tmpEnv = RSUtils.enumFromString(EnvType.values, envString);

    int envIndex = EnvType.values.indexWhere((element) => element.name == envString);

    if (tmpEnv != null && (envIndex < EnvType.values.length && envIndex != -1)) {
      EnvType envType = tmpEnv;
      return envType;
    } else {
      return RSUtils.enumFromString(EnvType.values, resetEnvString()) ??
          (RSAppInfo().channel == RSAppInfoChannel.global ? EnvType.us : EnvType.cn);
    }
  }

  /// 查询当前环境类型，返回字符串
  static String getCurrentEnvTypeString() {
    // 获取本地存储的value
    var envString = SpUtil.getString(appCompileEnvKey) ?? EnvType.values.first.name;

    // string to enum
    var tmpEnv = RSUtils.enumFromString(EnvType.values, envString);

    int envIndex = EnvType.values.indexWhere((element) => element.name == envString);

    if (tmpEnv != null && (envIndex < EnvType.values.length && envIndex != -1)) {
      EnvType envType = tmpEnv;
      return envType.name;
    } else {
      return resetEnvString();
    }
  }

  /// 修改环境类型
  static void modifyEnvType(String env) {
    SpUtil.putString(appCompileEnvKey, env);
  }

  /// 修改环境Debug模式
  static void modifyEnvDebugModel(bool value) {
    SpUtil.putBool(appCompileEnvDebugKey, value);
  }

  /// 重置环境
  static String resetEnvString() {
    if (RSAppInfo().channel == RSAppInfoChannel.global) {
      modifyEnvType(envReleaseGlobal.first);
      return envReleaseGlobal.first;
    } else {
      modifyEnvType(envReleaseCn.first);
      return envReleaseCn.first;
    }
  }

  /// 获取当前环境列表下标
  static int getCurrentEnvListIndex() {
    int envIndex = getCurrentEnvList().indexWhere((element) => element == getCurrentEnvTypeString());
    return envIndex;
  }

  /// 获取当前环境列表
  static List<String> getCurrentEnvList() {
    bool onOff = SpUtil.getBool(RSAppCompileEnv.appCompileEnvDebugKey, defValue: false) ?? false;
    if (onOff) {
      if (RSAppInfo().channel == RSAppInfoChannel.global) {
        return envDebugGlobal;
      } else {
        return envDebugCn;
      }
    } else {
      if (RSAppInfo().channel == RSAppInfoChannel.global) {
        return envReleaseGlobal;
      } else {
        return envReleaseCn;
      }
    }
  }
}
