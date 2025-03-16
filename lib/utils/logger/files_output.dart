import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// 日志输出文件
/// 要求文件命名为日期
/// 每10m 一个文件
const int MAX_LOG_FILE_SIZE = 1024 * 1024 * 10;

class FilesOutput extends LogOutput {
  final String filePath;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  late File file;

  bool currentIsOperation = false;

  FilesOutput({
    required this.filePath,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  Future<void> init() async {
    file = _getLastLogFile();
    _openWrite();
  }

  void _openWrite() async {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  Future<void> _closeWrite() async {
    await _sink?.flush();
    await _sink?.close();
  }

  @override
  Future<void> output(OutputEvent event) async {
    if (await _checkLogFileNeedCreate() && !currentIsOperation) {
      currentIsOperation = true;
      // 写满10m 再创建新的文件
      await _closeWrite();
      file = _createLogFile();

      _openWrite();
      currentIsOperation = false;
    } else {
      _sink?.writeAll(event.lines, '\n');
      _sink?.writeln();
    }
  }

  @override
  Future<void> destroy() async {
    _closeWrite();
  }

  /// 判断是否需要创建新的文件
  /// 是否写满10m
  /// 文件名称是否是当天文件
  Future<bool> _checkLogFileNeedCreate() async {
    if ((await file.length()) >= MAX_LOG_FILE_SIZE) {
      return true;
    }
    if (_getFileName(file)?.startsWith(_getToday()) != true) {
      return true;
    }
    return false;
  }

  /// 创建新的文件
  File _createLogFile() {
    Directory directory = Directory(filePath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    var fileList = getAllLogFile(filePath);

    String fileName = _getToday();
    if (fileList != null && fileList.isNotEmpty) {
      var tmpFile = _getFileName(fileList.last);
      var tmpNumber = tmpFile?.split("_").last.split(".").first;
      var fileSuffix = int.parse("$tmpNumber");
      if (fileName != tmpFile?.split("_").first) {
        fileName = "${fileName}_1.log";
      } else {
        fileName = "${fileName}_${fileSuffix + 1}.log";
      }
    } else {
      fileName = "${fileName}_1.log";
    }
    return File("$filePath/$fileName");
  }

  String? _getFileName(File file) {
    return file.path.split("/").isEmpty ? null : file.path.split("/").last;
  }

  /// 获取最新的文件
  /// 如果不存在则创建新文件
  File _getLastLogFile() {
    final Directory directory = Directory(filePath);
    if (directory.existsSync()) {
      List<File>? logFiles = getAllLogFile(filePath);

      File? lastFile;
      if (logFiles != null) {
        lastFile = logFiles.last;
      }

      if (lastFile == null) {
        return _createLogFile();
      } else {
        // 判断名称是否是当天时间
        var fileName = _getFileName(lastFile);
        if (fileName?.startsWith(_getToday()) == true) {
          // 是今天的文件， 则判断文件大小
          if (lastFile.lengthSync() >= MAX_LOG_FILE_SIZE) {
            return _createLogFile();
          } else {
            return lastFile;
          }
        } else {
          return _createLogFile();
        }
      }
    } else {
      /// 不存在 则创建新的
      return _createLogFile();
    }
  }

  static List<File>? getAllLogFile(String filePath) {
    final Directory directory = Directory(filePath);

    List<File> logFiles = [];
    // 获取文件夹中所有的.log 文件
    directory.listSync().forEach((var entity) {
      if (entity is File && entity.path.endsWith('.log')) {
        logFiles.add(entity);
      }
    });

    if (logFiles.isNotEmpty) {
      // 对文件按照日期进行排序
      logFiles.sort((a, b) => Comparable.compare(a.path, b.path));
      debugPrint("最旧的文件是: ${logFiles.first.path}");
      debugPrint("最新的文件是: ${logFiles.last.path}");
      return logFiles;
    }
    return null;
  }

  /// 删除指定文件
  static deleteFile(String filePath) {
    final file = File(filePath);

    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  /// 删除所有文件
  static deleteAllFiles(String filePath) {
    Directory directory = Directory(filePath);

    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      if (files.isNotEmpty) {
        for (var file in files) {
          file.deleteSync();
        }
      }
    }
    directory.deleteSync();
  }

  /// 获取今天字符串
  String _getToday() {
    var format = DateFormat('yyyy-MM-dd');
    return format.format(DateTime.now());
  }
}
