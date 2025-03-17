import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/dining_table_shops_template_entity.g.dart';

export 'package:flutter_report_project/generated/json/dining_table_shops_template_entity.g.dart';

@JsonSerializable()
class DiningTableShopsTemplateEntity {
  String? cardId;
  String? cardName;
  DiningTableShopsTemplateCardMetadata? cardMetadata;

  DiningTableShopsTemplateEntity();

  factory DiningTableShopsTemplateEntity.fromJson(Map<String, dynamic> json) =>
      $DiningTableShopsTemplateEntityFromJson(json);

  Map<String, dynamic> toJson() => $DiningTableShopsTemplateEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DiningTableShopsTemplateCardMetadata {
  List<DiningTableShopsTemplateCardMetadataMetrics>? metrics;
  List<DiningTableShopsTemplateCardMetadataDims>? dims;

  DiningTableShopsTemplateCardMetadata();

  factory DiningTableShopsTemplateCardMetadata.fromJson(Map<String, dynamic> json) =>
      $DiningTableShopsTemplateCardMetadataFromJson(json);

  Map<String, dynamic> toJson() => $DiningTableShopsTemplateCardMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DiningTableShopsTemplateCardMetadataMetrics {
  String? metricCode;
  String? metricName;
  bool ifDefault = false;
  List<String>? reportId;

  DiningTableShopsTemplateCardMetadataMetrics();

  factory DiningTableShopsTemplateCardMetadataMetrics.fromJson(Map<String, dynamic> json) =>
      $DiningTableShopsTemplateCardMetadataMetricsFromJson(json);

  Map<String, dynamic> toJson() => $DiningTableShopsTemplateCardMetadataMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DiningTableShopsTemplateCardMetadataDims {
  String? dimCode;
  String? dimName;
  bool ifDefault = false;
  List<String>? reportId;

  DiningTableShopsTemplateCardMetadataDims();

  factory DiningTableShopsTemplateCardMetadataDims.fromJson(Map<String, dynamic> json) =>
      $DiningTableShopsTemplateCardMetadataDimsFromJson(json);

  Map<String, dynamic> toJson() => $DiningTableShopsTemplateCardMetadataDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
