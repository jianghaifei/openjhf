import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/utils/network/models/api_response_entity.dart';

ApiResponseEntity $ApiResponseEntityFromJson(Map<String, dynamic> json) {
  final ApiResponseEntity apiResponseEntity = ApiResponseEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    apiResponseEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['msg']);
  if (message != null) {
    apiResponseEntity.msg = message;
  }
  final dynamic data = json['data'];
  if (data != null) {
    apiResponseEntity.data = data;
  }
  return apiResponseEntity;
}

Map<String, dynamic> $ApiResponseEntityToJson(ApiResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data;

  return data;
}

extension ApiResponseEntityExtension on ApiResponseEntity {
  ApiResponseEntity copyWith({
    String? code,
    String? msg,
    dynamic data,
  }) {
    return ApiResponseEntity()
      ..code = code ?? this.code
      ..msg = msg ?? this.msg
      ..data = data ?? this.data;
  }
}

ApiResponseData $ApiResponseDataFromJson(Map<String, dynamic> json) {
  final ApiResponseData apiResponseData = ApiResponseData();
  return apiResponseData;
}

Map<String, dynamic> $ApiResponseDataToJson(ApiResponseData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension ApiResponseDataExtension on ApiResponseData {}
