import 'dart:convert';

import 'package:flutter_report_project/utils/network/models/api_response_entity.g.dart';

import '../../../generated/json/base/json_convert_content.dart';

export 'package:flutter_report_project/utils/network/models/api_response_entity.g.dart';

// @JsonSerializable()
class ApiResponseEntity<T> {
  String? code;
  String? msg;
  T? data;

  ApiResponseEntity();

  factory ApiResponseEntity.fromJson(Map<String, dynamic> json) => $ApiResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => $ApiResponseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

// @JsonSerializable()
class ApiResponseData {
  ApiResponseData();

  factory ApiResponseData.fromJson(Map<String, dynamic> json) => $ApiResponseDataFromJson(json);

  Map<String, dynamic> toJson() => $ApiResponseDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

ApiResponseEntity<T> $ApiResponseEntityFromJson<T>(Map<String, dynamic> json) {
  final ApiResponseEntity<T> apiResponseEntity = ApiResponseEntity<T>();
  final String? code = jsonConvert.convert<String>(json['code']);

  if (code != null) {
    apiResponseEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['msg']);

  if (message != null) {
    apiResponseEntity.msg = message;
  }
  final T? data = jsonConvert.convert<T>(json['data']);
  if (data != null) {
    apiResponseEntity.data = data;
  }
  return apiResponseEntity;
}
