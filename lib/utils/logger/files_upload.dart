import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/utils/logger/files_output.dart';
import 'package:flutter_report_project/utils/logger/protocol_generated.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';

import 'logger_helper.dart';

class FilesUpload {
  /// 记录上次上传行数（从1开始计数）
  int recordLastUploadLine = 1;

  /// 文件路径
  String recordUploadFileName = "";

  /// 循环上传
  void startLogsUpload() {
    Timer.periodic(const Duration(minutes: 3), (Timer t) {
      getLogFileString();
    });
  }

  void getLogFileString() async {
    getCacheAction();

    // .log文件路径
    String filePath = await LoggerHelper.getFilePath();
    // 全部.log文件——从小到大排序过
    List<File>? logFiles = FilesOutput.getAllLogFile(filePath);
    // 最早文件
    var startFilePath = logFiles?.first;

    if (startFilePath != null) {
      if (_getFileName(startFilePath) != recordUploadFileName) {
        recordLastUploadLine = 1;
        recordUploadFileName = _getFileName(startFilePath) ?? "";
      }

      try {
        File logFile = File(startFilePath.path);
        if (logFile.existsSync()) {
          // 同步读取
          List<String> lines = logFile.readAsLinesSync();
          List<String> uploadLogs = [];
          for (var i = recordLastUploadLine; i < lines.length && i < lines.length; i++) {
            uploadLogs.add(lines[i]);
          }

          if (uploadLogs.isNotEmpty) {
            debugPrint("CacheAction --- 从:$recordLastUploadLine行开始至${lines.length}行开始上传");
            flatBufferBody(uploadLogs, () {
              // 下次上传开始位置
              recordLastUploadLine = lines.length + 1;

              setCacheAction();
              removeFirstLogFile(logFiles!);
            });
          } else {
            removeFirstLogFile(logFiles!);
          }
        } else {
          logger.w("FilesUpload .log文件不存在:$logFiles", StackTrace.current);
        }
      } catch (e) {
        logger.e("FilesUpload 上传发生错误：$e", StackTrace.current);
      }
    }
  }

  void removeFirstLogFile(List<File> logFiles) async {
    if (logFiles.length > 1 && recordLastUploadLine >= logFiles.first.readAsLinesSync().length) {
      var deleteLogFilePath = await LoggerHelper.getFilePath();
      FilesOutput.deleteFile("$deleteLogFilePath/$recordUploadFileName");
      logger.d("删除文件：${"$deleteLogFilePath/$recordUploadFileName"}", StackTrace.current);
    }
  }

  void getCacheAction() {
    recordLastUploadLine = SpUtil.getInt("RecordLastUploadLine") ?? 1;
    recordUploadFileName = SpUtil.getString("RecordUploadFileName") ?? '';
    debugPrint("getCacheAction --- s:$recordLastUploadLine");
  }

  void setCacheAction() {
    SpUtil.putInt("RecordLastUploadLine", recordLastUploadLine);
    SpUtil.putString("RecordUploadFileName", recordUploadFileName);
    debugPrint("setCacheAction --- s:$recordLastUploadLine");
  }

  String? _getFileName(File file) {
    return file.path.split("/").isEmpty ? null : file.path.split("/").last;
  }

  void flatBufferBody(List<String> logBody, Function() onSuccess) {
    // 创建对象
    final builder = fb.Builder(initialSize: 1024);

    // 第一步
    List<int> listRawData = [];
    for (var element in logBody) {
      var utf8Bytes = utf8.encode(element);
      var tmpInt8List = Int8List.fromList(utf8Bytes);
      var logOffset = builder.writeListUint8(tmpInt8List);

      var rawData = UploadRawDataBuilder(builder)
        ..begin()
        ..addRawDataOffset(logOffset);
      var rawDataOffSet = rawData.finish();

      listRawData.add(rawDataOffSet);
    }

    // 第二步
    var tmpListRawData = builder.writeList(listRawData);
    var uploadRawDataSegment = UploadRawDataSegmentBuilder(builder)
      ..begin()
      ..addDataType(UploadDataType.Logs)
      ..addDataSegmentOffset(tmpListRawData);
    var uploadRawDataSegmentOffset = uploadRawDataSegment.finish();

    // 第三步
    var tmpSegmentOffset = builder.writeList([uploadRawDataSegmentOffset]);
    var dateMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var uploadDataRequest = UploadDataRequestBuilder(builder)
      ..begin()
      ..addUploadTimestamp(dateMilliseconds)
      ..addAllDataSegmentOffset(tmpSegmentOffset);
    var uploadDataRequestOffset = uploadDataRequest.finish();

    builder.finish(uploadDataRequestOffset);
    var byteBuffer = builder.buffer;
    // 将Uint8List转换为Int8List
    var int8ListByteBuffer = Int8List.fromList(byteBuffer);
    var compressLogBody = gzipEncode(int8ListByteBuffer);

    sendUploadRequest(compressLogBody!, onSuccess);
  }

  void sendUploadRequest(Int8List logBody, Function() onSuccess) async {
    debugPrint("日志上传url --- s:${RSServerUrl.uploadLogBaseUrl}");

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

      var tmpBuffer = Stream<List<int>>.fromIterable([logBody]);

      // 发送POST请求
      var response = await dio.post(
        RSServerUrl.uploadLogBaseUrl,
        data: tmpBuffer,
        options: Options(
          contentType: 'application/json; charset=utf-8', // 设置请求头的Content-Type
        ),
      );

      // 处理响应
      var responseBytes = utf8.encode(response.data).buffer.asInt8List();
      var uploadDataResponse = UploadDataResponse(responseBytes);
      if (uploadDataResponse.status == UploadResponseStatus.Success) {
        onSuccess.call();
        debugPrint("✅ 日志上传成功");
      } else {
        logger.e('日志上传失败:${uploadDataResponse.toString()}', StackTrace.current);
      }
    } catch (error) {
      logger.e('日志上传错误:$error', StackTrace.current);
    }
    return;
  }

  ///GZIP 压缩
  Int8List? gzipEncode(Int8List int8list) {
    final gzipBytes = GZipEncoder().encode(int8list);
    if (gzipBytes != null) {
      final tmpGZipBytes = Int8List.fromList(gzipBytes);
      return tmpGZipBytes;
    } else {
      return null;
    }
  }

  ///GZIP 解压缩
  List<int> gzipDecode(Int8List? stringBytes) {
    List<int> gzipBytes = GZipDecoder().decodeBytes(stringBytes!);
    // String compressedString = utf8.decode(gzipBytes);
    return gzipBytes;
  }
}
