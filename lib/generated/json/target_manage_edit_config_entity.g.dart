import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/target_manage/target_manage_edit_config_entity.dart';

TargetManageEditConfigEntity $TargetManageEditConfigEntityFromJson(Map<String, dynamic> json) {
  final TargetManageEditConfigEntity targetManageEditConfigEntity = TargetManageEditConfigEntity();
  final List<TargetManageEditConfigMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageEditConfigMetrics>(e) as TargetManageEditConfigMetrics)
      .toList();
  if (metrics != null) {
    targetManageEditConfigEntity.metrics = metrics;
  }
  return targetManageEditConfigEntity;
}

Map<String, dynamic> $TargetManageEditConfigEntityToJson(TargetManageEditConfigEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageEditConfigEntityExtension on TargetManageEditConfigEntity {
  TargetManageEditConfigEntity copyWith({
    List<TargetManageEditConfigMetrics>? metrics,
  }) {
    return TargetManageEditConfigEntity()..metrics = metrics ?? this.metrics;
  }
}

TargetManageEditConfigMetrics $TargetManageEditConfigMetricsFromJson(Map<String, dynamic> json) {
  final TargetManageEditConfigMetrics targetManageEditConfigMetrics = TargetManageEditConfigMetrics();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageEditConfigMetrics.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    targetManageEditConfigMetrics.code = code;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    targetManageEditConfigMetrics.dataType = dataType;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    targetManageEditConfigMetrics.isSelected = isSelected;
  }
  return targetManageEditConfigMetrics;
}

Map<String, dynamic> $TargetManageEditConfigMetricsToJson(TargetManageEditConfigMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['dataType'] = entity.dataType?.name;
  data['isSelected'] = entity.isSelected;
  return data;
}

extension TargetManageEditConfigMetricsExtension on TargetManageEditConfigMetrics {
  TargetManageEditConfigMetrics copyWith({
    String? name,
    String? code,
    MetricOrDimDataType? dataType,
    bool? isSelected,
  }) {
    return TargetManageEditConfigMetrics()
      ..name = name ?? this.name
      ..code = code ?? this.code
      ..dataType = dataType ?? this.dataType
      ..isSelected = isSelected ?? this.isSelected;
  }
}
