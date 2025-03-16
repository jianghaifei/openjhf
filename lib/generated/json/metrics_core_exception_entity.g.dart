import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/metrics_core_exception_entity.dart';

MetricsCoreExceptionEntity $MetricsCoreExceptionEntityFromJson(Map<String, dynamic> json) {
  final MetricsCoreExceptionEntity metricsCoreExceptionEntity = MetricsCoreExceptionEntity();
  final MetricsCoreExceptionPage? page = jsonConvert.convert<MetricsCoreExceptionPage>(json['page']);
  if (page != null) {
    metricsCoreExceptionEntity.page = page;
  }
  final List<MetricsCoreExceptionList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<MetricsCoreExceptionList>(e) as MetricsCoreExceptionList).toList();
  if (list != null) {
    metricsCoreExceptionEntity.list = list;
  }
  return metricsCoreExceptionEntity;
}

Map<String, dynamic> $MetricsCoreExceptionEntityToJson(MetricsCoreExceptionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page?.toJson();
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension MetricsCoreExceptionEntityExtension on MetricsCoreExceptionEntity {
  MetricsCoreExceptionEntity copyWith({
    MetricsCoreExceptionPage? page,
    List<MetricsCoreExceptionList>? list,
  }) {
    return MetricsCoreExceptionEntity()
      ..page = page ?? this.page
      ..list = list ?? this.list;
  }
}

MetricsCoreExceptionPage $MetricsCoreExceptionPageFromJson(Map<String, dynamic> json) {
  final MetricsCoreExceptionPage metricsCoreExceptionPage = MetricsCoreExceptionPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    metricsCoreExceptionPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    metricsCoreExceptionPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    metricsCoreExceptionPage.pageSize = pageSize;
  }
  return metricsCoreExceptionPage;
}

Map<String, dynamic> $MetricsCoreExceptionPageToJson(MetricsCoreExceptionPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  return data;
}

extension MetricsCoreExceptionPageExtension on MetricsCoreExceptionPage {
  MetricsCoreExceptionPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
  }) {
    return MetricsCoreExceptionPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize;
  }
}

MetricsCoreExceptionList $MetricsCoreExceptionListFromJson(Map<String, dynamic> json) {
  final MetricsCoreExceptionList metricsCoreExceptionList = MetricsCoreExceptionList();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    metricsCoreExceptionList.code = code;
  }
  final String? fieldName = jsonConvert.convert<String>(json['fieldName']);
  if (fieldName != null) {
    metricsCoreExceptionList.fieldName = fieldName;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    metricsCoreExceptionList.value = value;
  }
  final num? percent = jsonConvert.convert<num>(json['percent']);
  if (percent != null) {
    metricsCoreExceptionList.percent = percent;
  }
  return metricsCoreExceptionList;
}

Map<String, dynamic> $MetricsCoreExceptionListToJson(MetricsCoreExceptionList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['fieldName'] = entity.fieldName;
  data['value'] = entity.value;
  data['percent'] = entity.percent;
  return data;
}

extension MetricsCoreExceptionListExtension on MetricsCoreExceptionList {
  MetricsCoreExceptionList copyWith({
    String? code,
    String? fieldName,
    String? value,
    num? percent,
  }) {
    return MetricsCoreExceptionList()
      ..code = code ?? this.code
      ..fieldName = fieldName ?? this.fieldName
      ..value = value ?? this.value
      ..percent = percent ?? this.percent;
  }
}