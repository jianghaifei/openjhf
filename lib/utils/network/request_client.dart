import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_report_project/utils/network/models/raw_data.dart';
import 'package:flutter_report_project/utils/network/request_config.dart';
import 'package:flutter_report_project/utils/network/request_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../logger/logger_helper.dart';
import 'exception.dart';
import 'models/api_response_entity.dart';

enum RequestType {
  get,
  post,
}

RSRequestClient requestClient = RSRequestClient();

class RSRequestClient {
  var proxy = "";

  late Dio _dio;

  Map<String, dynamic> defaultHeader = {
    'Content-Type': 'application/json',
  };

  void addHeader(Map<String, String> inputHeaderInfo) {
    defaultHeader.addAll(inputHeaderInfo);
  }

  RSRequestClient() {
    _dio = Dio(BaseOptions(
      // 连接服务器超时时间
      connectTimeout: const Duration(seconds: RequestConfig.connectTimeout),
      sendTimeout: const Duration(seconds: RequestConfig.connectTimeout),
      receiveTimeout: const Duration(seconds: RequestConfig.connectTimeout),
    ));

    _dio.interceptors.add(RequestInterceptor());

    // 网络日志拦截器
    _dio.interceptors.add(PrettyDioLogger(
      // request: true,
      // requestBody: true,
      // responseBody: true,
      // requestHeader: true,
      // responseHeader: true,
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: false,
      error: true,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          logger.d("Request onRequest：url:${options.path} - method:${options.method} - headers:${options.headers}",
              StackTrace.current);
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // logger.d("Request onResponse：url:${response.requestOptions.path} - $response", StackTrace.current);
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          logger.e("Request onError：url:${error.requestOptions.path} - $error", StackTrace.current);
          return handler.next(error);
        },
      ),
    );

    /// 代理设置-参考文档：https://github.com/cfug/dio/blob/main/dio/README-ZH.md
    proxy = SpUtil.getString("CharlesNetwork") ?? "";
    if (proxy.isNotEmpty) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (url) => "PROXY $proxy";
          // 忽略证书
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

          return client;
        },
      );
    }else if(kDebugMode) {
      dotenv.load(fileName: ".env").then((res) {
        final dioProxy = dotenv.env['dio_proxy'];
        if (dioProxy != null) {
          _dio.httpClientAdapter = IOHttpClientAdapter(
            createHttpClient: () {
              final client = HttpClient();
              client.findProxy = (url) => "PROXY $dioProxy";
              // 忽略证书
              client.badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
              return client;
            },
          );
        }
      }).catchError((e) {
        print('eee');
      });
    }
  }

  Future<T?> request<T>(
    String url, {
    RequestType method = RequestType.get,
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    Function(ApiResponseEntity<T>)? onResponse,
    bool Function(ApiException)? onError,
  }) async {
    String methodString = "GET";
    switch (method) {
      case RequestType.get:
        methodString = "GET";
        break;
      case RequestType.post:
        methodString = "POST";
        break;
      default:
        methodString = "GET";
        break;
    }

    if (headers != null) {
      defaultHeader.addAll(headers);
    }

    try {
      Options options = Options()
        ..method = methodString
        ..headers = defaultHeader;

      data = _convertRequestData(data);

      Response response = await _dio.request(url, queryParameters: queryParameters, data: data, options: options);

      return _handleResponse<T>(response, onResponse);
    } catch (e) {
      var exception = ApiException.from(e);
      if (onError?.call(exception) != true) {
        throw exception;
      }
    }
    return null;
  }

  /// 请求响应内容处理
  T? _handleResponse<T>(Response response, Function(ApiResponseEntity<T>)? onResponse) {
    if (response.statusCode == 200) {
      if (T.toString() == (RawData).toString()) {
        RawData raw = RawData();
        raw.value = response.data;
        return raw as T;
      } else {
        // Map<String, dynamic> customMap = {
        //   "data": response.data,
        //   "code": response.statusCode,
        //   "message": response.statusMessage,
        // };
        //
        // ApiResponseEntity<T> apiResponse = ApiResponseEntity<T>.fromJson(customMap);
        // return apiResponse as T;

        ApiResponseEntity<T> apiResponse = ApiResponseEntity<T>.fromJson(response.data);
        onResponse?.call(apiResponse);
        return _handleBusinessResponse<T>(apiResponse);
      }
    } else {
      var exception = ApiException(response.statusCode.toString(), ApiException.unknownException);
      throw exception;
    }
  }

  /// 业务内容处理
  T? _handleBusinessResponse<T>(ApiResponseEntity<T> response) {
    if (response.code == RequestConfig.successCode) {
      return response.data;
    } else {
      var exception = ApiException(response.code, response.msg);
      throw exception;
    }
  }

  _convertRequestData(data) {
    // if (data != null) {
    //   data = jsonDecode(jsonEncode(data));
    // }
    return data;
  }
}
