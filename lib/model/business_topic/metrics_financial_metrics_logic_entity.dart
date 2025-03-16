import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/metrics_financial_metrics_logic_entity.g.dart';

export 'package:flutter_report_project/generated/json/metrics_financial_metrics_logic_entity.g.dart';

@JsonSerializable()
class MetricsFinancialMetricsLogicEntity {
  MetricsFinancialMetricsLogicPage? page;
  List<List<MetricsFinancialMetricsLogicList>>? list;

  MetricsFinancialMetricsLogicEntity();

  factory MetricsFinancialMetricsLogicEntity.fromJson(Map<String, dynamic> json) =>
      $MetricsFinancialMetricsLogicEntityFromJson(json);

  Map<String, dynamic> toJson() => $MetricsFinancialMetricsLogicEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsFinancialMetricsLogicPage {
  int? total;
  int? pageNo;
  int? pageSize;

  MetricsFinancialMetricsLogicPage();

  factory MetricsFinancialMetricsLogicPage.fromJson(Map<String, dynamic> json) =>
      $MetricsFinancialMetricsLogicPageFromJson(json);

  Map<String, dynamic> toJson() => $MetricsFinancialMetricsLogicPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsFinancialMetricsLogicList {
  // 指标编号
  String? code;

  // 是否加粗
  bool bold = false;

  // 符号：=、-、+
  String? symbol;

  // 指标值
  String? value;

  // 指标显示名称(示例: Total amount)
  String? displayName;

  MetricsFinancialMetricsLogicList();

  factory MetricsFinancialMetricsLogicList.fromJson(Map<String, dynamic> json) =>
      $MetricsFinancialMetricsLogicListFromJson(json);

  Map<String, dynamic> toJson() => $MetricsFinancialMetricsLogicListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
