import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/module_group_metrics_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';

@JsonSerializable()
class ModuleGroupMetricsEntity {
  List<ModuleGroupMetricsMetrics>? metrics;
  ModuleGroupMetricsReportData? reportData;

  ModuleGroupMetricsEntity();

  factory ModuleGroupMetricsEntity.fromJson(Map<String, dynamic> json) => $ModuleGroupMetricsEntityFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsMetrics {
  String? code;
  String? value;
  String? name;
  String? displayValue;
  String? abbrDisplayValue;
  String? abbrDisplayUnit;

  /// 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  ModuleMetricsCardDrillDownInfo? drillDownInfo;

  ModuleGroupMetricsMetrics();

  factory ModuleGroupMetricsMetrics.fromJson(Map<String, dynamic> json) => $ModuleGroupMetricsMetricsFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsReportData {
  List<ModuleGroupMetricsReportDataRows>? rows;
  ModuleGroupMetricsReportDataPage? page;

  ModuleGroupMetricsReportData();

  factory ModuleGroupMetricsReportData.fromJson(Map<String, dynamic> json) =>
      $ModuleGroupMetricsReportDataFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsReportDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsReportDataRows {
  List<ModuleGroupMetricsReportDataRowsDims>? dims;
  List<ModuleGroupMetricsReportDataRowsMetrics>? metrics;

  ModuleGroupMetricsReportDataRows();

  factory ModuleGroupMetricsReportDataRows.fromJson(Map<String, dynamic> json) =>
      $ModuleGroupMetricsReportDataRowsFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsReportDataRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsReportDataRowsDims {
  String? code;
  String? value;
  String? displayValue;
  String? name;

  ModuleGroupMetricsReportDataRowsDims();

  factory ModuleGroupMetricsReportDataRowsDims.fromJson(Map<String, dynamic> json) =>
      $ModuleGroupMetricsReportDataRowsDimsFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsReportDataRowsDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsReportDataRowsMetrics {
  String? code;
  String? value;
  String? name;
  String? displayValue;
  String? abbrDisplayValue;
  String? abbrDisplayUnit;

  /// 对比
  ModuleMetricsCardCompValue? compValue;

  /// 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  ModuleMetricsCardDrillDownInfo? drillDownInfo;

  /// 占比
  double? proportion;

  /// 同环比
  double? percent;

  /// 同环比颜色
  String? percentColor;

  ModuleGroupMetricsReportDataRowsMetrics();

  factory ModuleGroupMetricsReportDataRowsMetrics.fromJson(Map<String, dynamic> json) =>
      $ModuleGroupMetricsReportDataRowsMetricsFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsReportDataRowsMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleGroupMetricsReportDataPage {
  int total = 0;
  int pageNo = 0;
  int pageSize = 0;
  int pageCount = 0;

  ModuleGroupMetricsReportDataPage();

  factory ModuleGroupMetricsReportDataPage.fromJson(Map<String, dynamic> json) =>
      $ModuleGroupMetricsReportDataPageFromJson(json);

  Map<String, dynamic> toJson() => $ModuleGroupMetricsReportDataPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
