import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/target_manage_config_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class TargetManageConfigEntity {
  TargetManageConfigTitleMsg? titleMsg;
  TargetManageConfigFilterInfo? filterInfo;
  List<TargetManageConfigMetrics>? metrics;

  TargetManageConfigEntity();

  factory TargetManageConfigEntity.fromJson(Map<String, dynamic> json) => $TargetManageConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageConfigTitleMsg {
  String? title;
  String? msg;

  TargetManageConfigTitleMsg();

  factory TargetManageConfigTitleMsg.fromJson(Map<String, dynamic> json) => $TargetManageConfigTitleMsgFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigTitleMsgToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageConfigFilterInfo {
  String? filterCode;
  String? achievementFilterTitle;
  List<TargetManageConfigFilterInfoAchievementFilter>? achievementFilter;

  TargetManageConfigFilterInfo();

  factory TargetManageConfigFilterInfo.fromJson(Map<String, dynamic> json) =>
      $TargetManageConfigFilterInfoFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigFilterInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageConfigFilterInfoAchievementFilter {
  String? name;
  List<TargetManageConfigFilterInfoAchievementFilterRule>? rule;

  // 自用字段
  bool isSelected = true;

  TargetManageConfigFilterInfoAchievementFilter();

  factory TargetManageConfigFilterInfoAchievementFilter.fromJson(Map<String, dynamic> json) =>
      $TargetManageConfigFilterInfoAchievementFilterFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigFilterInfoAchievementFilterToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageConfigFilterInfoAchievementFilterRule {
  // 过滤比较类型
  @JSONField(isEnum: true)
  EntityFilterType? filterType;

  String? filterValue;

  TargetManageConfigFilterInfoAchievementFilterRule();

  factory TargetManageConfigFilterInfoAchievementFilterRule.fromJson(Map<String, dynamic> json) =>
      $TargetManageConfigFilterInfoAchievementFilterRuleFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigFilterInfoAchievementFilterRuleToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageConfigMetrics {
  String? name;
  String? code;

  // 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  TargetManageConfigMetrics();

  factory TargetManageConfigMetrics.fromJson(Map<String, dynamic> json) => $TargetManageConfigMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageConfigMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
