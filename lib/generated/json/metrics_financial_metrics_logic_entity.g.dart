import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/metrics_financial_metrics_logic_entity.dart';

MetricsFinancialMetricsLogicEntity $MetricsFinancialMetricsLogicEntityFromJson(Map<String, dynamic> json) {
  final MetricsFinancialMetricsLogicEntity metricsFinancialMetricsLogicEntity = MetricsFinancialMetricsLogicEntity();
  final MetricsFinancialMetricsLogicPage? page = jsonConvert.convert<MetricsFinancialMetricsLogicPage>(json['page']);
  if (page != null) {
    metricsFinancialMetricsLogicEntity.page = page;
  }
  final List<List<MetricsFinancialMetricsLogicList>>? list = (json['list'] as List<dynamic>?)?.map(
          (e) =>
          (e as List<dynamic>)
              .map(
                  (e) => jsonConvert.convert<MetricsFinancialMetricsLogicList>(e) as MetricsFinancialMetricsLogicList)
              .toList()).toList();
  if (list != null) {
    metricsFinancialMetricsLogicEntity.list = list;
  }
  return metricsFinancialMetricsLogicEntity;
}

Map<String, dynamic> $MetricsFinancialMetricsLogicEntityToJson(MetricsFinancialMetricsLogicEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page?.toJson();
  data['list'] = entity.list;
  return data;
}

extension MetricsFinancialMetricsLogicEntityExtension on MetricsFinancialMetricsLogicEntity {
  MetricsFinancialMetricsLogicEntity copyWith({
    MetricsFinancialMetricsLogicPage? page,
    List<List<MetricsFinancialMetricsLogicList>>? list,
  }) {
    return MetricsFinancialMetricsLogicEntity()
      ..page = page ?? this.page
      ..list = list ?? this.list;
  }
}

MetricsFinancialMetricsLogicPage $MetricsFinancialMetricsLogicPageFromJson(Map<String, dynamic> json) {
  final MetricsFinancialMetricsLogicPage metricsFinancialMetricsLogicPage = MetricsFinancialMetricsLogicPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    metricsFinancialMetricsLogicPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    metricsFinancialMetricsLogicPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    metricsFinancialMetricsLogicPage.pageSize = pageSize;
  }
  return metricsFinancialMetricsLogicPage;
}

Map<String, dynamic> $MetricsFinancialMetricsLogicPageToJson(MetricsFinancialMetricsLogicPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  return data;
}

extension MetricsFinancialMetricsLogicPageExtension on MetricsFinancialMetricsLogicPage {
  MetricsFinancialMetricsLogicPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
  }) {
    return MetricsFinancialMetricsLogicPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize;
  }
}

MetricsFinancialMetricsLogicList $MetricsFinancialMetricsLogicListFromJson(Map<String, dynamic> json) {
  final MetricsFinancialMetricsLogicList metricsFinancialMetricsLogicList = MetricsFinancialMetricsLogicList();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    metricsFinancialMetricsLogicList.code = code;
  }
  final bool? bold = jsonConvert.convert<bool>(json['bold']);
  if (bold != null) {
    metricsFinancialMetricsLogicList.bold = bold;
  }
  final String? symbol = jsonConvert.convert<String>(json['symbol']);
  if (symbol != null) {
    metricsFinancialMetricsLogicList.symbol = symbol;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    metricsFinancialMetricsLogicList.value = value;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    metricsFinancialMetricsLogicList.displayName = displayName;
  }
  return metricsFinancialMetricsLogicList;
}

Map<String, dynamic> $MetricsFinancialMetricsLogicListToJson(MetricsFinancialMetricsLogicList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['bold'] = entity.bold;
  data['symbol'] = entity.symbol;
  data['value'] = entity.value;
  data['displayName'] = entity.displayName;
  return data;
}

extension MetricsFinancialMetricsLogicListExtension on MetricsFinancialMetricsLogicList {
  MetricsFinancialMetricsLogicList copyWith({
    String? code,
    bool? bold,
    String? symbol,
    String? value,
    String? displayName,
  }) {
    return MetricsFinancialMetricsLogicList()
      ..code = code ?? this.code
      ..bold = bold ?? this.bold
      ..symbol = symbol ?? this.symbol
      ..value = value ?? this.value
      ..displayName = displayName ?? this.displayName;
  }
}