import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

import '../../../generated/json/module_metrics_entity.g.dart';

@JsonSerializable()
class ModuleMetricsEntity {
  // 指标编号
  String? code;

  // 字段名，不需要展示(示例: D_totalAmount)
  String? fieldName;

  // 指标显示名称(示例: Total amount)
  String? displayName;

  // 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  // 排序值(值越小越靠前)
  int sort = 0;

  // 是否核心指标
  bool isCore = false;

  // 是否默认显示
  bool defaultShowing = false;

  // 指标值
  String? value;

  // 指标同比
  num? percent;

  // 指标关联的业务实体
  String? entity;

  // 实体列表页的页面标题。(客户端使用)
  String? entityTitle;

  ModuleMetricsEntity();

  factory ModuleMetricsEntity.fromJson(Map<String, dynamic> json) => $ModuleMetricsEntityFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
