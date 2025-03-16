import 'package:flustars/flustars.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

enum RSAppInfoChannel {
  global,
  cn,
}

class RSAppInfo {
  //单例---start
  RSAppInfo._internal();

  factory RSAppInfo() => _singleton;
  static final _singleton = RSAppInfo._internal();

  //单例---end

  static const String cacheDeviceID = "CACHEDEVICEID";

  // app名称
  String appName = '';

  // 需展示App全称
  String appDisplayName = '';

  // version
  String version = '';

  // Build版本
  String buildNumber = '';

  // 包名称`bundleIdentifier`在iOS上，getPackageName`在Android上。
  String packageName = '';

  // id
  String deviceId = '';

  // 当前渠道 global:全球、cn:中国
  RSAppInfoChannel channel = RSAppInfoChannel.global;

  /// 渠道信息
  void getChannelInfo() async {
    var channelName = const String.fromEnvironment('CHANNEL', defaultValue: 'global');
    var tmpChannel = RSUtils.enumFromString(RSAppInfoChannel.values, channelName);
    if (tmpChannel != null) {
      channel = tmpChannel;
    }
    logger.d("当前渠道：$channel", StackTrace.current);
  }

  /// 软件包信息
  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    appDisplayName = RSAppInfo().channel == RSAppInfoChannel.global ? 'RestoSuite Insight' : '数说';
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  /// 设备信息
  Future<void> getDeviceInfo() async {
    String? cacheID = SpUtil.getString(cacheDeviceID);

    if (cacheID != null && cacheID.isNotEmpty) {
      deviceId = cacheID;
      logger.d('设备ID: $deviceId', StackTrace.current);
    } else {
      String uuid = const Uuid().v4();
      deviceId = uuid;
      logger.d('设备ID: $uuid', StackTrace.current);
      SpUtil.putString(cacheDeviceID, uuid);
    }

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //
    //   deviceId = await const AndroidId().getId() ?? "";
    //   logger.d('设备 AndroidId: $deviceId', StackTrace.current);
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   deviceId = iosInfo.identifierForVendor ?? "";
    //   logger.d('设备 iOS id: $deviceId', StackTrace.current);
    // }
  }
}
