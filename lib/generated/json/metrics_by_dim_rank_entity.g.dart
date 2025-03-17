import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/metrics_by_dim_rank_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';


MetricsByDimRankEntity $MetricsByDimRankEntityFromJson(Map<String, dynamic> json) {
  final MetricsByDimRankEntity metricsByDimRankEntity = MetricsByDimRankEntity();
  final MetricsByDimRankPage? page = jsonConvert.convert<MetricsByDimRankPage>(json['page']);
  if (page != null) {
    metricsByDimRankEntity.page = page;
  }
  final List<MetricsByDimRankList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsByDimRankList>(e) as MetricsByDimRankList).toList();
  if (list != null) {
    metricsByDimRankEntity.list = list;
  }
  return metricsByDimRankEntity;
}

Map<String, dynamic> $MetricsByDimRankEntityToJson(MetricsByDimRankEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page?.toJson();
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension MetricsByDimRankEntityExtension on MetricsByDimRankEntity {
  MetricsByDimRankEntity copyWith({
    MetricsByDimRankPage? page,
    List<MetricsByDimRankList>? list,
  }) {
    return MetricsByDimRankEntity()
      ..page = page ?? this.page
      ..list = list ?? this.list;
  }
}

MetricsByDimRankPage $MetricsByDimRankPageFromJson(Map<String, dynamic> json) {
  final MetricsByDimRankPage metricsByDimRankPage = MetricsByDimRankPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    metricsByDimRankPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    metricsByDimRankPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    metricsByDimRankPage.pageSize = pageSize;
  }
  return metricsByDimRankPage;
}

Map<String, dynamic> $MetricsByDimRankPageToJson(MetricsByDimRankPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  return data;
}

extension MetricsByDimRankPageExtension on MetricsByDimRankPage {
  MetricsByDimRankPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
  }) {
    return MetricsByDimRankPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize;
  }
}

MetricsByDimRankList $MetricsByDimRankListFromJson(Map<String, dynamic> json) {
  final MetricsByDimRankList metricsByDimRankList = MetricsByDimRankList();
  final String? metricsValue = jsonConvert.convert<String>(json['metricsValue']);
  if (metricsValue != null) {
    metricsByDimRankList.metricsValue = metricsValue;
  }
  final MetricOrDimDataType? metricsDataType = jsonConvert.convert<MetricOrDimDataType>(
      json['metricsDataType'], enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (metricsDataType != null) {
    metricsByDimRankList.metricsDataType = metricsDataType;
  }
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    metricsByDimRankList.dimCode = dimCode;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    metricsByDimRankList.dimValue = dimValue;
  }
  final num? percent = jsonConvert.convert<num>(json['percent']);
  if (percent != null) {
    metricsByDimRankList.percent = percent;
  }
  return metricsByDimRankList;
}

Map<String, dynamic> $MetricsByDimRankListToJson(MetricsByDimRankList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricsValue'] = entity.metricsValue;
  data['metricsDataType'] = entity.metricsDataType?.name;
  data['dimCode'] = entity.dimCode;
  data['dimValue'] = entity.dimValue;
  data['percent'] = entity.percent;
  return data;
}

extension MetricsByDimRankListExtension on MetricsByDimRankList {
  MetricsByDimRankList copyWith({
    String? metricsValue,
    MetricOrDimDataType? metricsDataType,
    String? dimCode,
    String? dimValue,
    num? percent,
  }) {
    return MetricsByDimRankList()
      ..metricsValue = metricsValue ?? this.metricsValue
      ..metricsDataType = metricsDataType ?? this.metricsDataType
      ..dimCode = dimCode ?? this.dimCode
      ..dimValue = dimValue ?? this.dimValue
      ..percent = percent ?? this.percent;
  }
}