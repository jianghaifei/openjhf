import 'package:dio/dio.dart';
import 'package:flutter_report_project/utils/network/models/api_response_entity.dart';

class ApiException implements Exception {
  static const unknownException = "unknown";
  final String? message;
  final String? code;
  String? stackInfo;

  ApiException([this.code, this.message]);

  factory ApiException.fromDioError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.unknown:
        return BadRequestException("-1", "unknown");
      case DioExceptionType.sendTimeout:
        return BadRequestException("-1", "send timeout");
      case DioExceptionType.receiveTimeout:
        return BadRequestException("-1", "receive timeout");
      case DioExceptionType.connectionTimeout:
        return BadRequestException("-1", "connection timeout");
      case DioExceptionType.badResponse:
        try {
          /// http错误码带业务错误信息
          ApiResponseEntity apiResponse = ApiResponseEntity.fromJson(exception.response?.data);
          if (apiResponse.code != null) {
            return ApiException(apiResponse.code, apiResponse.msg);
          }

          int? errCode = exception.response?.statusCode;
          switch (errCode) {
            case 400:
              return BadRequestException(errCode.toString(), "请求语法错误");
            case 401:
              return UnauthorisedException(errCode.toString(), "没有权限");
            case 403:
              return UnauthorisedException(errCode.toString(), "服务器拒绝执行");
            case 404:
              return UnauthorisedException(errCode.toString(), "无法连接服务器");
            case 405:
              return UnauthorisedException(errCode.toString(), "请求方法被禁止");
            case 500:
              return UnauthorisedException(errCode.toString(), "服务器内部错误");
            case 502:
              return UnauthorisedException(errCode.toString(), "无效的请求");
            case 503:
              return UnauthorisedException(errCode.toString(), "服务器异常");
            case 505:
              return UnauthorisedException(errCode.toString(), "不支持HTTP协议请求");
            default:
              return ApiException(errCode.toString(), exception.response?.statusMessage ?? '未知错误');
          }
        } on Exception catch (e) {
          print("Exception.e ===> $e");
          return ApiException("-1", unknownException);
        }
      default:
        return ApiException("-1", exception.message);
    }
  }

  factory ApiException.from(dynamic exception) {
    if (exception is DioException) {
      return ApiException.fromDioError(exception);
    }
    if (exception is ApiException) {
      return exception;
    } else {
      var apiException = ApiException("-1", unknownException);
      apiException.stackInfo = exception?.toString();
      return apiException;
    }
  }
}

/// 请求错误
class BadRequestException extends ApiException {
  BadRequestException([String? code, String? message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends ApiException {
  UnauthorisedException([String code = "-1", String message = '']) : super(code, message);
}
