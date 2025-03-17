import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/topic_template_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class TopicTemplateEntity {
  List<TopicTemplateTemplates>? templates;

  TopicTemplateEntity();

  factory TopicTemplateEntity.fromJson(Map<String, dynamic> json) => $TopicTemplateEntityFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplates {
  bool active = false;
  String? id;
  int? sort;
  String? sourceType;
  List<TopicTemplateTemplatesNavs>? navs;

  TopicTemplateTemplates();

  factory TopicTemplateTemplates.fromJson(Map<String, dynamic> json) => $TopicTemplateTemplatesFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavs {
  String? navId;
  String? navName;
  String? navCode;
  List<TopicTemplateTemplatesNavsTabs>? tabs;

  TopicTemplateTemplatesNavs();

  factory TopicTemplateTemplatesNavs.fromJson(Map<String, dynamic> json) => $TopicTemplateTemplatesNavsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabs {
  String? tabId;
  String? tabName;
  String? tabCode;
  bool ifHidden = false;
  List<TopicTemplateTemplatesNavsTabsCards>? cards;
  TopicTemplateTemplatesNavsTabsConfig? config;

  TopicTemplateTemplatesNavsTabs();

  factory TopicTemplateTemplatesNavsTabs.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCards {
  String? cardId;
  String? cardName;
  String? templateName;
  String? cardCode;
  TopicTemplateTemplatesNavsTabsCardsCardMetadata? cardMetadata;

  TopicTemplateTemplatesNavsTabsCards();

  factory TopicTemplateTemplatesNavsTabsCards.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsConfig {
  bool locked = false;
  String? beginVersion;
  String? endVersion;

  TopicTemplateTemplatesNavsTabsConfig();

  factory TopicTemplateTemplatesNavsTabsConfig.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsConfigFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsConfigToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadata {
  /// 卡片类型
  @JSONField(isEnum: true)
  TopicCardType? cardType;

  String? groupCode;

  String? pageSize;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo? compareInfo;

  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>? chartType;
  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>? metrics;
  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>? dims;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfo? filterInfo;

  TopicTemplateTemplatesNavsTabsCardsCardMetadata();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadata.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType {
  @JSONField(isEnum: true)
  AddMetricsChartType? code;

  // 是否默认选中
  bool ifDefault = false;

  // 展示数量
  String? pageSize;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataChartTypeFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataChartTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo {
  @JSONField(isEnum: true)
  AddMetricsCompareType? compareType;
  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>? metrics;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics {
  String? metricCode;
  String? metricName;
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  List<String>? reportId;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics {
  String? metricCode;
  String? metricName;
  bool ifHidden = false;

  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  List<String>? reportId;

  /// 绑定的Dims
  List<String>? dimOptions;

  /// 指标的解释信息
  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation;

  /// 兼容老版本的指标关联的业务实体。后面删掉
  String? entity;

  /// 兼容老版本的实体列表页的页面标题。客户端使用，后面删掉
  String? entityTitle;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation {
  String? title;
  String? msg;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanationFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataDims {
  String? dimCode;
  String? dimName;
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  List<String>? reportId;

  /// 绑定的Metric
  List<String>? metricOptions;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataDims();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataDimsFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfo {
  List<String>? filtersMsg;
  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters>? filters;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfo();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfo.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters {
  String? fieldCode;

  @JSONField(isEnum: true)
  EntityFilterType? filterType;

  List<String>? filterValue;

  TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters();

  factory TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters.fromJson(Map<String, dynamic> json) =>
      $TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFiltersFromJson(json);

  Map<String, dynamic> toJson() => $TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFiltersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
