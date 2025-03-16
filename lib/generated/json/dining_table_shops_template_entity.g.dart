import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/dining_table/dining_table_shops_template_entity.dart';

DiningTableShopsTemplateEntity $DiningTableShopsTemplateEntityFromJson(Map<String, dynamic> json) {
  final DiningTableShopsTemplateEntity diningTableShopsTemplateEntity = DiningTableShopsTemplateEntity();
  final String? cardId = jsonConvert.convert<String>(json['cardId']);
  if (cardId != null) {
    diningTableShopsTemplateEntity.cardId = cardId;
  }
  final String? cardName = jsonConvert.convert<String>(json['cardName']);
  if (cardName != null) {
    diningTableShopsTemplateEntity.cardName = cardName;
  }
  final DiningTableShopsTemplateCardMetadata? cardMetadata = jsonConvert.convert<DiningTableShopsTemplateCardMetadata>(
      json['cardMetadata']);
  if (cardMetadata != null) {
    diningTableShopsTemplateEntity.cardMetadata = cardMetadata;
  }
  return diningTableShopsTemplateEntity;
}

Map<String, dynamic> $DiningTableShopsTemplateEntityToJson(DiningTableShopsTemplateEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardId'] = entity.cardId;
  data['cardName'] = entity.cardName;
  data['cardMetadata'] = entity.cardMetadata?.toJson();
  return data;
}

extension DiningTableShopsTemplateEntityExtension on DiningTableShopsTemplateEntity {
  DiningTableShopsTemplateEntity copyWith({
    String? cardId,
    String? cardName,
    DiningTableShopsTemplateCardMetadata? cardMetadata,
  }) {
    return DiningTableShopsTemplateEntity()
      ..cardId = cardId ?? this.cardId
      ..cardName = cardName ?? this.cardName
      ..cardMetadata = cardMetadata ?? this.cardMetadata;
  }
}

DiningTableShopsTemplateCardMetadata $DiningTableShopsTemplateCardMetadataFromJson(Map<String, dynamic> json) {
  final DiningTableShopsTemplateCardMetadata diningTableShopsTemplateCardMetadata = DiningTableShopsTemplateCardMetadata();
  final List<DiningTableShopsTemplateCardMetadataMetrics>? metrics = (json['metrics'] as List<dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DiningTableShopsTemplateCardMetadataMetrics>(
          e) as DiningTableShopsTemplateCardMetadataMetrics).toList();
  if (metrics != null) {
    diningTableShopsTemplateCardMetadata.metrics = metrics;
  }
  final List<DiningTableShopsTemplateCardMetadataDims>? dims = (json['dims'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DiningTableShopsTemplateCardMetadataDims>(e) as DiningTableShopsTemplateCardMetadataDims)
      .toList();
  if (dims != null) {
    diningTableShopsTemplateCardMetadata.dims = dims;
  }
  return diningTableShopsTemplateCardMetadata;
}

Map<String, dynamic> $DiningTableShopsTemplateCardMetadataToJson(DiningTableShopsTemplateCardMetadata entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  return data;
}

extension DiningTableShopsTemplateCardMetadataExtension on DiningTableShopsTemplateCardMetadata {
  DiningTableShopsTemplateCardMetadata copyWith({
    List<DiningTableShopsTemplateCardMetadataMetrics>? metrics,
    List<DiningTableShopsTemplateCardMetadataDims>? dims,
  }) {
    return DiningTableShopsTemplateCardMetadata()
      ..metrics = metrics ?? this.metrics
      ..dims = dims ?? this.dims;
  }
}

DiningTableShopsTemplateCardMetadataMetrics $DiningTableShopsTemplateCardMetadataMetricsFromJson(
    Map<String, dynamic> json) {
  final DiningTableShopsTemplateCardMetadataMetrics diningTableShopsTemplateCardMetadataMetrics = DiningTableShopsTemplateCardMetadataMetrics();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    diningTableShopsTemplateCardMetadataMetrics.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    diningTableShopsTemplateCardMetadataMetrics.metricName = metricName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    diningTableShopsTemplateCardMetadataMetrics.ifDefault = ifDefault;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    diningTableShopsTemplateCardMetadataMetrics.reportId = reportId;
  }
  return diningTableShopsTemplateCardMetadataMetrics;
}

Map<String, dynamic> $DiningTableShopsTemplateCardMetadataMetricsToJson(
    DiningTableShopsTemplateCardMetadataMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['ifDefault'] = entity.ifDefault;
  data['reportId'] = entity.reportId;
  return data;
}

extension DiningTableShopsTemplateCardMetadataMetricsExtension on DiningTableShopsTemplateCardMetadataMetrics {
  DiningTableShopsTemplateCardMetadataMetrics copyWith({
    String? metricCode,
    String? metricName,
    bool? ifDefault,
    List<String>? reportId,
  }) {
    return DiningTableShopsTemplateCardMetadataMetrics()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..reportId = reportId ?? this.reportId;
  }
}

DiningTableShopsTemplateCardMetadataDims $DiningTableShopsTemplateCardMetadataDimsFromJson(Map<String, dynamic> json) {
  final DiningTableShopsTemplateCardMetadataDims diningTableShopsTemplateCardMetadataDims = DiningTableShopsTemplateCardMetadataDims();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    diningTableShopsTemplateCardMetadataDims.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    diningTableShopsTemplateCardMetadataDims.dimName = dimName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    diningTableShopsTemplateCardMetadataDims.ifDefault = ifDefault;
  }
  final List<String>? reportId = (json['reportId'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    diningTableShopsTemplateCardMetadataDims.reportId = reportId;
  }
  return diningTableShopsTemplateCardMetadataDims;
}

Map<String, dynamic> $DiningTableShopsTemplateCardMetadataDimsToJson(DiningTableShopsTemplateCardMetadataDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['ifDefault'] = entity.ifDefault;
  data['reportId'] = entity.reportId;
  return data;
}

extension DiningTableShopsTemplateCardMetadataDimsExtension on DiningTableShopsTemplateCardMetadataDims {
  DiningTableShopsTemplateCardMetadataDims copyWith({
    String? dimCode,
    String? dimName,
    bool? ifDefault,
    List<String>? reportId,
  }) {
    return DiningTableShopsTemplateCardMetadataDims()
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..reportId = reportId ?? this.reportId;
  }
}