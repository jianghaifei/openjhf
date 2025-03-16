import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/store/store_pk/store_pk_entity.dart';

StorePKEntity $StorePKEntityFromJson(Map<String, dynamic> json) {
  final StorePKEntity storePKEntity = StorePKEntity();
  final String? cardId = jsonConvert.convert<String>(json['cardId']);
  if (cardId != null) {
    storePKEntity.cardId = cardId;
  }
  final String? cardName = jsonConvert.convert<String>(json['cardName']);
  if (cardName != null) {
    storePKEntity.cardName = cardName;
  }
  final String? cardCode = jsonConvert.convert<String>(json['cardCode']);
  if (cardCode != null) {
    storePKEntity.cardCode = cardCode;
  }
  final String? templateCode = jsonConvert.convert<String>(json['templateCode']);
  if (templateCode != null) {
    storePKEntity.templateCode = templateCode;
  }
  final StorePKCardMetadata? cardMetadata = jsonConvert.convert<StorePKCardMetadata>(json['cardMetadata']);
  if (cardMetadata != null) {
    storePKEntity.cardMetadata = cardMetadata;
  }
  return storePKEntity;
}

Map<String, dynamic> $StorePKEntityToJson(StorePKEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardId'] = entity.cardId;
  data['cardName'] = entity.cardName;
  data['cardCode'] = entity.cardCode;
  data['templateCode'] = entity.templateCode;
  data['cardMetadata'] = entity.cardMetadata?.toJson();
  return data;
}

extension StorePKEntityExtension on StorePKEntity {
  StorePKEntity copyWith({
    String? cardId,
    String? cardName,
    String? cardCode,
    String? templateCode,
    StorePKCardMetadata? cardMetadata,
  }) {
    return StorePKEntity()
      ..cardId = cardId ?? this.cardId
      ..cardName = cardName ?? this.cardName
      ..cardCode = cardCode ?? this.cardCode
      ..templateCode = templateCode ?? this.templateCode
      ..cardMetadata = cardMetadata ?? this.cardMetadata;
  }
}

StorePKCardMetadata $StorePKCardMetadataFromJson(Map<String, dynamic> json) {
  final StorePKCardMetadata storePKCardMetadata = StorePKCardMetadata();
  final String? cardType = jsonConvert.convert<String>(json['cardType']);
  if (cardType != null) {
    storePKCardMetadata.cardType = cardType;
  }
  final List<StorePKCardMetadataCardGroup>? cardGroup = (json['cardGroup'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<StorePKCardMetadataCardGroup>(e) as StorePKCardMetadataCardGroup)
      .toList();
  if (cardGroup != null) {
    storePKCardMetadata.cardGroup = cardGroup;
  }
  return storePKCardMetadata;
}

Map<String, dynamic> $StorePKCardMetadataToJson(StorePKCardMetadata entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardType'] = entity.cardType;
  data['cardGroup'] = entity.cardGroup?.map((v) => v.toJson()).toList();
  return data;
}

extension StorePKCardMetadataExtension on StorePKCardMetadata {
  StorePKCardMetadata copyWith({
    String? cardType,
    List<StorePKCardMetadataCardGroup>? cardGroup,
  }) {
    return StorePKCardMetadata()
      ..cardType = cardType ?? this.cardType
      ..cardGroup = cardGroup ?? this.cardGroup;
  }
}

StorePKCardMetadataCardGroup $StorePKCardMetadataCardGroupFromJson(Map<String, dynamic> json) {
  final StorePKCardMetadataCardGroup storePKCardMetadataCardGroup = StorePKCardMetadataCardGroup();
  final String? groupCode = jsonConvert.convert<String>(json['groupCode']);
  if (groupCode != null) {
    storePKCardMetadataCardGroup.groupCode = groupCode;
  }
  final String? groupName = jsonConvert.convert<String>(json['groupName']);
  if (groupName != null) {
    storePKCardMetadataCardGroup.groupName = groupName;
  }
  final List<StorePKCardMetadataCardGroupMetadata>? metadata = (json['metadata'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<StorePKCardMetadataCardGroupMetadata>(e) as StorePKCardMetadataCardGroupMetadata)
      .toList();
  if (metadata != null) {
    storePKCardMetadataCardGroup.metadata = metadata;
  }
  return storePKCardMetadataCardGroup;
}

Map<String, dynamic> $StorePKCardMetadataCardGroupToJson(StorePKCardMetadataCardGroup entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['groupCode'] = entity.groupCode;
  data['groupName'] = entity.groupName;
  data['metadata'] = entity.metadata?.map((v) => v.toJson()).toList();
  return data;
}

extension StorePKCardMetadataCardGroupExtension on StorePKCardMetadataCardGroup {
  StorePKCardMetadataCardGroup copyWith({
    String? groupCode,
    String? groupName,
    List<StorePKCardMetadataCardGroupMetadata>? metadata,
  }) {
    return StorePKCardMetadataCardGroup()
      ..groupCode = groupCode ?? this.groupCode
      ..groupName = groupName ?? this.groupName
      ..metadata = metadata ?? this.metadata;
  }
}

StorePKCardMetadataCardGroupMetadata $StorePKCardMetadataCardGroupMetadataFromJson(Map<String, dynamic> json) {
  final StorePKCardMetadataCardGroupMetadata storePKCardMetadataCardGroupMetadata =
      StorePKCardMetadataCardGroupMetadata();
  final String? cardType = jsonConvert.convert<String>(json['cardType']);
  if (cardType != null) {
    storePKCardMetadataCardGroupMetadata.cardType = cardType;
  }
  final List<StorePKCardMetadataCardGroupMetadataMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<StorePKCardMetadataCardGroupMetadataMetrics>(e)
          as StorePKCardMetadataCardGroupMetadataMetrics)
      .toList();
  if (metrics != null) {
    storePKCardMetadataCardGroupMetadata.metrics = metrics;
  }
  final List<StorePKCardMetadataCardGroupMetadataDims>? dims = (json['dims'] as List<dynamic>?)
      ?.map((e) =>
          jsonConvert.convert<StorePKCardMetadataCardGroupMetadataDims>(e) as StorePKCardMetadataCardGroupMetadataDims)
      .toList();
  if (dims != null) {
    storePKCardMetadataCardGroupMetadata.dims = dims;
  }
  return storePKCardMetadataCardGroupMetadata;
}

Map<String, dynamic> $StorePKCardMetadataCardGroupMetadataToJson(StorePKCardMetadataCardGroupMetadata entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cardType'] = entity.cardType;
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  return data;
}

extension StorePKCardMetadataCardGroupMetadataExtension on StorePKCardMetadataCardGroupMetadata {
  StorePKCardMetadataCardGroupMetadata copyWith({
    String? cardType,
    List<StorePKCardMetadataCardGroupMetadataMetrics>? metrics,
    List<StorePKCardMetadataCardGroupMetadataDims>? dims,
  }) {
    return StorePKCardMetadataCardGroupMetadata()
      ..cardType = cardType ?? this.cardType
      ..metrics = metrics ?? this.metrics
      ..dims = dims ?? this.dims;
  }
}

StorePKCardMetadataCardGroupMetadataMetrics $StorePKCardMetadataCardGroupMetadataMetricsFromJson(
    Map<String, dynamic> json) {
  final StorePKCardMetadataCardGroupMetadataMetrics storePKCardMetadataCardGroupMetadataMetrics =
      StorePKCardMetadataCardGroupMetadataMetrics();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    storePKCardMetadataCardGroupMetadataMetrics.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    storePKCardMetadataCardGroupMetadataMetrics.metricName = metricName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    storePKCardMetadataCardGroupMetadataMetrics.ifDefault = ifDefault;
  }
  final List<String>? reportId =
      (json['reportId'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    storePKCardMetadataCardGroupMetadataMetrics.reportId = reportId;
  }
  return storePKCardMetadataCardGroupMetadataMetrics;
}

Map<String, dynamic> $StorePKCardMetadataCardGroupMetadataMetricsToJson(
    StorePKCardMetadataCardGroupMetadataMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['ifDefault'] = entity.ifDefault;
  data['reportId'] = entity.reportId;
  return data;
}

extension StorePKCardMetadataCardGroupMetadataMetricsExtension on StorePKCardMetadataCardGroupMetadataMetrics {
  StorePKCardMetadataCardGroupMetadataMetrics copyWith({
    String? metricCode,
    String? metricName,
    bool? ifDefault,
    List<String>? reportId,
  }) {
    return StorePKCardMetadataCardGroupMetadataMetrics()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..reportId = reportId ?? this.reportId;
  }
}

StorePKCardMetadataCardGroupMetadataDims $StorePKCardMetadataCardGroupMetadataDimsFromJson(Map<String, dynamic> json) {
  final StorePKCardMetadataCardGroupMetadataDims storePKCardMetadataCardGroupMetadataDims =
      StorePKCardMetadataCardGroupMetadataDims();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    storePKCardMetadataCardGroupMetadataDims.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    storePKCardMetadataCardGroupMetadataDims.dimName = dimName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    storePKCardMetadataCardGroupMetadataDims.ifDefault = ifDefault;
  }
  final List<String>? reportId =
      (json['reportId'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (reportId != null) {
    storePKCardMetadataCardGroupMetadataDims.reportId = reportId;
  }
  return storePKCardMetadataCardGroupMetadataDims;
}

Map<String, dynamic> $StorePKCardMetadataCardGroupMetadataDimsToJson(StorePKCardMetadataCardGroupMetadataDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['ifDefault'] = entity.ifDefault;
  data['reportId'] = entity.reportId;
  return data;
}

extension StorePKCardMetadataCardGroupMetadataDimsExtension on StorePKCardMetadataCardGroupMetadataDims {
  StorePKCardMetadataCardGroupMetadataDims copyWith({
    String? dimCode,
    String? dimName,
    bool? ifDefault,
    List<String>? reportId,
  }) {
    return StorePKCardMetadataCardGroupMetadataDims()
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..reportId = reportId ?? this.reportId;
  }
}
