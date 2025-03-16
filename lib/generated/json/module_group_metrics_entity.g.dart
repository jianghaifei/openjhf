import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_group_metrics_entity.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';

ModuleGroupMetricsEntity $ModuleGroupMetricsEntityFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsEntity moduleGroupMetricsEntity = ModuleGroupMetricsEntity();
  final List<ModuleGroupMetricsMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleGroupMetricsMetrics>(e) as ModuleGroupMetricsMetrics)
      .toList();
  if (metrics != null) {
    moduleGroupMetricsEntity.metrics = metrics;
  }
  final ModuleGroupMetricsReportData? reportData =
      jsonConvert.convert<ModuleGroupMetricsReportData>(json['reportData']);
  if (reportData != null) {
    moduleGroupMetricsEntity.reportData = reportData;
  }
  return moduleGroupMetricsEntity;
}

Map<String, dynamic> $ModuleGroupMetricsEntityToJson(ModuleGroupMetricsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['reportData'] = entity.reportData?.toJson();
  return data;
}

extension ModuleGroupMetricsEntityExtension on ModuleGroupMetricsEntity {
  ModuleGroupMetricsEntity copyWith({
    List<ModuleGroupMetricsMetrics>? metrics,
    ModuleGroupMetricsReportData? reportData,
  }) {
    return ModuleGroupMetricsEntity()
      ..metrics = metrics ?? this.metrics
      ..reportData = reportData ?? this.reportData;
  }
}

ModuleGroupMetricsMetrics $ModuleGroupMetricsMetricsFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsMetrics moduleGroupMetricsMetrics = ModuleGroupMetricsMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleGroupMetricsMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleGroupMetricsMetrics.value = value;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    moduleGroupMetricsMetrics.name = name;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleGroupMetricsMetrics.displayValue = displayValue;
  }
  final String? abbrDisplayValue = jsonConvert.convert<String>(json['abbrDisplayValue']);
  if (abbrDisplayValue != null) {
    moduleGroupMetricsMetrics.abbrDisplayValue = abbrDisplayValue;
  }
  final String? abbrDisplayUnit = jsonConvert.convert<String>(json['abbrDisplayUnit']);
  if (abbrDisplayUnit != null) {
    moduleGroupMetricsMetrics.abbrDisplayUnit = abbrDisplayUnit;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    moduleGroupMetricsMetrics.dataType = dataType;
  }
  final ModuleMetricsCardDrillDownInfo? drillDownInfo =
      jsonConvert.convert<ModuleMetricsCardDrillDownInfo>(json['drillDownInfo']);
  if (drillDownInfo != null) {
    moduleGroupMetricsMetrics.drillDownInfo = drillDownInfo;
  }
  return moduleGroupMetricsMetrics;
}

Map<String, dynamic> $ModuleGroupMetricsMetricsToJson(ModuleGroupMetricsMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['name'] = entity.name;
  data['displayValue'] = entity.displayValue;
  data['abbrDisplayValue'] = entity.abbrDisplayValue;
  data['abbrDisplayUnit'] = entity.abbrDisplayUnit;
  data['dataType'] = entity.dataType?.name;
  data['drillDownInfo'] = entity.drillDownInfo?.toJson();
  return data;
}

extension ModuleGroupMetricsMetricsExtension on ModuleGroupMetricsMetrics {
  ModuleGroupMetricsMetrics copyWith({
    String? code,
    String? value,
    String? name,
    String? displayValue,
    String? abbrDisplayValue,
    String? abbrDisplayUnit,
    MetricOrDimDataType? dataType,
    ModuleMetricsCardDrillDownInfo? drillDownInfo,
  }) {
    return ModuleGroupMetricsMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..name = name ?? this.name
      ..displayValue = displayValue ?? this.displayValue
      ..abbrDisplayValue = abbrDisplayValue ?? this.abbrDisplayValue
      ..abbrDisplayUnit = abbrDisplayUnit ?? this.abbrDisplayUnit
      ..dataType = dataType ?? this.dataType
      ..drillDownInfo = drillDownInfo ?? this.drillDownInfo;
  }
}

ModuleGroupMetricsReportData $ModuleGroupMetricsReportDataFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsReportData moduleGroupMetricsReportData = ModuleGroupMetricsReportData();
  final List<ModuleGroupMetricsReportDataRows>? rows = (json['rows'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleGroupMetricsReportDataRows>(e) as ModuleGroupMetricsReportDataRows)
      .toList();
  if (rows != null) {
    moduleGroupMetricsReportData.rows = rows;
  }
  final ModuleGroupMetricsReportDataPage? page = jsonConvert.convert<ModuleGroupMetricsReportDataPage>(json['page']);
  if (page != null) {
    moduleGroupMetricsReportData.page = page;
  }
  return moduleGroupMetricsReportData;
}

Map<String, dynamic> $ModuleGroupMetricsReportDataToJson(ModuleGroupMetricsReportData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  data['page'] = entity.page?.toJson();
  return data;
}

extension ModuleGroupMetricsReportDataExtension on ModuleGroupMetricsReportData {
  ModuleGroupMetricsReportData copyWith({
    List<ModuleGroupMetricsReportDataRows>? rows,
    ModuleGroupMetricsReportDataPage? page,
  }) {
    return ModuleGroupMetricsReportData()
      ..rows = rows ?? this.rows
      ..page = page ?? this.page;
  }
}

ModuleGroupMetricsReportDataRows $ModuleGroupMetricsReportDataRowsFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsReportDataRows moduleGroupMetricsReportDataRows = ModuleGroupMetricsReportDataRows();
  final List<ModuleGroupMetricsReportDataRowsDims>? dims = (json['dims'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleGroupMetricsReportDataRowsDims>(e) as ModuleGroupMetricsReportDataRowsDims)
      .toList();
  if (dims != null) {
    moduleGroupMetricsReportDataRows.dims = dims;
  }
  final List<ModuleGroupMetricsReportDataRowsMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) =>
          jsonConvert.convert<ModuleGroupMetricsReportDataRowsMetrics>(e) as ModuleGroupMetricsReportDataRowsMetrics)
      .toList();
  if (metrics != null) {
    moduleGroupMetricsReportDataRows.metrics = metrics;
  }
  return moduleGroupMetricsReportDataRows;
}

Map<String, dynamic> $ModuleGroupMetricsReportDataRowsToJson(ModuleGroupMetricsReportDataRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  return data;
}

extension ModuleGroupMetricsReportDataRowsExtension on ModuleGroupMetricsReportDataRows {
  ModuleGroupMetricsReportDataRows copyWith({
    List<ModuleGroupMetricsReportDataRowsDims>? dims,
    List<ModuleGroupMetricsReportDataRowsMetrics>? metrics,
  }) {
    return ModuleGroupMetricsReportDataRows()
      ..dims = dims ?? this.dims
      ..metrics = metrics ?? this.metrics;
  }
}

ModuleGroupMetricsReportDataRowsDims $ModuleGroupMetricsReportDataRowsDimsFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsReportDataRowsDims moduleGroupMetricsReportDataRowsDims =
      ModuleGroupMetricsReportDataRowsDims();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleGroupMetricsReportDataRowsDims.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleGroupMetricsReportDataRowsDims.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleGroupMetricsReportDataRowsDims.displayValue = displayValue;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    moduleGroupMetricsReportDataRowsDims.name = name;
  }
  return moduleGroupMetricsReportDataRowsDims;
}

Map<String, dynamic> $ModuleGroupMetricsReportDataRowsDimsToJson(ModuleGroupMetricsReportDataRowsDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['name'] = entity.name;
  return data;
}

extension ModuleGroupMetricsReportDataRowsDimsExtension on ModuleGroupMetricsReportDataRowsDims {
  ModuleGroupMetricsReportDataRowsDims copyWith({
    String? code,
    String? value,
    String? displayValue,
    String? name,
  }) {
    return ModuleGroupMetricsReportDataRowsDims()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..name = name ?? this.name;
  }
}

ModuleGroupMetricsReportDataRowsMetrics $ModuleGroupMetricsReportDataRowsMetricsFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsReportDataRowsMetrics moduleGroupMetricsReportDataRowsMetrics =
      ModuleGroupMetricsReportDataRowsMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleGroupMetricsReportDataRowsMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleGroupMetricsReportDataRowsMetrics.value = value;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    moduleGroupMetricsReportDataRowsMetrics.name = name;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleGroupMetricsReportDataRowsMetrics.displayValue = displayValue;
  }
  final String? abbrDisplayValue = jsonConvert.convert<String>(json['abbrDisplayValue']);
  if (abbrDisplayValue != null) {
    moduleGroupMetricsReportDataRowsMetrics.abbrDisplayValue = abbrDisplayValue;
  }
  final String? abbrDisplayUnit = jsonConvert.convert<String>(json['abbrDisplayUnit']);
  if (abbrDisplayUnit != null) {
    moduleGroupMetricsReportDataRowsMetrics.abbrDisplayUnit = abbrDisplayUnit;
  }
  final ModuleMetricsCardCompValue? compValue = jsonConvert.convert<ModuleMetricsCardCompValue>(json['compValue']);
  if (compValue != null) {
    moduleGroupMetricsReportDataRowsMetrics.compValue = compValue;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    moduleGroupMetricsReportDataRowsMetrics.dataType = dataType;
  }
  final ModuleMetricsCardDrillDownInfo? drillDownInfo =
      jsonConvert.convert<ModuleMetricsCardDrillDownInfo>(json['drillDownInfo']);
  if (drillDownInfo != null) {
    moduleGroupMetricsReportDataRowsMetrics.drillDownInfo = drillDownInfo;
  }
  final double? proportion = jsonConvert.convert<double>(json['proportion']);
  if (proportion != null) {
    moduleGroupMetricsReportDataRowsMetrics.proportion = proportion;
  }
  final double? percent = jsonConvert.convert<double>(json['percent']);
  if (percent != null) {
    moduleGroupMetricsReportDataRowsMetrics.percent = percent;
  }
  final String? percentColor = jsonConvert.convert<String>(json['percentColor']);
  if (percentColor != null) {
    moduleGroupMetricsReportDataRowsMetrics.percentColor = percentColor;
  }
  return moduleGroupMetricsReportDataRowsMetrics;
}

Map<String, dynamic> $ModuleGroupMetricsReportDataRowsMetricsToJson(ModuleGroupMetricsReportDataRowsMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['name'] = entity.name;
  data['displayValue'] = entity.displayValue;
  data['abbrDisplayValue'] = entity.abbrDisplayValue;
  data['abbrDisplayUnit'] = entity.abbrDisplayUnit;
  data['compValue'] = entity.compValue?.toJson();
  data['dataType'] = entity.dataType?.name;
  data['drillDownInfo'] = entity.drillDownInfo?.toJson();
  data['proportion'] = entity.proportion;
  data['percent'] = entity.percent;
  data['percentColor'] = entity.percentColor;
  return data;
}

extension ModuleGroupMetricsReportDataRowsMetricsExtension on ModuleGroupMetricsReportDataRowsMetrics {
  ModuleGroupMetricsReportDataRowsMetrics copyWith({
    String? code,
    String? value,
    String? name,
    String? displayValue,
    String? abbrDisplayValue,
    String? abbrDisplayUnit,
    ModuleMetricsCardCompValue? compValue,
    MetricOrDimDataType? dataType,
    ModuleMetricsCardDrillDownInfo? drillDownInfo,
    double? proportion,
    double? percent,
    String? percentColor,
  }) {
    return ModuleGroupMetricsReportDataRowsMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..name = name ?? this.name
      ..displayValue = displayValue ?? this.displayValue
      ..abbrDisplayValue = abbrDisplayValue ?? this.abbrDisplayValue
      ..abbrDisplayUnit = abbrDisplayUnit ?? this.abbrDisplayUnit
      ..compValue = compValue ?? this.compValue
      ..dataType = dataType ?? this.dataType
      ..drillDownInfo = drillDownInfo ?? this.drillDownInfo
      ..proportion = proportion ?? this.proportion
      ..percent = percent ?? this.percent
      ..percentColor = percentColor ?? this.percentColor;
  }
}

ModuleGroupMetricsReportDataPage $ModuleGroupMetricsReportDataPageFromJson(Map<String, dynamic> json) {
  final ModuleGroupMetricsReportDataPage moduleGroupMetricsReportDataPage = ModuleGroupMetricsReportDataPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    moduleGroupMetricsReportDataPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    moduleGroupMetricsReportDataPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    moduleGroupMetricsReportDataPage.pageSize = pageSize;
  }
  final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
  if (pageCount != null) {
    moduleGroupMetricsReportDataPage.pageCount = pageCount;
  }
  return moduleGroupMetricsReportDataPage;
}

Map<String, dynamic> $ModuleGroupMetricsReportDataPageToJson(ModuleGroupMetricsReportDataPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  data['pageCount'] = entity.pageCount;
  return data;
}

extension ModuleGroupMetricsReportDataPageExtension on ModuleGroupMetricsReportDataPage {
  ModuleGroupMetricsReportDataPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
    int? pageCount,
  }) {
    return ModuleGroupMetricsReportDataPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize
      ..pageCount = pageCount ?? this.pageCount;
  }
}
