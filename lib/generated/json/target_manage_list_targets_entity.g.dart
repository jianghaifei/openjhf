import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/target_manage/target_manage_list_targets_entity.dart';

TargetManageListTargetsEntity $TargetManageListTargetsEntityFromJson(Map<String, dynamic> json) {
  final TargetManageListTargetsEntity targetManageListTargetsEntity = TargetManageListTargetsEntity();
  final List<TargetManageListTargetsInfos>? infos = (json['infos'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageListTargetsInfos>(e) as TargetManageListTargetsInfos)
      .toList();
  if (infos != null) {
    targetManageListTargetsEntity.infos = infos;
  }
  return targetManageListTargetsEntity;
}

Map<String, dynamic> $TargetManageListTargetsEntityToJson(TargetManageListTargetsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['infos'] = entity.infos?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageListTargetsEntityExtension on TargetManageListTargetsEntity {
  TargetManageListTargetsEntity copyWith({
    List<TargetManageListTargetsInfos>? infos,
  }) {
    return TargetManageListTargetsEntity()..infos = infos ?? this.infos;
  }
}

TargetManageListTargetsInfos $TargetManageListTargetsInfosFromJson(Map<String, dynamic> json) {
  final TargetManageListTargetsInfos targetManageListTargetsInfos = TargetManageListTargetsInfos();
  final String? targetId = jsonConvert.convert<String>(json['targetId']);
  if (targetId != null) {
    targetManageListTargetsInfos.targetId = targetId;
  }
  final String? month = jsonConvert.convert<String>(json['month']);
  if (month != null) {
    targetManageListTargetsInfos.month = month;
  }
  final String? displayMonth = jsonConvert.convert<String>(json['displayMonth']);
  if (displayMonth != null) {
    targetManageListTargetsInfos.displayMonth = displayMonth;
  }
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    targetManageListTargetsInfos.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    targetManageListTargetsInfos.metricName = metricName;
  }
  final String? target = jsonConvert.convert<String>(json['target']);
  if (target != null) {
    targetManageListTargetsInfos.target = target;
  }
  final String? displayTarget = jsonConvert.convert<String>(json['displayTarget']);
  if (displayTarget != null) {
    targetManageListTargetsInfos.displayTarget = displayTarget;
  }
  final TargetManageDistributionType? distributionType = jsonConvert.convert<TargetManageDistributionType>(
      json['distributionType'],
      enumConvert: (v) => TargetManageDistributionType.values.byName(v));
  if (distributionType != null) {
    targetManageListTargetsInfos.distributionType = distributionType;
  }
  final String? distributionName = jsonConvert.convert<String>(json['distributionName']);
  if (distributionName != null) {
    targetManageListTargetsInfos.distributionName = distributionName;
  }
  final List<String>? subTargets =
      (json['subTargets'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (subTargets != null) {
    targetManageListTargetsInfos.subTargets = subTargets;
  }
  final String? achievementRate = jsonConvert.convert<String>(json['achievementRate']);
  if (achievementRate != null) {
    targetManageListTargetsInfos.achievementRate = achievementRate;
  }
  final String? displayAchievementRate = jsonConvert.convert<String>(json['displayAchievementRate']);
  if (displayAchievementRate != null) {
    targetManageListTargetsInfos.displayAchievementRate = displayAchievementRate;
  }
  final int? shopCount = jsonConvert.convert<int>(json['shopCount']);
  if (shopCount != null) {
    targetManageListTargetsInfos.shopCount = shopCount;
  }
  final List<String>? shopIds =
      (json['shopIds'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (shopIds != null) {
    targetManageListTargetsInfos.shopIds = shopIds;
  }
  final String? displayShopCount = jsonConvert.convert<String>(json['displayShopCount']);
  if (displayShopCount != null) {
    targetManageListTargetsInfos.displayShopCount = displayShopCount;
  }
  final String? currency = jsonConvert.convert<String>(json['currency']);
  if (currency != null) {
    targetManageListTargetsInfos.currency = currency;
  }
  final String? currencySymbol = jsonConvert.convert<String>(json['currencySymbol']);
  if (currencySymbol != null) {
    targetManageListTargetsInfos.currencySymbol = currencySymbol;
  }
  return targetManageListTargetsInfos;
}

Map<String, dynamic> $TargetManageListTargetsInfosToJson(TargetManageListTargetsInfos entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['targetId'] = entity.targetId;
  data['month'] = entity.month;
  data['displayMonth'] = entity.displayMonth;
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['target'] = entity.target;
  data['displayTarget'] = entity.displayTarget;
  data['distributionType'] = entity.distributionType?.name;
  data['distributionName'] = entity.distributionName;
  data['subTargets'] = entity.subTargets;
  data['achievementRate'] = entity.achievementRate;
  data['displayAchievementRate'] = entity.displayAchievementRate;
  data['shopCount'] = entity.shopCount;
  data['shopIds'] = entity.shopIds;
  data['displayShopCount'] = entity.displayShopCount;
  data['currency'] = entity.currency;
  data['currencySymbol'] = entity.currencySymbol;
  return data;
}

extension TargetManageListTargetsInfosExtension on TargetManageListTargetsInfos {
  TargetManageListTargetsInfos copyWith({
    String? targetId,
    String? month,
    String? displayMonth,
    String? metricCode,
    String? metricName,
    String? target,
    String? displayTarget,
    TargetManageDistributionType? distributionType,
    String? distributionName,
    List<String>? subTargets,
    String? achievementRate,
    String? displayAchievementRate,
    int? shopCount,
    List<String>? shopIds,
    String? displayShopCount,
    String? currency,
    String? currencySymbol,
  }) {
    return TargetManageListTargetsInfos()
      ..targetId = targetId ?? this.targetId
      ..month = month ?? this.month
      ..displayMonth = displayMonth ?? this.displayMonth
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..target = target ?? this.target
      ..displayTarget = displayTarget ?? this.displayTarget
      ..distributionType = distributionType ?? this.distributionType
      ..distributionName = distributionName ?? this.distributionName
      ..subTargets = subTargets ?? this.subTargets
      ..achievementRate = achievementRate ?? this.achievementRate
      ..displayAchievementRate = displayAchievementRate ?? this.displayAchievementRate
      ..shopCount = shopCount ?? this.shopCount
      ..shopIds = shopIds ?? this.shopIds
      ..displayShopCount = displayShopCount ?? this.displayShopCount
      ..currency = currency ?? this.currency
      ..currencySymbol = currencySymbol ?? this.currencySymbol;
  }
}
