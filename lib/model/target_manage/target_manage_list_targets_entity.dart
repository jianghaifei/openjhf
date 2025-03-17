import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/target_manage_list_targets_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class TargetManageListTargetsEntity {
  List<TargetManageListTargetsInfos>? infos;

  TargetManageListTargetsEntity();

  factory TargetManageListTargetsEntity.fromJson(Map<String, dynamic> json) =>
      $TargetManageListTargetsEntityFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageListTargetsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageListTargetsInfos {
  // 目标id
  String? targetId;

  // 月份实际值
  String? month;

  // 月份显示值
  String? displayMonth;

  // 指标code
  String? metricCode;

  // 指标展示名称
  String? metricName;

  // 目标实际值
  String? target;

  // 目标显示值
  String? displayTarget;

  // 分配方式枚举值
  @JSONField(isEnum: true)
  TargetManageDistributionType? distributionType;

  // 分配方式显示名称
  String? distributionName;

  // 目标实际值
  List<String>? subTargets;

  // 达成率实际值[0-1]
  String? achievementRate;

  // 达成率显示值
  String? displayAchievementRate;

  // 门店数实际值
  int? shopCount;

  // 门店id
  List<String>? shopIds;

  // 门店数显示值
  String? displayShopCount;

  // 货币
  String? currency;

  // 货币符号
  String? currencySymbol;

  TargetManageListTargetsInfos();

  factory TargetManageListTargetsInfos.fromJson(Map<String, dynamic> json) =>
      $TargetManageListTargetsInfosFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageListTargetsInfosToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
