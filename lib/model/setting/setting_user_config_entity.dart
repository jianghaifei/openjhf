import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/setting_user_config_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class SettingUserConfigEntity {
  List<SettingUserConfig>? userConfig;

  SettingUserConfigEntity();

  factory SettingUserConfigEntity.fromJson(Map<String, dynamic> json) => $SettingUserConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $SettingUserConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SettingUserConfig {
  @JSONField(isEnum: true)
  SettingConfigEnum? configType;

  String? configTypeName;
  List<SettingUserConfigOptions>? configOptions;

  SettingUserConfig();

  factory SettingUserConfig.fromJson(Map<String, dynamic> json) => $SettingUserConfigFromJson(json);

  Map<String, dynamic> toJson() => $SettingUserConfigToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SettingUserConfigOptions {
  /// 配置值名称
  String? configName;

  /// 配置值
  String? configValue;

  /// 是否选中
  bool selected = false;

  /// 展示相关 title
  String? title;

  /// 展示相关 subTitle
  String? subTitle;

  /// 展示相关 图片链接
  String? imageLink;

  SettingUserConfigOptions();

  factory SettingUserConfigOptions.fromJson(Map<String, dynamic> json) => $SettingUserConfigOptionsFromJson(json);

  Map<String, dynamic> toJson() => $SettingUserConfigOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
