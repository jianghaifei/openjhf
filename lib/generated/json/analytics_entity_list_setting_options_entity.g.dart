import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_list_setting_options_entity.dart';

AnalyticsEntityListSettingOptionsEntity $AnalyticsEntityListSettingOptionsEntityFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListSettingOptionsEntity analyticsEntityListSettingOptionsEntity =
      AnalyticsEntityListSettingOptionsEntity();
  final List<AnalyticsEntityListSettingOptionsOptions>? options = (json['options'] as List<dynamic>?)
      ?.map((e) =>
          jsonConvert.convert<AnalyticsEntityListSettingOptionsOptions>(e) as AnalyticsEntityListSettingOptionsOptions)
      .toList();
  if (options != null) {
    analyticsEntityListSettingOptionsEntity.options = options;
  }
  return analyticsEntityListSettingOptionsEntity;
}

Map<String, dynamic> $AnalyticsEntityListSettingOptionsEntityToJson(AnalyticsEntityListSettingOptionsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['options'] = entity.options?.map((v) => v.toJson()).toList();
  return data;
}

extension AnalyticsEntityListSettingOptionsEntityExtension on AnalyticsEntityListSettingOptionsEntity {
  AnalyticsEntityListSettingOptionsEntity copyWith({
    List<AnalyticsEntityListSettingOptionsOptions>? options,
  }) {
    return AnalyticsEntityListSettingOptionsEntity()..options = options ?? this.options;
  }
}

AnalyticsEntityListSettingOptionsOptions $AnalyticsEntityListSettingOptionsOptionsFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListSettingOptionsOptions analyticsEntityListSettingOptionsOptions =
      AnalyticsEntityListSettingOptionsOptions();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    analyticsEntityListSettingOptionsOptions.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    analyticsEntityListSettingOptionsOptions.code = code;
  }
  final bool? show = jsonConvert.convert<bool>(json['show']);
  if (show != null) {
    analyticsEntityListSettingOptionsOptions.show = show;
  }
  return analyticsEntityListSettingOptionsOptions;
}

Map<String, dynamic> $AnalyticsEntityListSettingOptionsOptionsToJson(AnalyticsEntityListSettingOptionsOptions entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['show'] = entity.show;
  return data;
}

extension AnalyticsEntityListSettingOptionsOptionsExtension on AnalyticsEntityListSettingOptionsOptions {
  AnalyticsEntityListSettingOptionsOptions copyWith({
    String? name,
    String? code,
    bool? show,
  }) {
    return AnalyticsEntityListSettingOptionsOptions()
      ..name = name ?? this.name
      ..code = code ?? this.code
      ..show = show ?? this.show;
  }
}
