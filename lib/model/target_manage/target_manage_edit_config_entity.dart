import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/target_manage_edit_config_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class TargetManageEditConfigEntity {
  List<TargetManageEditConfigMetrics>? metrics;

  TargetManageEditConfigEntity();

  factory TargetManageEditConfigEntity.fromJson(Map<String, dynamic> json) =>
      $TargetManageEditConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageEditConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageEditConfigMetrics {
  String? name;
  String? code;
  // 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  // 自用字段
  bool isSelected = true;

  TargetManageEditConfigMetrics();

  factory TargetManageEditConfigMetrics.fromJson(Map<String, dynamic> json) =>
      $TargetManageEditConfigMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageEditConfigMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
