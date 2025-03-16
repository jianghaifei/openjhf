import 'dart:convert';

import 'package:flutter_report_project/generated/json/analytics_entity_list_entity.g.dart';
import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class AnalyticsEntityListEntity {
  AnalyticsEntityListPage? page;
  List<AnalyticsEntityListList>? list;

  AnalyticsEntityListEntity();

  factory AnalyticsEntityListEntity.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListEntityFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListPage {
  int total = 0;
  int pageNo = 0;
  int pageSize = 0;
  int pageCount = 0;

  AnalyticsEntityListPage();

  factory AnalyticsEntityListPage.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListPageFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListList {
  // AnalyticsEntityListListMetrics? metrics;
  AnalyticsEntityListListMetrics? primaryField;
  List<AnalyticsEntityListListDims>? dims;
  List<AnalyticsEntityListListTags>? tags;
  AnalyticsEntityListNext? next;

  AnalyticsEntityListList();

  factory AnalyticsEntityListList.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListListFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListListMetrics {
  /// 指标编号(示例: M_totalAmount)
  String? code;

  /// 指标值(示例: 100)
  String? value;

  /// 指标值(示例: $100.00)
  String? displayValue;

  /// 显示的名
  String? displayName;

  /// 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  AnalyticsEntityListListMetrics();

  factory AnalyticsEntityListListMetrics.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityListListMetricsFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListListMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListListDims {
  String? code;
  String? displayName;
  String? value;
  String? displayValue;
  bool showing = false;

  /// 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  /// 是否业务主键
  bool primaryKey = false;

  AnalyticsEntityListListDims();

  factory AnalyticsEntityListListDims.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListListDimsFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListListDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListListTags {
  /// 显示名称
  String? displayName;

  /// 数据类型
  @JSONField(isEnum: true)
  OrderEntityTagType? tagEnum;

  AnalyticsEntityListListTags();

  factory AnalyticsEntityListListTags.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListListTagsFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListListTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListNext {
  /// 实体
  String? entity;

  /// 实体title
  String? entityTitle;

  /// 指标code
  String? metricCode;

  /// 筛选器筛选信息
  AnalyticsEntityListNextFilterPassingInfo? filtersPassingInfo;

  // 跳转页类型
  @JSONField(isEnum: true)
  EntityJumpPageType? pageType;

  AnalyticsEntityListNext();

  factory AnalyticsEntityListNext.fromJson(Map<String, dynamic> json) => $AnalyticsEntityListNextFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListNextToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListNextFilterPassingInfo {
  List<String>? dims;

  AnalyticsEntityListNextFilterPassingInfo();

  factory AnalyticsEntityListNextFilterPassingInfo.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityListNextFilterPassingInfoFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListNextFilterPassingInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
