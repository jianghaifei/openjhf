import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/store_pk_entity.g.dart';

export 'package:flutter_report_project/generated/json/store_pk_entity.g.dart';

@JsonSerializable()
class StorePKEntity {
  String? cardId;
  String? cardName;
  String? cardCode;
  String? templateCode;
  StorePKCardMetadata? cardMetadata;

  StorePKEntity();

  factory StorePKEntity.fromJson(Map<String, dynamic> json) => $StorePKEntityFromJson(json);

  Map<String, dynamic> toJson() => $StorePKEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKCardMetadata {
  String? cardType;
  List<StorePKCardMetadataCardGroup>? cardGroup;

  StorePKCardMetadata();

  factory StorePKCardMetadata.fromJson(Map<String, dynamic> json) => $StorePKCardMetadataFromJson(json);

  Map<String, dynamic> toJson() => $StorePKCardMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKCardMetadataCardGroup {
  String? groupCode;
  String? groupName;
  List<StorePKCardMetadataCardGroupMetadata>? metadata;

  StorePKCardMetadataCardGroup();

  factory StorePKCardMetadataCardGroup.fromJson(Map<String, dynamic> json) =>
      $StorePKCardMetadataCardGroupFromJson(json);

  Map<String, dynamic> toJson() => $StorePKCardMetadataCardGroupToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKCardMetadataCardGroupMetadata {
  String? cardType;
  List<StorePKCardMetadataCardGroupMetadataMetrics>? metrics;
  List<StorePKCardMetadataCardGroupMetadataDims>? dims;

  StorePKCardMetadataCardGroupMetadata();

  factory StorePKCardMetadataCardGroupMetadata.fromJson(Map<String, dynamic> json) =>
      $StorePKCardMetadataCardGroupMetadataFromJson(json);

  Map<String, dynamic> toJson() => $StorePKCardMetadataCardGroupMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKCardMetadataCardGroupMetadataMetrics {
  String? metricCode;
  String? metricName;
  bool ifDefault = false;
  List<String>? reportId;

  StorePKCardMetadataCardGroupMetadataMetrics();

  factory StorePKCardMetadataCardGroupMetadataMetrics.fromJson(Map<String, dynamic> json) =>
      $StorePKCardMetadataCardGroupMetadataMetricsFromJson(json);

  Map<String, dynamic> toJson() => $StorePKCardMetadataCardGroupMetadataMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKCardMetadataCardGroupMetadataDims {
  String? dimCode;
  String? dimName;
  bool ifDefault = false;
  List<String>? reportId;

  StorePKCardMetadataCardGroupMetadataDims();

  factory StorePKCardMetadataCardGroupMetadataDims.fromJson(Map<String, dynamic> json) =>
      $StorePKCardMetadataCardGroupMetadataDimsFromJson(json);

  Map<String, dynamic> toJson() => $StorePKCardMetadataCardGroupMetadataDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
