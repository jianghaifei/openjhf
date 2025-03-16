import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';


TopicTemplateEntity $TopicTemplateEntityFromJson(Map<String, dynamic> json) {
  final TopicTemplateEntity topicTemplateEntity = TopicTemplateEntity();
  final List<TopicTemplateTemplates>? templates = (json['templates'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<TopicTemplateTemplates>(e) as TopicTemplateTemplates).toList();
  if (templates != null) {
    topicTemplateEntity.templates = templates;
  }
  return topicTemplateEntity;
}

Map<String, dynamic> $TopicTemplateEntityToJson(TopicTemplateEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['templates'] = entity.templates?.map((v) => v.toJson()).toList();
  return data;
}

extension TopicTemplateEntityExtension on TopicTemplateEntity {
  TopicTemplateEntity copyWith({
    List<TopicTemplateTemplates>? templates,
  }) {
    return TopicTemplateEntity()
      ..templates = templates ?? this.templates;
  }
}

TopicTemplateTemplates $TopicTemplateTemplatesFromJson(Map<String, dynamic> json) {
  final TopicTemplateTemplates topicTemplateTemplates = TopicTemplateTemplates();
  final bool? active = jsonConvert.convert<bool>(json['active']);
  if (active != null) {
    topicTemplateTemplates.active = active;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    topicTemplateTemplates.id = id;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    topicTemplateTemplates.sort = sort;
  }
  final String? sourceType = jsonConvert.convert<String>(json['sourceType']);
  if (sourceType != null) {
    topicTemplateTemplates.sourceType = sourceType;
  }
  final List<TopicTemplateTemplatesNavs>? navs = (json['navs'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<TopicTemplateTemplatesNavs>(e) as TopicTemplateTemplatesNavs).toList();
  if (navs != null) {
    topicTemplateTemplates.navs = navs;
  }
  return topicTemplateTemplates;
}

Map<String, dynamic> $TopicTemplateTemplatesToJson(TopicTemplateTemplates entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['active'] = entity.active;
  data['id'] = entity.id;
  data['sort'] = entity.sort;
  data['sourceType'] = entity.sourceType;
  data['navs'] = entity.navs?.map((v) => v.toJson()).toList();
  return data;
}

extension TopicTemplateTemplatesExtension on TopicTemplateTemplates {
  TopicTemplateTemplates copyWith({
    bool? active,
    String? id,
    int? sort,
    String? sourceType,
    List<TopicTemplateTemplatesNavs>? navs,
  }) {
    return TopicTemplateTemplates()
      ..active = active ?? this.active
      ..id = id ?? this.id
      ..sort = sort ?? this.sort
      ..sourceType = sourceType ?? this.sourceType
      ..navs = navs ?? this.navs;
  }
}

TopicTemplateTemplatesNavs $TopicTemplateTemplatesNavsFromJson(Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavs topicTemplateTemplatesNavs = TopicTemplateTemplatesNavs();
  final String? navId = jsonConvert.convert<String>(json['navId']);
  if (navId != null) {
    topicTemplateTemplatesNavs.navId = navId;
  }
  final String? navName = jsonConvert.convert<String>(json['navName']);
  if (navName != null) {
    topicTemplateTemplatesNavs.navName = navName;
  }
  final String? navCode = jsonConvert.convert<String>(json['navCode']);
  if (navCode != null) {
    topicTemplateTemplatesNavs.navCode = navCode;
  }
  final List<TopicTemplateTemplatesNavsTabs>? tabs = (json['tabs'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<TopicTemplateTemplatesNavsTabs>(e) as TopicTemplateTemplatesNavsTabs).toList();
  if (tabs != null) {
    topicTemplateTemplatesNavs.tabs = tabs;
  }
  return topicTemplateTemplatesNavs;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsToJson(TopicTemplateTemplatesNavs entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['navId'] = entity.navId;
  data['navName'] = entity.navName;
  data['navCode'] = entity.navCode;
  data['tabs'] = entity.tabs?.map((v) => v.toJson()).toList();
  return data;
}

extension TopicTemplateTemplatesNavsExtension on TopicTemplateTemplatesNavs {
  TopicTemplateTemplatesNavs copyWith({
    String? navId,
    String? navName,
    String? navCode,
    List<TopicTemplateTemplatesNavsTabs>? tabs,
  }) {
    return TopicTemplateTemplatesNavs()
      ..navId = navId ?? this.navId
      ..navName = navName ?? this.navName
      ..navCode = navCode ?? this.navCode
      ..tabs = tabs ?? this.tabs;
  }
}

TopicTemplateTemplatesNavsTabs $TopicTemplateTemplatesNavsTabsFromJson(Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabs topicTemplateTemplatesNavsTabs = TopicTemplateTemplatesNavsTabs();
  final String? tabId = jsonConvert.convert<String>(json['tabId']);
  if (tabId != null) {
    topicTemplateTemplatesNavsTabs.tabId = tabId;
  }
  final String? tabName = jsonConvert.convert<String>(json['tabName']);
  if (tabName != null) {
    topicTemplateTemplatesNavsTabs.tabName = tabName;
  }
  final String? tabCode = jsonConvert.convert<String>(json['tabCode']);
  if (tabCode != null) {
    topicTemplateTemplatesNavsTabs.tabCode = tabCode;
  }
  final bool? ifHidden = jsonConvert.convert<bool>(json['ifHidden']);
  if (ifHidden != null) {
    topicTemplateTemplatesNavsTabs.ifHidden = ifHidden;
  }
  final List<TopicTemplateTemplatesNavsTabsCards>? cards = (json['cards'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<TopicTemplateTemplatesNavsTabsCards>(e) as TopicTemplateTemplatesNavsTabsCards)
      .toList();
  if (cards != null) {
    topicTemplateTemplatesNavsTabs.cards = cards;
  }
  final TopicTemplateTemplatesNavsTabsConfig? config = jsonConvert.convert<TopicTemplateTemplatesNavsTabsConfig>(
      json['config']);
  if (config != null) {
    topicTemplateTemplatesNavsTabs.config = config;
  }
  return topicTemplateTemplatesNavsTabs;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsToJson(TopicTemplateTemplatesNavsTabs entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['tabId'] = entity.tabId;
  data['tabName'] = entity.tabName;
  data['tabCode'] = entity.tabCode;
  data['ifHidden'] = entity.ifHidden;
  data['cards'] = entity.cards?.map((v) => v.toJson()).toList();
  data['config'] = entity.config?.toJson();
  return data;
}

extension TopicTemplateTemplatesNavsTabsExtension on TopicTemplateTemplatesNavsTabs {
  TopicTemplateTemplatesNavsTabs copyWith({
    String? tabId,
    String? tabName,
    String? tabCode,
    bool? ifHidden,
    List<TopicTemplateTemplatesNavsTabsCards>? cards,
    TopicTemplateTemplatesNavsTabsConfig? config,
  }) {
    return TopicTemplateTemplatesNavsTabs()
      ..tabId = tabId ?? this.tabId
      ..tabName = tabName ?? this.tabName
      ..tabCode = tabCode ?? this.tabCode
      ..ifHidden = ifHidden ?? this.ifHidden
      ..cards = cards ?? this.cards
      ..config = config ?? this.config;
  }
}

TopicTemplateTemplatesNavsTabsCards $TopicTemplateTemplatesNavsTabsCardsFromJson(Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCards topicTemplateTemplatesNavsTabsCards = TopicTemplateTemplatesNavsTabsCards();
  final String? cardId = jsonConvert.convert<String>(json['cardId']);
  if (cardId != null) {
    topicTemplateTemplatesNavsTabsCards.cardId = cardId;
  }
  final String? cardName = jsonConvert.convert<String>(json['cardName']);
  if (cardName != null) {
    topicTemplateTemplatesNavsTabsCards.cardName = cardName;
  }
  final String? templateName = jsonConvert.convert<String>(json['templateName']);
  if (templateName != null) {
    topicTemplateTemplatesNavsTabsCards.templateName = templateName;
  }
  final String? cardCode = jsonConvert.convert<String>(json['cardCode']);
  if (cardCode != null) {
    topicTemplateTemplatesNavsTabsCards.cardCode = cardCode;
  }
  final TopicTemplateTemplatesNavsTabsCardsCardMetadata? cardMetadata = jsonConvert.convert<
      TopicTemplateTemplatesNavsTabsCardsCardMetadata>(json['cardMetadata']);
  if (cardMetadata != null) {
    topicTemplateTemplatesNavsTabsCards.cardMetadata = cardMetadata;
  }
  return topicTemplateTemplatesNavsTabsCards;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsToJson(TopicTemplateTemplatesNavsTabsCards entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardId'] = entity.cardId;
  data['cardName'] = entity.cardName;
  data['templateName'] = entity.templateName;
  data['cardCode'] = entity.cardCode;
  data['cardMetadata'] = entity.cardMetadata?.toJson();
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsExtension on TopicTemplateTemplatesNavsTabsCards {
  TopicTemplateTemplatesNavsTabsCards copyWith({
    String? cardId,
    String? cardName,
    String? templateName,
    String? cardCode,
    TopicTemplateTemplatesNavsTabsCardsCardMetadata? cardMetadata,
  }) {
    return TopicTemplateTemplatesNavsTabsCards()
      ..cardId = cardId ?? this.cardId
      ..cardName = cardName ?? this.cardName
      ..templateName = templateName ?? this.templateName
      ..cardCode = cardCode ?? this.cardCode
      ..cardMetadata = cardMetadata ?? this.cardMetadata;
  }
}

TopicTemplateTemplatesNavsTabsConfig $TopicTemplateTemplatesNavsTabsConfigFromJson(Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsConfig topicTemplateTemplatesNavsTabsConfig = TopicTemplateTemplatesNavsTabsConfig();
  final bool? locked = jsonConvert.convert<bool>(json['locked']);
  if (locked != null) {
    topicTemplateTemplatesNavsTabsConfig.locked = locked;
  }
  final String? beginVersion = jsonConvert.convert<String>(json['beginVersion']);
  if (beginVersion != null) {
    topicTemplateTemplatesNavsTabsConfig.beginVersion = beginVersion;
  }
  final String? endVersion = jsonConvert.convert<String>(json['endVersion']);
  if (endVersion != null) {
    topicTemplateTemplatesNavsTabsConfig.endVersion = endVersion;
  }
  return topicTemplateTemplatesNavsTabsConfig;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsConfigToJson(TopicTemplateTemplatesNavsTabsConfig entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['locked'] = entity.locked;
  data['beginVersion'] = entity.beginVersion;
  data['endVersion'] = entity.endVersion;
  return data;
}

extension TopicTemplateTemplatesNavsTabsConfigExtension on TopicTemplateTemplatesNavsTabsConfig {
  TopicTemplateTemplatesNavsTabsConfig copyWith({
    bool? locked,
    String? beginVersion,
    String? endVersion,
  }) {
    return TopicTemplateTemplatesNavsTabsConfig()
      ..locked = locked ?? this.locked
      ..beginVersion = beginVersion ?? this.beginVersion
      ..endVersion = endVersion ?? this.endVersion;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadata $TopicTemplateTemplatesNavsTabsCardsCardMetadataFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadata topicTemplateTemplatesNavsTabsCardsCardMetadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata();
  final TopicCardType? cardType = jsonConvert.convert<TopicCardType>(
      json['cardType'], enumConvert: (v) => TopicCardType.values.byName(v));
  if (cardType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.cardType = cardType;
  }
  final String? groupCode = jsonConvert.convert<String>(json['groupCode']);
  if (groupCode != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.groupCode = groupCode;
  }
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo? compareInfo = jsonConvert.convert<
      TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo>(json['compareInfo']);
  if (compareInfo != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.compareInfo = compareInfo;
  }
  final List<TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>? chartType = (json['chartType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>(
          e) as TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType).toList();
  if (chartType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.chartType = chartType;
  }
  final List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>(
          e) as TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics)
      .toList();
  if (metrics != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.metrics = metrics;
  }
  final List<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>? dims = (json['dims'] as List<dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>(
          e) as TopicTemplateTemplatesNavsTabsCardsCardMetadataDims).toList();
  if (dims != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadata.dims = dims;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadata;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadata entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardType'] = entity.cardType?.name;
  data['groupCode'] = entity.groupCode;
  data['compareInfo'] = entity.compareInfo?.toJson();
  data['chartType'] = entity.chartType?.map((v) => v.toJson()).toList();
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadata {
  TopicTemplateTemplatesNavsTabsCardsCardMetadata copyWith({
    TopicCardType? cardType,
    String? groupCode,
    TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo? compareInfo,
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>? chartType,
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>? metrics,
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>? dims,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadata()
      ..cardType = cardType ?? this.cardType
      ..groupCode = groupCode ?? this.groupCode
      ..compareInfo = compareInfo ?? this.compareInfo
      ..chartType = chartType ?? this.chartType
      ..metrics = metrics ?? this.metrics
      ..dims = dims ?? this.dims;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType $TopicTemplateTemplatesNavsTabsCardsCardMetadataChartTypeFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType topicTemplateTemplatesNavsTabsCardsCardMetadataChartType = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
  final AddMetricsChartType? code = jsonConvert.convert<AddMetricsChartType>(
      json['code'], enumConvert: (v) => AddMetricsChartType.values.byName(v));
  if (code != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataChartType.code = code;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataChartType;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataChartTypeToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code?.name;
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataChartTypeExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType copyWith({
    AddMetricsChartType? code,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType()
      ..code = code ?? this.code;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo = TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo();
  final AddMetricsCompareType? compareType = jsonConvert.convert<AddMetricsCompareType>(
      json['compareType'], enumConvert: (v) => AddMetricsCompareType.values.byName(v));
  if (compareType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo.compareType = compareType;
  }
  final List<TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>? metrics = (json['metrics'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>(
          e) as TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics).toList();
  if (metrics != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo.metrics = metrics;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['compareType'] = entity.compareType?.name;
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo copyWith({
    AddMetricsCompareType? compareType,
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>? metrics,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo()
      ..compareType = compareType ?? this.compareType
      ..metrics = metrics ?? this.metrics;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetricsFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics = TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.metricName = metricName;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(
      json['dataType'], enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.dataType = dataType;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.reportId = reportId;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetricsToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['dataType'] = entity.dataType?.name;
  data['reportId'] = entity.reportId;
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetricsExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics copyWith({
    String? metricCode,
    String? metricName,
    MetricOrDimDataType? dataType,
    List<String>? reportId,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..dataType = dataType ?? this.dataType
      ..reportId = reportId ?? this.reportId;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricsFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics = TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.metricName = metricName;
  }
  final bool? ifHidden = jsonConvert.convert<bool>(json['ifHidden']);
  if (ifHidden != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.ifHidden = ifHidden;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(
      json['dataType'], enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.dataType = dataType;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.reportId = reportId;
  }
  final List<String>? dimOptions = (json['dimOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (dimOptions != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.dimOptions = dimOptions;
  }
  final List<
      TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation = (json['metricExplanation'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>(
          e) as TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation).toList();
  if (metricExplanation != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.metricExplanation = metricExplanation;
  }
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.entity = entity;
  }
  final String? entityTitle = jsonConvert.convert<String>(json['entityTitle']);
  if (entityTitle != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.entityTitle = entityTitle;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataMetrics;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricsToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['ifHidden'] = entity.ifHidden;
  data['dataType'] = entity.dataType?.name;
  data['reportId'] = entity.reportId;
  data['dimOptions'] = entity.dimOptions;
  data['metricExplanation'] = entity.metricExplanation?.map((v) => v.toJson()).toList();
  data['entity'] = entity.entity;
  data['entityTitle'] = entity.entityTitle;
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricsExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics copyWith({
    String? metricCode,
    String? metricName,
    bool? ifHidden,
    MetricOrDimDataType? dataType,
    List<String>? reportId,
    List<String>? dimOptions,
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation,
    String? entity,
    String? entityTitle,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..ifHidden = ifHidden ?? this.ifHidden
      ..dataType = dataType ?? this.dataType
      ..reportId = reportId ?? this.reportId
      ..dimOptions = dimOptions ?? this.dimOptions
      ..metricExplanation = metricExplanation ?? this.metricExplanation
      ..entity = entity ?? this.entity
      ..entityTitle = entityTitle ?? this.entityTitle;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanationFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation topicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation = TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation.title = title;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation.msg = msg;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanationToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['msg'] = entity.msg;
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanationExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation copyWith({
    String? title,
    String? msg,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation()
      ..title = title ?? this.title
      ..msg = msg ?? this.msg;
  }
}

TopicTemplateTemplatesNavsTabsCardsCardMetadataDims $TopicTemplateTemplatesNavsTabsCardsCardMetadataDimsFromJson(
    Map<String, dynamic> json) {
  final TopicTemplateTemplatesNavsTabsCardsCardMetadataDims topicTemplateTemplatesNavsTabsCardsCardMetadataDims = TopicTemplateTemplatesNavsTabsCardsCardMetadataDims();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataDims.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataDims.dimName = dimName;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(
      json['dataType'], enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataDims.dataType = dataType;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataDims.reportId = reportId;
  }
  final List<String>? metricOptions = (json['metricOptions'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (metricOptions != null) {
    topicTemplateTemplatesNavsTabsCardsCardMetadataDims.metricOptions = metricOptions;
  }
  return topicTemplateTemplatesNavsTabsCardsCardMetadataDims;
}

Map<String, dynamic> $TopicTemplateTemplatesNavsTabsCardsCardMetadataDimsToJson(
    TopicTemplateTemplatesNavsTabsCardsCardMetadataDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['dataType'] = entity.dataType?.name;
  data['reportId'] = entity.reportId;
  data['metricOptions'] = entity.metricOptions;
  return data;
}

extension TopicTemplateTemplatesNavsTabsCardsCardMetadataDimsExtension on TopicTemplateTemplatesNavsTabsCardsCardMetadataDims {
  TopicTemplateTemplatesNavsTabsCardsCardMetadataDims copyWith({
    String? dimCode,
    String? dimName,
    MetricOrDimDataType? dataType,
    List<String>? reportId,
    List<String>? metricOptions,
  }) {
    return TopicTemplateTemplatesNavsTabsCardsCardMetadataDims()
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..dataType = dataType ?? this.dataType
      ..reportId = reportId ?? this.reportId
      ..metricOptions = metricOptions ?? this.metricOptions;
  }
}