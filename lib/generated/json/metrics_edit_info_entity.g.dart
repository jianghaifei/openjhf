import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/edit/metrics_edit_info_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';


MetricsEditInfoEntity $MetricsEditInfoEntityFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoEntity metricsEditInfoEntity = MetricsEditInfoEntity();
  final MetricsEditInfoMetricsCard? metricsCard = jsonConvert.convert<MetricsEditInfoMetricsCard>(json['metricsCard']);
  if (metricsCard != null) {
    metricsEditInfoEntity.metricsCard = metricsCard;
  }
  final List<MetricsEditInfoMetricsCard>? analysisChart = (json['analysisChart'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoMetricsCard>(e) as MetricsEditInfoMetricsCard).toList();
  if (analysisChart != null) {
    metricsEditInfoEntity.analysisChart = analysisChart;
  }
  final List<TopicTemplateTemplatesNavsTabsCards>? customCardTemplate = (json['customCardTemplate'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<TopicTemplateTemplatesNavsTabsCards>(e) as TopicTemplateTemplatesNavsTabsCards)
      .toList();
  if (customCardTemplate != null) {
    metricsEditInfoEntity.customCardTemplate = customCardTemplate;
  }
  final List<MetricsEditInfoTabTemplate>? tabTemplate = (json['tabTemplate'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoTabTemplate>(e) as MetricsEditInfoTabTemplate).toList();
  if (tabTemplate != null) {
    metricsEditInfoEntity.tabTemplate = tabTemplate;
  }
  return metricsEditInfoEntity;
}

Map<String, dynamic> $MetricsEditInfoEntityToJson(MetricsEditInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricsCard'] = entity.metricsCard?.toJson();
  data['analysisChart'] = entity.analysisChart?.map((v) => v.toJson()).toList();
  data['customCardTemplate'] = entity.customCardTemplate?.map((v) => v.toJson()).toList();
  data['tabTemplate'] = entity.tabTemplate?.map((v) => v.toJson()).toList();
  return data;
}

extension MetricsEditInfoEntityExtension on MetricsEditInfoEntity {
  MetricsEditInfoEntity copyWith({
    MetricsEditInfoMetricsCard? metricsCard,
    List<MetricsEditInfoMetricsCard>? analysisChart,
    List<TopicTemplateTemplatesNavsTabsCards>? customCardTemplate,
    List<MetricsEditInfoTabTemplate>? tabTemplate,
  }) {
    return MetricsEditInfoEntity()
      ..metricsCard = metricsCard ?? this.metricsCard
      ..analysisChart = analysisChart ?? this.analysisChart
      ..customCardTemplate = customCardTemplate ?? this.customCardTemplate
      ..tabTemplate = tabTemplate ?? this.tabTemplate;
  }
}

MetricsEditInfoMetricsCard $MetricsEditInfoMetricsCardFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoMetricsCard metricsEditInfoMetricsCard = MetricsEditInfoMetricsCard();
  final MetricsEditInfoCardType? cardType = jsonConvert.convert<MetricsEditInfoCardType>(json['cardType']);
  if (cardType != null) {
    metricsEditInfoMetricsCard.cardType = cardType;
  }
  final List<MetricsEditInfoChartType>? chartType = (json['chartType'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoChartType>(e) as MetricsEditInfoChartType).toList();
  if (chartType != null) {
    metricsEditInfoMetricsCard.chartType = chartType;
  }
  final List<MetricsEditInfoMetrics>? metrics = (json['metrics'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoMetrics>(e) as MetricsEditInfoMetrics).toList();
  if (metrics != null) {
    metricsEditInfoMetricsCard.metrics = metrics;
  }
  final List<MetricsEditInfoDims>? dims = (json['dims'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoDims>(e) as MetricsEditInfoDims).toList();
  if (dims != null) {
    metricsEditInfoMetricsCard.dims = dims;
  }
  final List<MetricsEditInfoCompareType>? compareType = (json['compareType'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoCompareType>(e) as MetricsEditInfoCompareType).toList();
  if (compareType != null) {
    metricsEditInfoMetricsCard.compareType = compareType;
  }
  final MetricsEditInfoAdvancedInfo? advancedInfo = jsonConvert.convert<MetricsEditInfoAdvancedInfo>(
      json['advancedInfo']);
  if (advancedInfo != null) {
    metricsEditInfoMetricsCard.advancedInfo = advancedInfo;
  }
  final List<MetricsEditInfoMetricDimConfigurator>? metricDimConfigurator = (json['metricDimConfigurator'] as List<
      dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<MetricsEditInfoMetricDimConfigurator>(e) as MetricsEditInfoMetricDimConfigurator)
      .toList();
  if (metricDimConfigurator != null) {
    metricsEditInfoMetricsCard.metricDimConfigurator = metricDimConfigurator;
  }
  final List<MetricsEditInfoDimMetricConfigurator>? dimMetricConfigurator = (json['dimMetricConfigurator'] as List<
      dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<MetricsEditInfoDimMetricConfigurator>(e) as MetricsEditInfoDimMetricConfigurator)
      .toList();
  if (dimMetricConfigurator != null) {
    metricsEditInfoMetricsCard.dimMetricConfigurator = dimMetricConfigurator;
  }
  return metricsEditInfoMetricsCard;
}

Map<String, dynamic> $MetricsEditInfoMetricsCardToJson(MetricsEditInfoMetricsCard entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardType'] = entity.cardType?.toJson();
  data['chartType'] = entity.chartType?.map((v) => v.toJson()).toList();
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  data['compareType'] = entity.compareType?.map((v) => v.toJson()).toList();
  data['advancedInfo'] = entity.advancedInfo?.toJson();
  data['metricDimConfigurator'] = entity.metricDimConfigurator?.map((v) => v.toJson()).toList();
  data['dimMetricConfigurator'] = entity.dimMetricConfigurator?.map((v) => v.toJson()).toList();
  return data;
}

extension MetricsEditInfoMetricsCardExtension on MetricsEditInfoMetricsCard {
  MetricsEditInfoMetricsCard copyWith({
    MetricsEditInfoCardType? cardType,
    List<MetricsEditInfoChartType>? chartType,
    List<MetricsEditInfoMetrics>? metrics,
    List<MetricsEditInfoDims>? dims,
    List<MetricsEditInfoCompareType>? compareType,
    MetricsEditInfoAdvancedInfo? advancedInfo,
    List<MetricsEditInfoMetricDimConfigurator>? metricDimConfigurator,
    List<MetricsEditInfoDimMetricConfigurator>? dimMetricConfigurator,
  }) {
    return MetricsEditInfoMetricsCard()
      ..cardType = cardType ?? this.cardType
      ..chartType = chartType ?? this.chartType
      ..metrics = metrics ?? this.metrics
      ..dims = dims ?? this.dims
      ..compareType = compareType ?? this.compareType
      ..advancedInfo = advancedInfo ?? this.advancedInfo
      ..metricDimConfigurator = metricDimConfigurator ?? this.metricDimConfigurator
      ..dimMetricConfigurator = dimMetricConfigurator ?? this.dimMetricConfigurator;
  }
}

MetricsEditInfoCardType $MetricsEditInfoCardTypeFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoCardType metricsEditInfoCardType = MetricsEditInfoCardType();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    metricsEditInfoCardType.name = name;
  }
  final TopicCardType? code = jsonConvert.convert<TopicCardType>(
      json['code'], enumConvert: (v) => TopicCardType.values.byName(v));
  if (code != null) {
    metricsEditInfoCardType.code = code;
  }
  return metricsEditInfoCardType;
}

Map<String, dynamic> $MetricsEditInfoCardTypeToJson(MetricsEditInfoCardType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code?.name;
  return data;
}

extension MetricsEditInfoCardTypeExtension on MetricsEditInfoCardType {
  MetricsEditInfoCardType copyWith({
    String? name,
    TopicCardType? code,
  }) {
    return MetricsEditInfoCardType()
      ..name = name ?? this.name
      ..code = code ?? this.code;
  }
}

MetricsEditInfoChartType $MetricsEditInfoChartTypeFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoChartType metricsEditInfoChartType = MetricsEditInfoChartType();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    metricsEditInfoChartType.name = name;
  }
  final AddMetricsChartType? code = jsonConvert.convert<AddMetricsChartType>(
      json['code'], enumConvert: (v) => AddMetricsChartType.values.byName(v));
  if (code != null) {
    metricsEditInfoChartType.code = code;
  }
  return metricsEditInfoChartType;
}

Map<String, dynamic> $MetricsEditInfoChartTypeToJson(MetricsEditInfoChartType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code?.name;
  return data;
}

extension MetricsEditInfoChartTypeExtension on MetricsEditInfoChartType {
  MetricsEditInfoChartType copyWith({
    String? name,
    AddMetricsChartType? code,
  }) {
    return MetricsEditInfoChartType()
      ..name = name ?? this.name
      ..code = code ?? this.code;
  }
}

MetricsEditInfoMetrics $MetricsEditInfoMetricsFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoMetrics metricsEditInfoMetrics = MetricsEditInfoMetrics();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    metricsEditInfoMetrics.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    metricsEditInfoMetrics.metricName = metricName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    metricsEditInfoMetrics.ifDefault = ifDefault;
  }
  final String? dataType = jsonConvert.convert<String>(json['dataType']);
  if (dataType != null) {
    metricsEditInfoMetrics.dataType = dataType;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    metricsEditInfoMetrics.reportId = reportId;
  }
  final List<String>? dimOptions = (json['dimOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (dimOptions != null) {
    metricsEditInfoMetrics.dimOptions = dimOptions;
  }
  return metricsEditInfoMetrics;
}

Map<String, dynamic> $MetricsEditInfoMetricsToJson(MetricsEditInfoMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['ifDefault'] = entity.ifDefault;
  data['dataType'] = entity.dataType;
  data['reportId'] = entity.reportId;
  data['dimOptions'] = entity.dimOptions;
  return data;
}

extension MetricsEditInfoMetricsExtension on MetricsEditInfoMetrics {
  MetricsEditInfoMetrics copyWith({
    String? metricCode,
    String? metricName,
    bool? ifDefault,
    String? dataType,
    List<String>? reportId,
    List<String>? dimOptions,
  }) {
    return MetricsEditInfoMetrics()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..dataType = dataType ?? this.dataType
      ..reportId = reportId ?? this.reportId
      ..dimOptions = dimOptions ?? this.dimOptions;
  }
}

MetricsEditInfoCompareType $MetricsEditInfoCompareTypeFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoCompareType metricsEditInfoCompareType = MetricsEditInfoCompareType();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    metricsEditInfoCompareType.name = name;
  }
  final AddMetricsCompareType? code = jsonConvert.convert<AddMetricsCompareType>(
      json['code'], enumConvert: (v) => AddMetricsCompareType.values.byName(v));
  if (code != null) {
    metricsEditInfoCompareType.code = code;
  }
  return metricsEditInfoCompareType;
}

Map<String, dynamic> $MetricsEditInfoCompareTypeToJson(MetricsEditInfoCompareType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code?.name;
  return data;
}

extension MetricsEditInfoCompareTypeExtension on MetricsEditInfoCompareType {
  MetricsEditInfoCompareType copyWith({
    String? name,
    AddMetricsCompareType? code,
  }) {
    return MetricsEditInfoCompareType()
      ..name = name ?? this.name
      ..code = code ?? this.code;
  }
}

MetricsEditInfoAdvancedInfo $MetricsEditInfoAdvancedInfoFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoAdvancedInfo metricsEditInfoAdvancedInfo = MetricsEditInfoAdvancedInfo();
  final List<MetricsEditInfoChartType>? chartType = (json['chartType'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsEditInfoChartType>(e) as MetricsEditInfoChartType).toList();
  if (chartType != null) {
    metricsEditInfoAdvancedInfo.chartType = chartType;
  }
  return metricsEditInfoAdvancedInfo;
}

Map<String, dynamic> $MetricsEditInfoAdvancedInfoToJson(MetricsEditInfoAdvancedInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['chartType'] = entity.chartType?.map((v) => v.toJson()).toList();
  return data;
}

extension MetricsEditInfoAdvancedInfoExtension on MetricsEditInfoAdvancedInfo {
  MetricsEditInfoAdvancedInfo copyWith({
    List<MetricsEditInfoChartType>? chartType,
  }) {
    return MetricsEditInfoAdvancedInfo()
      ..chartType = chartType ?? this.chartType;
  }
}

MetricsEditInfoMetricDimConfigurator $MetricsEditInfoMetricDimConfiguratorFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoMetricDimConfigurator metricsEditInfoMetricDimConfigurator = MetricsEditInfoMetricDimConfigurator();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    metricsEditInfoMetricDimConfigurator.metricCode = metricCode;
  }
  final List<String>? dimCodeOptions = (json['dimCodeOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (dimCodeOptions != null) {
    metricsEditInfoMetricDimConfigurator.dimCodeOptions = dimCodeOptions;
  }
  return metricsEditInfoMetricDimConfigurator;
}

Map<String, dynamic> $MetricsEditInfoMetricDimConfiguratorToJson(MetricsEditInfoMetricDimConfigurator entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['dimCodeOptions'] = entity.dimCodeOptions;
  return data;
}

extension MetricsEditInfoMetricDimConfiguratorExtension on MetricsEditInfoMetricDimConfigurator {
  MetricsEditInfoMetricDimConfigurator copyWith({
    String? metricCode,
    List<String>? dimCodeOptions,
  }) {
    return MetricsEditInfoMetricDimConfigurator()
      ..metricCode = metricCode ?? this.metricCode
      ..dimCodeOptions = dimCodeOptions ?? this.dimCodeOptions;
  }
}

MetricsEditInfoDimMetricConfigurator $MetricsEditInfoDimMetricConfiguratorFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoDimMetricConfigurator metricsEditInfoDimMetricConfigurator = MetricsEditInfoDimMetricConfigurator();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    metricsEditInfoDimMetricConfigurator.dimCode = dimCode;
  }
  final List<String>? metricCodeOptions = (json['metricCodeOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (metricCodeOptions != null) {
    metricsEditInfoDimMetricConfigurator.metricCodeOptions = metricCodeOptions;
  }
  return metricsEditInfoDimMetricConfigurator;
}

Map<String, dynamic> $MetricsEditInfoDimMetricConfiguratorToJson(MetricsEditInfoDimMetricConfigurator entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['metricCodeOptions'] = entity.metricCodeOptions;
  return data;
}

extension MetricsEditInfoDimMetricConfiguratorExtension on MetricsEditInfoDimMetricConfigurator {
  MetricsEditInfoDimMetricConfigurator copyWith({
    String? dimCode,
    List<String>? metricCodeOptions,
  }) {
    return MetricsEditInfoDimMetricConfigurator()
      ..dimCode = dimCode ?? this.dimCode
      ..metricCodeOptions = metricCodeOptions ?? this.metricCodeOptions;
  }
}

MetricsEditInfoDims $MetricsEditInfoDimsFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoDims metricsEditInfoDims = MetricsEditInfoDims();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    metricsEditInfoDims.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    metricsEditInfoDims.dimName = dimName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    metricsEditInfoDims.ifDefault = ifDefault;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    metricsEditInfoDims.reportId = reportId;
  }
  final List<String>? metricOptions = (json['metricOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (metricOptions != null) {
    metricsEditInfoDims.metricOptions = metricOptions;
  }
  return metricsEditInfoDims;
}

Map<String, dynamic> $MetricsEditInfoDimsToJson(MetricsEditInfoDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['ifDefault'] = entity.ifDefault;
  data['reportId'] = entity.reportId;
  data['metricOptions'] = entity.metricOptions;
  return data;
}

extension MetricsEditInfoDimsExtension on MetricsEditInfoDims {
  MetricsEditInfoDims copyWith({
    String? dimCode,
    String? dimName,
    bool? ifDefault,
    List<String>? reportId,
    List<String>? metricOptions,
  }) {
    return MetricsEditInfoDims()
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..reportId = reportId ?? this.reportId
      ..metricOptions = metricOptions ?? this.metricOptions;
  }
}

MetricsEditInfoTabTemplate $MetricsEditInfoTabTemplateFromJson(Map<String, dynamic> json) {
  final MetricsEditInfoTabTemplate metricsEditInfoTabTemplate = MetricsEditInfoTabTemplate();
  final String? templateId = jsonConvert.convert<String>(json['templateId']);
  if (templateId != null) {
    metricsEditInfoTabTemplate.templateId = templateId;
  }
  final String? templateName = jsonConvert.convert<String>(json['templateName']);
  if (templateName != null) {
    metricsEditInfoTabTemplate.templateName = templateName;
  }
  return metricsEditInfoTabTemplate;
}

Map<String, dynamic> $MetricsEditInfoTabTemplateToJson(MetricsEditInfoTabTemplate entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['templateId'] = entity.templateId;
  data['templateName'] = entity.templateName;
  return data;
}

extension MetricsEditInfoTabTemplateExtension on MetricsEditInfoTabTemplate {
  MetricsEditInfoTabTemplate copyWith({
    String? templateId,
    String? templateName,
  }) {
    return MetricsEditInfoTabTemplate()
      ..templateId = templateId ?? this.templateId
      ..templateName = templateName ?? this.templateName;
  }
}