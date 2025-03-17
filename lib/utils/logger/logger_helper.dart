import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/utils/logger/files_upload.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../app_info.dart';
import 'files_output.dart';

var logger = LoggerHelper();

enum LoggerLevel {
  DEBUG,
  INFO,
  WARN,
  ERROR,
  FAITL,
}

/// 日志工具类
class LoggerHelper {
  static Logger? _logger;

  /// 获取文件路径
  static Future<String> getFilePath() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    var loggerFilePath = "${appDocumentsDir.path}/Logger";
    return loggerFilePath;
  }

  /// 初始化 log 工具
  static void init({
    required String finalPath,
    bool colors = false,
    bool printEmojis = false,
    bool noBoxingByDefault = true,
    int methodCount = 0,
    int errorMethodCount = 8,
    int lineLength = 120,
  }) {
    _logger = Logger(
      filter: ProductionFilter(),
      printer: HybridPrinter(
        PrettyPrinter(
          noBoxingByDefault: noBoxingByDefault,
          methodCount: methodCount,
          errorMethodCount: errorMethodCount,
          lineLength: lineLength,
          colors: colors,
          printEmojis: printEmojis,
        ),
        debug: SimplePrinter(),
      ),
      output: MultiOutput(
        [FilesOutput(filePath: finalPath)], // ConsoleOutput()
      ),
    );

    FilesUpload().startLogsUpload();
  }

  /// debug / info
  void d(dynamic message, StackTrace stackTrace) {
    _logger?.i(formatLog(message, stackTrace, LoggerLevel.INFO));
  }

  /// 警告，在预知或者考虑内的异常，catch 到的
  void w(dynamic message, StackTrace stackTrace) {
    _logger?.w(formatLog(message, stackTrace, LoggerLevel.WARN));
  }

  /// crash 未预知的
  void e(dynamic message, StackTrace stackTrace) {
    _logger?.e(formatLog(message, stackTrace, LoggerLevel.ERROR));
  }

  /*
    - timestamp:时间戳「毫秒」，日志的出现时间。
    - level：日志级别，DEBUG（调试）、INFO（一般运行信息，不含错误）、WARN（需要关注但不需要介入的，运行受影响的）、ERROR（影响了运行，出现之后需要立即接入的）、FAITL （最严重错误）
    - thread: 线程
    - pid：进程号
    - message: 当地时间和具体的日志
    - tag：用来标记业务域。
    - source：日志输出的软件模块，在多应用间有共识，枚举大家提报
    - extra：扩展字段，填业务自己关心的数据
    - shop_id :店铺id，未激活前可空
    - device_id：设备id，来自业务日志
    - trace_id：如有 traceId
    - app_type：标记是哪个app。固定枚举：pos-android、pos-win、boss、kds、kiosk
   */
  String formatLog(dynamic message, StackTrace stackTrace, LoggerLevel level) {
    RSCustomTrace programInfo = RSCustomTrace(stackTrace);

    String logMessage = "[${programInfo.fileName}:${programInfo.lineNumber}] - $message";

    if (level == LoggerLevel.INFO) {
      debugPrint("🚀 $logMessage");
    } else if (level == LoggerLevel.WARN) {
      debugPrint("⚠️ $logMessage");
    } else {
      debugPrint("❌ $logMessage");
    }

    Map<String, dynamic> logMap = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'level': returnLevelEnumString(level),
      'message': logMessage,
      'device_id': RSAppInfo().deviceId,
      'app_type': 'boss',
      'account': {
        'email': RSAccountManager().userInfoEntity?.email,
        'phone': RSAccountManager().userInfoEntity?.phone,
      },
      'app_version': {
        "version": RSAppInfo().version,
        "build_number": RSAppInfo().buildNumber,
      }
    };

    if (level == LoggerLevel.ERROR || level == LoggerLevel.WARN || level == LoggerLevel.FAITL) {
      logMap['thread'] = stackTrace.toString();
    }

    // return "${DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now())} - [${programInfo.fileName}:${programInfo.lineNumber}] - ID:${RSAppInfo().deviceId} $message";
    String jsonStr = jsonEncode(logMap).toString();

    return jsonStr;
  }

  String returnLevelEnumString(LoggerLevel level) {
    switch (level) {
      case LoggerLevel.INFO:
        return "INFO";
      case LoggerLevel.DEBUG:
        return "DEBUG";
      case LoggerLevel.WARN:
        return "WARN";
      case LoggerLevel.ERROR:
        return "ERROR";
      case LoggerLevel.FAITL:
        return "FAITL";
    }
  }
}

class RSCustomTrace {
  final StackTrace _trace;

  String fileName = "";
  int lineNumber = 0;
  int columnNumber = 0;

  RSCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    // EasyLoading.show(status: _trace.toString());
    var traceString = _trace.toString().split("\n");

    var firstTraceString = "";
    if (traceString.isNotEmpty) {
      firstTraceString = traceString.first;
      var indexOfFileName = firstTraceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
      var fileInfo = firstTraceString.substring(indexOfFileName);
      var listOfInfo = fileInfo.split(":");
      if (listOfInfo.length > 2) {
        fileName = listOfInfo[0];
        lineNumber = int.tryParse(listOfInfo[1]) ?? 0;
        var columnStr = listOfInfo[2];
        columnStr = columnStr.replaceFirst(")", "");
        columnNumber = int.tryParse(columnStr) ?? 0;
      }
    }
  }
}
