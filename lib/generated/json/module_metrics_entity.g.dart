import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';


ModuleMetricsEntity $ModuleMetricsEntityFromJson(Map<String, dynamic> json) {
  final ModuleMetricsEntity moduleMetricsEntity = ModuleMetricsEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleMetricsEntity.code = code;
  }
  final String? fieldName = jsonConvert.convert<String>(json['fieldName']);
  if (fieldName != null) {
    moduleMetricsEntity.fieldName = fieldName;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    moduleMetricsEntity.displayName = displayName;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(
      json['dataType'], enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    moduleMetricsEntity.dataType = dataType;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    moduleMetricsEntity.sort = sort;
  }
  final bool? isCore = jsonConvert.convert<bool>(json['isCore']);
  if (isCore != null) {
    moduleMetricsEntity.isCore = isCore;
  }
  final bool? defaultShowing = jsonConvert.convert<bool>(json['defaultShowing']);
  if (defaultShowing != null) {
    moduleMetricsEntity.defaultShowing = defaultShowing;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleMetricsEntity.value = value;
  }
  final num? percent = jsonConvert.convert<num>(json['percent']);
  if (percent != null) {
    moduleMetricsEntity.percent = percent;
  }
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    moduleMetricsEntity.entity = entity;
  }
  final String? entityTitle = jsonConvert.convert<String>(json['entityTitle']);
  if (entityTitle != null) {
    moduleMetricsEntity.entityTitle = entityTitle;
  }
  return moduleMetricsEntity;
}

Map<String, dynamic> $ModuleMetricsEntityToJson(ModuleMetricsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['fieldName'] = entity.fieldName;
  data['displayName'] = entity.displayName;
  data['dataType'] = entity.dataType?.name;
  data['sort'] = entity.sort;
  data['isCore'] = entity.isCore;
  data['defaultShowing'] = entity.defaultShowing;
  data['value'] = entity.value;
  data['percent'] = entity.percent;
  data['entity'] = entity.entity;
  data['entityTitle'] = entity.entityTitle;
  return data;
}

extension ModuleMetricsEntityExtension on ModuleMetricsEntity {
  ModuleMetricsEntity copyWith({
    String? code,
    String? fieldName,
    String? displayName,
    MetricOrDimDataType? dataType,
    int? sort,
    bool? isCore,
    bool? defaultShowing,
    String? value,
    num? percent,
    String? entity,
    String? entityTitle,
  }) {
    return ModuleMetricsEntity()
      ..code = code ?? this.code
      ..fieldName = fieldName ?? this.fieldName
      ..displayName = displayName ?? this.displayName
      ..dataType = dataType ?? this.dataType
      ..sort = sort ?? this.sort
      ..isCore = isCore ?? this.isCore
      ..defaultShowing = defaultShowing ?? this.defaultShowing
      ..value = value ?? this.value
      ..percent = percent ?? this.percent
      ..entity = entity ?? this.entity
      ..entityTitle = entityTitle ?? this.entityTitle;
  }
}