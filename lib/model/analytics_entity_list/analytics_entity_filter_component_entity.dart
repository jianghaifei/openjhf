import 'dart:convert';

import 'package:flutter_report_project/generated/json/analytics_entity_filter_component_entity.g.dart';
import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

export 'package:flutter_report_project/generated/json/analytics_entity_filter_component_entity.g.dart';

@JsonSerializable()
class AnalyticsEntityFilterComponentEntity {
  /// 筛选器信息
  List<AnalyticsEntityFilterComponentFilters>? filters;

  /// 排序信息
  List<AnalyticsEntityFilterComponentOrderBy>? orderBy;

  AnalyticsEntityFilterComponentEntity();

  factory AnalyticsEntityFilterComponentEntity.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityFilterComponentEntityFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityFilterComponentEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityFilterComponentFilters {
  /// code
  String? fieldCode;

  /// 展示名
  String? displayName;

  /// 组件类型：SELECTION 单选下拉， MULTI_SELECTION 多选下拉， RANGE 范围筛选， INPUT 输入框
  @JSONField(isEnum: true)
  EntityComponentType? componentType;

  /// 筛选类型：EQ，LIKE，IN，RANGE，GT，GOE，LT，LOE，SUB
  @JSONField(isEnum: true)
  EntityFilterType? filterType;

  /// 筛选数据
  List<AnalyticsEntityFilterComponentFiltersOptions>? options;

  AnalyticsEntityFilterComponentFilters();

  factory AnalyticsEntityFilterComponentFilters.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityFilterComponentFiltersFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityFilterComponentFiltersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityFilterComponentFiltersOptions {
  /// 展示名称
  String? displayName;

  /// 是否默认值
  bool ifDefault = false;

  /// 自留字段——是否选中
  bool isSelected = false;

  List<String>? value;

  AnalyticsEntityFilterComponentFiltersOptions();

  factory AnalyticsEntityFilterComponentFiltersOptions.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityFilterComponentFiltersOptionsFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityFilterComponentFiltersOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityFilterComponentOrderBy {
  /// 排序字段
  String? fieldCode;

  /// 展示名称
  String? displayName;

  /// 默认值'DESC'/'ASC'
  String? defaultValue;

  /// 是否为默认
  bool ifDefault = false;

  AnalyticsEntityFilterComponentOrderBy();

  factory AnalyticsEntityFilterComponentOrderBy.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityFilterComponentOrderByFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityFilterComponentOrderByToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
