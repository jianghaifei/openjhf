import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/metrics_edit_info_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';

@JsonSerializable()
class MetricsEditInfoEntity {
  MetricsEditInfoMetricsCard? metricsCard;
  List<MetricsEditInfoMetricsCard>? analysisChart;
  List<TopicTemplateTemplatesNavsTabsCards>? customCardTemplate;
  List<MetricsEditInfoTabTemplate>? tabTemplate;

  MetricsEditInfoEntity();

  factory MetricsEditInfoEntity.fromJson(Map<String, dynamic> json) => $MetricsEditInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoMetricsCard {
  MetricsEditInfoCardType? cardType;
  List<MetricsEditInfoPageSize>? pageSize;
  List<MetricsEditInfoChartType>? chartType;
  List<MetricsEditInfoMetrics>? metrics;
  List<MetricsEditInfoDims>? dims;
  List<MetricsEditInfoCompareType>? compareType;
  MetricsEditInfoAdvancedInfo? advancedInfo;
  List<MetricsEditInfoMetricDimConfigurator>? metricDimConfigurator;
  List<MetricsEditInfoDimMetricConfigurator>? dimMetricConfigurator;
  List<MetricsEditInfoMetricFilterConfigurator>? metricFilterConfigurator;

  MetricsEditInfoMetricsCard();

  factory MetricsEditInfoMetricsCard.fromJson(Map<String, dynamic> json) => $MetricsEditInfoMetricsCardFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoMetricsCardToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoCardType {
  String? name;

  @JSONField(isEnum: true)
  TopicCardType? code;

  MetricsEditInfoCardType();

  factory MetricsEditInfoCardType.fromJson(Map<String, dynamic> json) => $MetricsEditInfoCardTypeFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoCardTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoChartType {
  String? name;

  @JSONField(isEnum: true)
  AddMetricsChartType? code;

  List<MetricsEditInfoPageSize>? pageSize;

  MetricsEditInfoChartType();

  factory MetricsEditInfoChartType.fromJson(Map<String, dynamic> json) => $MetricsEditInfoChartTypeFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoChartTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoPageSize {
  String? value;

  String? displayValue;

  MetricsEditInfoPageSize();

  factory MetricsEditInfoPageSize.fromJson(Map<String, dynamic> json) => $MetricsEditInfoPageSizeFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoPageSizeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoMetrics {
  String? metricCode;
  String? metricName;
  bool ifDefault = false;
  String? dataType;
  List<String>? reportId;

  /// 绑定的Dims
  List<String>? dimOptions;

  MetricsEditInfoMetrics();

  factory MetricsEditInfoMetrics.fromJson(Map<String, dynamic> json) => $MetricsEditInfoMetricsFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoCompareType {
  String? name;

  @JSONField(isEnum: true)
  AddMetricsCompareType? code;

  MetricsEditInfoCompareType();

  factory MetricsEditInfoCompareType.fromJson(Map<String, dynamic> json) => $MetricsEditInfoCompareTypeFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoCompareTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoAdvancedInfo {
  List<MetricsEditInfoChartType>? chartType;

  MetricsEditInfoAdvancedInfo();

  factory MetricsEditInfoAdvancedInfo.fromJson(Map<String, dynamic> json) => $MetricsEditInfoAdvancedInfoFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoAdvancedInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoMetricDimConfigurator {
  String? metricCode;
  List<String>? dimCodeOptions;

  MetricsEditInfoMetricDimConfigurator();

  factory MetricsEditInfoMetricDimConfigurator.fromJson(Map<String, dynamic> json) =>
      $MetricsEditInfoMetricDimConfiguratorFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoMetricDimConfiguratorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoDimMetricConfigurator {
  String? dimCode;
  List<String>? metricCodeOptions;

  MetricsEditInfoDimMetricConfigurator();

  factory MetricsEditInfoDimMetricConfigurator.fromJson(Map<String, dynamic> json) =>
      $MetricsEditInfoDimMetricConfiguratorFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoDimMetricConfiguratorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoMetricFilterConfigurator {
  String? metricCode;
  List<MetricsEditInfoMetricFilterConfiguratorFilterOptions>? filterOptions;

  MetricsEditInfoMetricFilterConfigurator();

  factory MetricsEditInfoMetricFilterConfigurator.fromJson(Map<String, dynamic> json) =>
      $MetricsEditInfoMetricFilterConfiguratorFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoMetricFilterConfiguratorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoMetricFilterConfiguratorFilterOptions {
  String? fieldCode;
  String? displayName;

  @JSONField(isEnum: true)
  EntityComponentType? componentType;

  @JSONField(isEnum: true)
  EntityFilterType? filterType;

  /// 绑定的Options Value
  List<String>? bindOptionsValue;

  MetricsEditInfoMetricFilterConfiguratorFilterOptions();

  factory MetricsEditInfoMetricFilterConfiguratorFilterOptions.fromJson(Map<String, dynamic> json) =>
      $MetricsEditInfoMetricFilterConfiguratorFilterOptionsFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoMetricFilterConfiguratorFilterOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoDims {
  String? dimCode;
  String? dimName;
  bool ifDefault = false;
  List<String>? reportId;

  /// 绑定的Metrics
  List<String>? metricOptions;

  MetricsEditInfoDims();

  factory MetricsEditInfoDims.fromJson(Map<String, dynamic> json) => $MetricsEditInfoDimsFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsEditInfoTabTemplate {
  String? templateId;
  String? templateName;

  MetricsEditInfoTabTemplate();

  factory MetricsEditInfoTabTemplate.fromJson(Map<String, dynamic> json) => $MetricsEditInfoTabTemplateFromJson(json);

  Map<String, dynamic> toJson() => $MetricsEditInfoTabTemplateToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
