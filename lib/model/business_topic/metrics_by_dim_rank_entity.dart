import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/metrics_by_dim_rank_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class MetricsByDimRankEntity {
  MetricsByDimRankPage? page;
  List<MetricsByDimRankList>? list;

  MetricsByDimRankEntity();

  factory MetricsByDimRankEntity.fromJson(Map<String, dynamic> json) => $MetricsByDimRankEntityFromJson(json);

  Map<String, dynamic> toJson() => $MetricsByDimRankEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsByDimRankPage {
  int? total;
  int? pageNo;
  int? pageSize;

  MetricsByDimRankPage();

  factory MetricsByDimRankPage.fromJson(Map<String, dynamic> json) => $MetricsByDimRankPageFromJson(json);

  Map<String, dynamic> toJson() => $MetricsByDimRankPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MetricsByDimRankList {
  String? metricsValue;
  // 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? metricsDataType;

  String? dimCode;
  String? dimValue;
  num? percent;

  MetricsByDimRankList();

  factory MetricsByDimRankList.fromJson(Map<String, dynamic> json) => $MetricsByDimRankListFromJson(json);

  Map<String, dynamic> toJson() => $MetricsByDimRankListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
