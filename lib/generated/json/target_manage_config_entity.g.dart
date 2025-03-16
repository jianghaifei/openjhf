import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/target_manage/target_manage_config_entity.dart';

TargetManageConfigEntity $TargetManageConfigEntityFromJson(Map<String, dynamic> json) {
  final TargetManageConfigEntity targetManageConfigEntity = TargetManageConfigEntity();
  final TargetManageConfigTitleMsg? titleMsg = jsonConvert.convert<TargetManageConfigTitleMsg>(json['titleMsg']);
  if (titleMsg != null) {
    targetManageConfigEntity.titleMsg = titleMsg;
  }
  final TargetManageConfigFilterInfo? filterInfo =
      jsonConvert.convert<TargetManageConfigFilterInfo>(json['filterInfo']);
  if (filterInfo != null) {
    targetManageConfigEntity.filterInfo = filterInfo;
  }
  final List<TargetManageConfigMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageConfigMetrics>(e) as TargetManageConfigMetrics)
      .toList();
  if (metrics != null) {
    targetManageConfigEntity.metrics = metrics;
  }
  return targetManageConfigEntity;
}

Map<String, dynamic> $TargetManageConfigEntityToJson(TargetManageConfigEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['titleMsg'] = entity.titleMsg?.toJson();
  data['filterInfo'] = entity.filterInfo?.toJson();
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageConfigEntityExtension on TargetManageConfigEntity {
  TargetManageConfigEntity copyWith({
    TargetManageConfigTitleMsg? titleMsg,
    TargetManageConfigFilterInfo? filterInfo,
    List<TargetManageConfigMetrics>? metrics,
  }) {
    return TargetManageConfigEntity()
      ..titleMsg = titleMsg ?? this.titleMsg
      ..filterInfo = filterInfo ?? this.filterInfo
      ..metrics = metrics ?? this.metrics;
  }
}

TargetManageConfigTitleMsg $TargetManageConfigTitleMsgFromJson(Map<String, dynamic> json) {
  final TargetManageConfigTitleMsg targetManageConfigTitleMsg = TargetManageConfigTitleMsg();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageConfigTitleMsg.title = title;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    targetManageConfigTitleMsg.msg = msg;
  }
  return targetManageConfigTitleMsg;
}

Map<String, dynamic> $TargetManageConfigTitleMsgToJson(TargetManageConfigTitleMsg entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['msg'] = entity.msg;
  return data;
}

extension TargetManageConfigTitleMsgExtension on TargetManageConfigTitleMsg {
  TargetManageConfigTitleMsg copyWith({
    String? title,
    String? msg,
  }) {
    return TargetManageConfigTitleMsg()
      ..title = title ?? this.title
      ..msg = msg ?? this.msg;
  }
}

TargetManageConfigFilterInfo $TargetManageConfigFilterInfoFromJson(Map<String, dynamic> json) {
  final TargetManageConfigFilterInfo targetManageConfigFilterInfo = TargetManageConfigFilterInfo();
  final String? filterCode = jsonConvert.convert<String>(json['filterCode']);
  if (filterCode != null) {
    targetManageConfigFilterInfo.filterCode = filterCode;
  }
  final String? achievementFilterTitle = jsonConvert.convert<String>(json['achievementFilterTitle']);
  if (achievementFilterTitle != null) {
    targetManageConfigFilterInfo.achievementFilterTitle = achievementFilterTitle;
  }
  final List<TargetManageConfigFilterInfoAchievementFilter>? achievementFilter =
      (json['achievementFilter'] as List<dynamic>?)
          ?.map((e) => jsonConvert.convert<TargetManageConfigFilterInfoAchievementFilter>(e)
              as TargetManageConfigFilterInfoAchievementFilter)
          .toList();
  if (achievementFilter != null) {
    targetManageConfigFilterInfo.achievementFilter = achievementFilter;
  }
  return targetManageConfigFilterInfo;
}

Map<String, dynamic> $TargetManageConfigFilterInfoToJson(TargetManageConfigFilterInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['filterCode'] = entity.filterCode;
  data['achievementFilterTitle'] = entity.achievementFilterTitle;
  data['achievementFilter'] = entity.achievementFilter?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageConfigFilterInfoExtension on TargetManageConfigFilterInfo {
  TargetManageConfigFilterInfo copyWith({
    String? filterCode,
    String? achievementFilterTitle,
    List<TargetManageConfigFilterInfoAchievementFilter>? achievementFilter,
  }) {
    return TargetManageConfigFilterInfo()
      ..filterCode = filterCode ?? this.filterCode
      ..achievementFilterTitle = achievementFilterTitle ?? this.achievementFilterTitle
      ..achievementFilter = achievementFilter ?? this.achievementFilter;
  }
}

TargetManageConfigFilterInfoAchievementFilter $TargetManageConfigFilterInfoAchievementFilterFromJson(
    Map<String, dynamic> json) {
  final TargetManageConfigFilterInfoAchievementFilter targetManageConfigFilterInfoAchievementFilter =
      TargetManageConfigFilterInfoAchievementFilter();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageConfigFilterInfoAchievementFilter.name = name;
  }
  final List<TargetManageConfigFilterInfoAchievementFilterRule>? rule = (json['rule'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageConfigFilterInfoAchievementFilterRule>(e)
          as TargetManageConfigFilterInfoAchievementFilterRule)
      .toList();
  if (rule != null) {
    targetManageConfigFilterInfoAchievementFilter.rule = rule;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    targetManageConfigFilterInfoAchievementFilter.isSelected = isSelected;
  }
  return targetManageConfigFilterInfoAchievementFilter;
}

Map<String, dynamic> $TargetManageConfigFilterInfoAchievementFilterToJson(
    TargetManageConfigFilterInfoAchievementFilter entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['rule'] = entity.rule?.map((v) => v.toJson()).toList();
  data['isSelected'] = entity.isSelected;
  return data;
}

extension TargetManageConfigFilterInfoAchievementFilterExtension on TargetManageConfigFilterInfoAchievementFilter {
  TargetManageConfigFilterInfoAchievementFilter copyWith({
    String? name,
    List<TargetManageConfigFilterInfoAchievementFilterRule>? rule,
    bool? isSelected,
  }) {
    return TargetManageConfigFilterInfoAchievementFilter()
      ..name = name ?? this.name
      ..rule = rule ?? this.rule
      ..isSelected = isSelected ?? this.isSelected;
  }
}

TargetManageConfigFilterInfoAchievementFilterRule $TargetManageConfigFilterInfoAchievementFilterRuleFromJson(
    Map<String, dynamic> json) {
  final TargetManageConfigFilterInfoAchievementFilterRule targetManageConfigFilterInfoAchievementFilterRule =
      TargetManageConfigFilterInfoAchievementFilterRule();
  final EntityFilterType? filterType =
      jsonConvert.convert<EntityFilterType>(json['filterType'], enumConvert: (v) => EntityFilterType.values.byName(v));
  if (filterType != null) {
    targetManageConfigFilterInfoAchievementFilterRule.filterType = filterType;
  }
  final String? filterValue = jsonConvert.convert<String>(json['filterValue']);
  if (filterValue != null) {
    targetManageConfigFilterInfoAchievementFilterRule.filterValue = filterValue;
  }
  return targetManageConfigFilterInfoAchievementFilterRule;
}

Map<String, dynamic> $TargetManageConfigFilterInfoAchievementFilterRuleToJson(
    TargetManageConfigFilterInfoAchievementFilterRule entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['filterType'] = entity.filterType?.name;
  data['filterValue'] = entity.filterValue;
  return data;
}

extension TargetManageConfigFilterInfoAchievementFilterRuleExtension
    on TargetManageConfigFilterInfoAchievementFilterRule {
  TargetManageConfigFilterInfoAchievementFilterRule copyWith({
    EntityFilterType? filterType,
    String? filterValue,
  }) {
    return TargetManageConfigFilterInfoAchievementFilterRule()
      ..filterType = filterType ?? this.filterType
      ..filterValue = filterValue ?? this.filterValue;
  }
}

TargetManageConfigMetrics $TargetManageConfigMetricsFromJson(Map<String, dynamic> json) {
  final TargetManageConfigMetrics targetManageConfigMetrics = TargetManageConfigMetrics();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageConfigMetrics.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    targetManageConfigMetrics.code = code;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    targetManageConfigMetrics.dataType = dataType;
  }
  return targetManageConfigMetrics;
}

Map<String, dynamic> $TargetManageConfigMetricsToJson(TargetManageConfigMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['dataType'] = entity.dataType?.name;
  return data;
}

extension TargetManageConfigMetricsExtension on TargetManageConfigMetrics {
  TargetManageConfigMetrics copyWith({
    String? name,
    String? code,
    MetricOrDimDataType? dataType,
  }) {
    return TargetManageConfigMetrics()
      ..name = name ?? this.name
      ..code = code ?? this.code
      ..dataType = dataType ?? this.dataType;
  }
}
