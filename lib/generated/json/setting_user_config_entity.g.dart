import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/setting/setting_user_config_entity.dart';

SettingUserConfigEntity $SettingUserConfigEntityFromJson(Map<String, dynamic> json) {
  final SettingUserConfigEntity settingUserConfigEntity = SettingUserConfigEntity();
  final List<SettingUserConfig>? userConfig = (json['userConfig'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<SettingUserConfig>(e) as SettingUserConfig)
      .toList();
  if (userConfig != null) {
    settingUserConfigEntity.userConfig = userConfig;
  }
  return settingUserConfigEntity;
}

Map<String, dynamic> $SettingUserConfigEntityToJson(SettingUserConfigEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userConfig'] = entity.userConfig?.map((v) => v.toJson()).toList();
  return data;
}

extension SettingUserConfigEntityExtension on SettingUserConfigEntity {
  SettingUserConfigEntity copyWith({
    List<SettingUserConfig>? userConfig,
  }) {
    return SettingUserConfigEntity()..userConfig = userConfig ?? this.userConfig;
  }
}

SettingUserConfig $SettingUserConfigFromJson(Map<String, dynamic> json) {
  final SettingUserConfig settingUserConfig = SettingUserConfig();
  final SettingConfigEnum? configType = jsonConvert.convert<SettingConfigEnum>(json['configType'],
      enumConvert: (v) => SettingConfigEnum.values.byName(v));
  if (configType != null) {
    settingUserConfig.configType = configType;
  }
  final String? configTypeName = jsonConvert.convert<String>(json['configTypeName']);
  if (configTypeName != null) {
    settingUserConfig.configTypeName = configTypeName;
  }
  final List<SettingUserConfigOptions>? configOptions = (json['configOptions'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<SettingUserConfigOptions>(e) as SettingUserConfigOptions)
      .toList();
  if (configOptions != null) {
    settingUserConfig.configOptions = configOptions;
  }
  return settingUserConfig;
}

Map<String, dynamic> $SettingUserConfigToJson(SettingUserConfig entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['configType'] = entity.configType?.name;
  data['configTypeName'] = entity.configTypeName;
  data['configOptions'] = entity.configOptions?.map((v) => v.toJson()).toList();
  return data;
}

extension SettingUserConfigExtension on SettingUserConfig {
  SettingUserConfig copyWith({
    SettingConfigEnum? configType,
    String? configTypeName,
    List<SettingUserConfigOptions>? configOptions,
  }) {
    return SettingUserConfig()
      ..configType = configType ?? this.configType
      ..configTypeName = configTypeName ?? this.configTypeName
      ..configOptions = configOptions ?? this.configOptions;
  }
}

SettingUserConfigOptions $SettingUserConfigOptionsFromJson(Map<String, dynamic> json) {
  final SettingUserConfigOptions settingUserConfigOptions = SettingUserConfigOptions();
  final String? configName = jsonConvert.convert<String>(json['configName']);
  if (configName != null) {
    settingUserConfigOptions.configName = configName;
  }
  final String? configValue = jsonConvert.convert<String>(json['configValue']);
  if (configValue != null) {
    settingUserConfigOptions.configValue = configValue;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    settingUserConfigOptions.selected = selected;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    settingUserConfigOptions.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['subTitle']);
  if (subTitle != null) {
    settingUserConfigOptions.subTitle = subTitle;
  }
  final String? imageLink = jsonConvert.convert<String>(json['imageLink']);
  if (imageLink != null) {
    settingUserConfigOptions.imageLink = imageLink;
  }
  return settingUserConfigOptions;
}

Map<String, dynamic> $SettingUserConfigOptionsToJson(SettingUserConfigOptions entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['configName'] = entity.configName;
  data['configValue'] = entity.configValue;
  data['selected'] = entity.selected;
  data['title'] = entity.title;
  data['subTitle'] = entity.subTitle;
  data['imageLink'] = entity.imageLink;
  return data;
}

extension SettingUserConfigOptionsExtension on SettingUserConfigOptions {
  SettingUserConfigOptions copyWith({
    String? configName,
    String? configValue,
    bool? selected,
    String? title,
    String? subTitle,
    String? imageLink,
  }) {
    return SettingUserConfigOptions()
      ..configName = configName ?? this.configName
      ..configValue = configValue ?? this.configValue
      ..selected = selected ?? this.selected
      ..title = title ?? this.title
      ..subTitle = subTitle ?? this.subTitle
      ..imageLink = imageLink ?? this.imageLink;
  }
}
