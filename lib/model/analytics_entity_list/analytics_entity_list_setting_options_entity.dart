import 'dart:convert';

import 'package:flutter_report_project/generated/json/analytics_entity_list_setting_options_entity.g.dart';
import 'package:flutter_report_project/generated/json/base/json_field.dart';

export 'package:flutter_report_project/generated/json/analytics_entity_list_setting_options_entity.g.dart';

@JsonSerializable()
class AnalyticsEntityListSettingOptionsEntity {
  List<AnalyticsEntityListSettingOptionsOptions>? options;

  AnalyticsEntityListSettingOptionsEntity();

  factory AnalyticsEntityListSettingOptionsEntity.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityListSettingOptionsEntityFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListSettingOptionsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AnalyticsEntityListSettingOptionsOptions {
  String? name;
  String? code;
  bool show = false;

  AnalyticsEntityListSettingOptionsOptions();

  factory AnalyticsEntityListSettingOptionsOptions.fromJson(Map<String, dynamic> json) =>
      $AnalyticsEntityListSettingOptionsOptionsFromJson(json);

  Map<String, dynamic> toJson() => $AnalyticsEntityListSettingOptionsOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
