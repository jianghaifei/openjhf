import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/metrics_core_exception_entity.g.dart';

/// 指标——核心&异常

@JsonSerializable()
class MetricsCoreExceptionEntity {
  MetricsCoreExceptionPage? page;
  List<MetricsCoreExceptionList>? list;

  MetricsCoreExceptionEntity();

  factory MetricsCoreExceptionEntity.fromJson(Map<String, dynamic> json) => $MetricsCoreExceptionEntityFromJson(json);

  Map<String, dynamic> toJson() => $MetricsCoreExceptionEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsCoreExceptionPage {
  int? total;
  int? pageNo;
  int? pageSize;

  MetricsCoreExceptionPage();

  factory MetricsCoreExceptionPage.fromJson(Map<String, dynamic> json) => $MetricsCoreExceptionPageFromJson(json);

  Map<String, dynamic> toJson() => $MetricsCoreExceptionPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsCoreExceptionList {
  String? code;
  String? fieldName;
  String? value;
  num? percent;

  MetricsCoreExceptionList();

  factory MetricsCoreExceptionList.fromJson(Map<String, dynamic> json) => $MetricsCoreExceptionListFromJson(json);

  Map<String, dynamic> toJson() => $MetricsCoreExceptionListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
