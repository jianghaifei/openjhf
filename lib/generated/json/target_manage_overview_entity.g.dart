import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/store/store_pk/store_pk_table_entity.dart';
import 'package:flutter_report_project/model/target_manage/target_manage_overview_entity.dart';

TargetManageOverviewEntity $TargetManageOverviewEntityFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewEntity targetManageOverviewEntity = TargetManageOverviewEntity();
  final TargetManageOverviewUnSetShopInfo? unSetShopInfo =
      jsonConvert.convert<TargetManageOverviewUnSetShopInfo>(json['unSetShopInfo']);
  if (unSetShopInfo != null) {
    targetManageOverviewEntity.unSetShopInfo = unSetShopInfo;
  }
  final TargetManageOverviewSummary? summary = jsonConvert.convert<TargetManageOverviewSummary>(json['summary']);
  if (summary != null) {
    targetManageOverviewEntity.summary = summary;
  }
  final TargetManageOverviewOverall? overall = jsonConvert.convert<TargetManageOverviewOverall>(json['overall']);
  if (overall != null) {
    targetManageOverviewEntity.overall = overall;
  }
  final TargetManageOverviewShopAchievement? shopAchievement =
      jsonConvert.convert<TargetManageOverviewShopAchievement>(json['shopAchievement']);
  if (shopAchievement != null) {
    targetManageOverviewEntity.shopAchievement = shopAchievement;
  }
  final TargetManageOverviewShopAchievementDetail? shopAchievementDetail =
      jsonConvert.convert<TargetManageOverviewShopAchievementDetail>(json['shopAchievementDetail']);
  if (shopAchievementDetail != null) {
    targetManageOverviewEntity.shopAchievementDetail = shopAchievementDetail;
  }
  final TargetManageOverviewCumulativeTrend? cumulativeTrend =
      jsonConvert.convert<TargetManageOverviewCumulativeTrend>(json['cumulativeTrend']);
  if (cumulativeTrend != null) {
    targetManageOverviewEntity.cumulativeTrend = cumulativeTrend;
  }
  final TargetManageOverviewDailyTrend? dailyTrend =
      jsonConvert.convert<TargetManageOverviewDailyTrend>(json['dailyTrend']);
  if (dailyTrend != null) {
    targetManageOverviewEntity.dailyTrend = dailyTrend;
  }
  return targetManageOverviewEntity;
}

Map<String, dynamic> $TargetManageOverviewEntityToJson(TargetManageOverviewEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unSetShopInfo'] = entity.unSetShopInfo?.toJson();
  data['summary'] = entity.summary?.toJson();
  data['overall'] = entity.overall?.toJson();
  data['shopAchievement'] = entity.shopAchievement?.toJson();
  data['shopAchievementDetail'] = entity.shopAchievementDetail?.toJson();
  data['cumulativeTrend'] = entity.cumulativeTrend?.toJson();
  data['dailyTrend'] = entity.dailyTrend?.toJson();
  return data;
}

extension TargetManageOverviewEntityExtension on TargetManageOverviewEntity {
  TargetManageOverviewEntity copyWith({
    TargetManageOverviewUnSetShopInfo? unSetShopInfo,
    TargetManageOverviewSummary? summary,
    TargetManageOverviewOverall? overall,
    TargetManageOverviewShopAchievement? shopAchievement,
    TargetManageOverviewShopAchievementDetail? shopAchievementDetail,
    TargetManageOverviewCumulativeTrend? cumulativeTrend,
    TargetManageOverviewDailyTrend? dailyTrend,
  }) {
    return TargetManageOverviewEntity()
      ..unSetShopInfo = unSetShopInfo ?? this.unSetShopInfo
      ..summary = summary ?? this.summary
      ..overall = overall ?? this.overall
      ..shopAchievement = shopAchievement ?? this.shopAchievement
      ..shopAchievementDetail = shopAchievementDetail ?? this.shopAchievementDetail
      ..cumulativeTrend = cumulativeTrend ?? this.cumulativeTrend
      ..dailyTrend = dailyTrend ?? this.dailyTrend;
  }
}

TargetManageOverviewUnSetShopInfo $TargetManageOverviewUnSetShopInfoFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewUnSetShopInfo targetManageOverviewUnSetShopInfo = TargetManageOverviewUnSetShopInfo();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    targetManageOverviewUnSetShopInfo.msg = msg;
  }
  final List<TargetManageOverviewUnSetShopInfoShopInfos>? shopInfos = (json['shopInfos'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewUnSetShopInfoShopInfos>(e)
          as TargetManageOverviewUnSetShopInfoShopInfos)
      .toList();
  if (shopInfos != null) {
    targetManageOverviewUnSetShopInfo.shopInfos = shopInfos;
  }
  return targetManageOverviewUnSetShopInfo;
}

Map<String, dynamic> $TargetManageOverviewUnSetShopInfoToJson(TargetManageOverviewUnSetShopInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['shopInfos'] = entity.shopInfos?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageOverviewUnSetShopInfoExtension on TargetManageOverviewUnSetShopInfo {
  TargetManageOverviewUnSetShopInfo copyWith({
    String? msg,
    List<TargetManageOverviewUnSetShopInfoShopInfos>? shopInfos,
  }) {
    return TargetManageOverviewUnSetShopInfo()
      ..msg = msg ?? this.msg
      ..shopInfos = shopInfos ?? this.shopInfos;
  }
}

TargetManageOverviewUnSetShopInfoShopInfos $TargetManageOverviewUnSetShopInfoShopInfosFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewUnSetShopInfoShopInfos targetManageOverviewUnSetShopInfoShopInfos =
      TargetManageOverviewUnSetShopInfoShopInfos();
  final String? shopId = jsonConvert.convert<String>(json['shopId']);
  if (shopId != null) {
    targetManageOverviewUnSetShopInfoShopInfos.shopId = shopId;
  }
  final String? shopName = jsonConvert.convert<String>(json['shopName']);
  if (shopName != null) {
    targetManageOverviewUnSetShopInfoShopInfos.shopName = shopName;
  }
  return targetManageOverviewUnSetShopInfoShopInfos;
}

Map<String, dynamic> $TargetManageOverviewUnSetShopInfoShopInfosToJson(
    TargetManageOverviewUnSetShopInfoShopInfos entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopId'] = entity.shopId;
  data['shopName'] = entity.shopName;
  return data;
}

extension TargetManageOverviewUnSetShopInfoShopInfosExtension on TargetManageOverviewUnSetShopInfoShopInfos {
  TargetManageOverviewUnSetShopInfoShopInfos copyWith({
    String? shopId,
    String? shopName,
  }) {
    return TargetManageOverviewUnSetShopInfoShopInfos()
      ..shopId = shopId ?? this.shopId
      ..shopName = shopName ?? this.shopName;
  }
}

TargetManageOverviewSummary $TargetManageOverviewSummaryFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewSummary targetManageOverviewSummary = TargetManageOverviewSummary();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewSummary.title = title;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    targetManageOverviewSummary.msg = msg;
  }
  final bool? drillDown = jsonConvert.convert<bool>(json['drillDown']);
  if (drillDown != null) {
    targetManageOverviewSummary.drillDown = drillDown;
  }
  return targetManageOverviewSummary;
}

Map<String, dynamic> $TargetManageOverviewSummaryToJson(TargetManageOverviewSummary entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['msg'] = entity.msg;
  data['drillDown'] = entity.drillDown;
  return data;
}

extension TargetManageOverviewSummaryExtension on TargetManageOverviewSummary {
  TargetManageOverviewSummary copyWith({
    String? title,
    String? msg,
    bool? drillDown,
  }) {
    return TargetManageOverviewSummary()
      ..title = title ?? this.title
      ..msg = msg ?? this.msg
      ..drillDown = drillDown ?? this.drillDown;
  }
}

TargetManageOverviewOverall $TargetManageOverviewOverallFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewOverall targetManageOverviewOverall = TargetManageOverviewOverall();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewOverall.title = title;
  }
  final TargetManageOverviewOverallAchievementRate? achievementRate =
      jsonConvert.convert<TargetManageOverviewOverallAchievementRate>(json['achievementRate']);
  if (achievementRate != null) {
    targetManageOverviewOverall.achievementRate = achievementRate;
  }
  final TargetManageOverviewOverallTarget? target =
      jsonConvert.convert<TargetManageOverviewOverallTarget>(json['target']);
  if (target != null) {
    targetManageOverviewOverall.target = target;
  }
  final TargetManageOverviewOverallAchieved? achieved =
      jsonConvert.convert<TargetManageOverviewOverallAchieved>(json['achieved']);
  if (achieved != null) {
    targetManageOverviewOverall.achieved = achieved;
  }
  final TargetManageOverviewOverallNotAchieved? notAchieved =
      jsonConvert.convert<TargetManageOverviewOverallNotAchieved>(json['notAchieved']);
  if (notAchieved != null) {
    targetManageOverviewOverall.notAchieved = notAchieved;
  }
  return targetManageOverviewOverall;
}

Map<String, dynamic> $TargetManageOverviewOverallToJson(TargetManageOverviewOverall entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['achievementRate'] = entity.achievementRate?.toJson();
  data['target'] = entity.target?.toJson();
  data['achieved'] = entity.achieved?.toJson();
  data['notAchieved'] = entity.notAchieved?.toJson();
  return data;
}

extension TargetManageOverviewOverallExtension on TargetManageOverviewOverall {
  TargetManageOverviewOverall copyWith({
    String? title,
    TargetManageOverviewOverallAchievementRate? achievementRate,
    TargetManageOverviewOverallTarget? target,
    TargetManageOverviewOverallAchieved? achieved,
    TargetManageOverviewOverallNotAchieved? notAchieved,
  }) {
    return TargetManageOverviewOverall()
      ..title = title ?? this.title
      ..achievementRate = achievementRate ?? this.achievementRate
      ..target = target ?? this.target
      ..achieved = achieved ?? this.achieved
      ..notAchieved = notAchieved ?? this.notAchieved;
  }
}

TargetManageOverviewOverallAchievementRate $TargetManageOverviewOverallAchievementRateFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewOverallAchievementRate targetManageOverviewOverallAchievementRate =
      TargetManageOverviewOverallAchievementRate();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewOverallAchievementRate.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewOverallAchievementRate.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewOverallAchievementRate.displayValue = displayValue;
  }
  return targetManageOverviewOverallAchievementRate;
}

Map<String, dynamic> $TargetManageOverviewOverallAchievementRateToJson(
    TargetManageOverviewOverallAchievementRate entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewOverallAchievementRateExtension on TargetManageOverviewOverallAchievementRate {
  TargetManageOverviewOverallAchievementRate copyWith({
    String? name,
    String? value,
    String? displayValue,
  }) {
    return TargetManageOverviewOverallAchievementRate()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewOverallTarget $TargetManageOverviewOverallTargetFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewOverallTarget targetManageOverviewOverallTarget = TargetManageOverviewOverallTarget();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewOverallTarget.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewOverallTarget.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewOverallTarget.displayValue = displayValue;
  }
  return targetManageOverviewOverallTarget;
}

Map<String, dynamic> $TargetManageOverviewOverallTargetToJson(TargetManageOverviewOverallTarget entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewOverallTargetExtension on TargetManageOverviewOverallTarget {
  TargetManageOverviewOverallTarget copyWith({
    String? name,
    String? value,
    String? displayValue,
  }) {
    return TargetManageOverviewOverallTarget()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewOverallAchieved $TargetManageOverviewOverallAchievedFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewOverallAchieved targetManageOverviewOverallAchieved = TargetManageOverviewOverallAchieved();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewOverallAchieved.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewOverallAchieved.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewOverallAchieved.displayValue = displayValue;
  }
  return targetManageOverviewOverallAchieved;
}

Map<String, dynamic> $TargetManageOverviewOverallAchievedToJson(TargetManageOverviewOverallAchieved entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewOverallAchievedExtension on TargetManageOverviewOverallAchieved {
  TargetManageOverviewOverallAchieved copyWith({
    String? name,
    String? value,
    String? displayValue,
  }) {
    return TargetManageOverviewOverallAchieved()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewOverallNotAchieved $TargetManageOverviewOverallNotAchievedFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewOverallNotAchieved targetManageOverviewOverallNotAchieved =
      TargetManageOverviewOverallNotAchieved();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewOverallNotAchieved.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewOverallNotAchieved.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewOverallNotAchieved.displayValue = displayValue;
  }
  return targetManageOverviewOverallNotAchieved;
}

Map<String, dynamic> $TargetManageOverviewOverallNotAchievedToJson(TargetManageOverviewOverallNotAchieved entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewOverallNotAchievedExtension on TargetManageOverviewOverallNotAchieved {
  TargetManageOverviewOverallNotAchieved copyWith({
    String? name,
    String? value,
    String? displayValue,
  }) {
    return TargetManageOverviewOverallNotAchieved()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewShopAchievement $TargetManageOverviewShopAchievementFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievement targetManageOverviewShopAchievement = TargetManageOverviewShopAchievement();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewShopAchievement.title = title;
  }
  final List<TargetManageOverviewShopAchievementMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewShopAchievementMetrics>(e)
          as TargetManageOverviewShopAchievementMetrics)
      .toList();
  if (metrics != null) {
    targetManageOverviewShopAchievement.metrics = metrics;
  }
  final TargetManageOverviewShopAchievementReportData? reportData =
      jsonConvert.convert<TargetManageOverviewShopAchievementReportData>(json['reportData']);
  if (reportData != null) {
    targetManageOverviewShopAchievement.reportData = reportData;
  }
  return targetManageOverviewShopAchievement;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementToJson(TargetManageOverviewShopAchievement entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['reportData'] = entity.reportData?.toJson();
  return data;
}

extension TargetManageOverviewShopAchievementExtension on TargetManageOverviewShopAchievement {
  TargetManageOverviewShopAchievement copyWith({
    String? title,
    List<TargetManageOverviewShopAchievementMetrics>? metrics,
    TargetManageOverviewShopAchievementReportData? reportData,
  }) {
    return TargetManageOverviewShopAchievement()
      ..title = title ?? this.title
      ..metrics = metrics ?? this.metrics
      ..reportData = reportData ?? this.reportData;
  }
}

TargetManageOverviewShopAchievementMetrics $TargetManageOverviewShopAchievementMetricsFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementMetrics targetManageOverviewShopAchievementMetrics =
      TargetManageOverviewShopAchievementMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    targetManageOverviewShopAchievementMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewShopAchievementMetrics.value = value;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewShopAchievementMetrics.name = name;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewShopAchievementMetrics.displayValue = displayValue;
  }
  return targetManageOverviewShopAchievementMetrics;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementMetricsToJson(
    TargetManageOverviewShopAchievementMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['name'] = entity.name;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewShopAchievementMetricsExtension on TargetManageOverviewShopAchievementMetrics {
  TargetManageOverviewShopAchievementMetrics copyWith({
    String? code,
    String? value,
    String? name,
    String? displayValue,
  }) {
    return TargetManageOverviewShopAchievementMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..name = name ?? this.name
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewShopAchievementReportData $TargetManageOverviewShopAchievementReportDataFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementReportData targetManageOverviewShopAchievementReportData =
      TargetManageOverviewShopAchievementReportData();
  final List<TargetManageOverviewShopAchievementReportDataRows>? rows = (json['rows'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewShopAchievementReportDataRows>(e)
          as TargetManageOverviewShopAchievementReportDataRows)
      .toList();
  if (rows != null) {
    targetManageOverviewShopAchievementReportData.rows = rows;
  }
  return targetManageOverviewShopAchievementReportData;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementReportDataToJson(
    TargetManageOverviewShopAchievementReportData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageOverviewShopAchievementReportDataExtension on TargetManageOverviewShopAchievementReportData {
  TargetManageOverviewShopAchievementReportData copyWith({
    List<TargetManageOverviewShopAchievementReportDataRows>? rows,
  }) {
    return TargetManageOverviewShopAchievementReportData()..rows = rows ?? this.rows;
  }
}

TargetManageOverviewShopAchievementReportDataRows $TargetManageOverviewShopAchievementReportDataRowsFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementReportDataRows targetManageOverviewShopAchievementReportDataRows =
      TargetManageOverviewShopAchievementReportDataRows();
  final List<TargetManageOverviewShopAchievementReportDataRowsDims>? dims = (json['dims'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewShopAchievementReportDataRowsDims>(e)
          as TargetManageOverviewShopAchievementReportDataRowsDims)
      .toList();
  if (dims != null) {
    targetManageOverviewShopAchievementReportDataRows.dims = dims;
  }
  final List<TargetManageOverviewShopAchievementReportDataRowsMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewShopAchievementReportDataRowsMetrics>(e)
          as TargetManageOverviewShopAchievementReportDataRowsMetrics)
      .toList();
  if (metrics != null) {
    targetManageOverviewShopAchievementReportDataRows.metrics = metrics;
  }
  return targetManageOverviewShopAchievementReportDataRows;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementReportDataRowsToJson(
    TargetManageOverviewShopAchievementReportDataRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageOverviewShopAchievementReportDataRowsExtension
    on TargetManageOverviewShopAchievementReportDataRows {
  TargetManageOverviewShopAchievementReportDataRows copyWith({
    List<TargetManageOverviewShopAchievementReportDataRowsDims>? dims,
    List<TargetManageOverviewShopAchievementReportDataRowsMetrics>? metrics,
  }) {
    return TargetManageOverviewShopAchievementReportDataRows()
      ..dims = dims ?? this.dims
      ..metrics = metrics ?? this.metrics;
  }
}

TargetManageOverviewShopAchievementReportDataRowsDims $TargetManageOverviewShopAchievementReportDataRowsDimsFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementReportDataRowsDims targetManageOverviewShopAchievementReportDataRowsDims =
      TargetManageOverviewShopAchievementReportDataRowsDims();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    targetManageOverviewShopAchievementReportDataRowsDims.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewShopAchievementReportDataRowsDims.value = value;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewShopAchievementReportDataRowsDims.name = name;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewShopAchievementReportDataRowsDims.displayValue = displayValue;
  }
  return targetManageOverviewShopAchievementReportDataRowsDims;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementReportDataRowsDimsToJson(
    TargetManageOverviewShopAchievementReportDataRowsDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['name'] = entity.name;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension TargetManageOverviewShopAchievementReportDataRowsDimsExtension
    on TargetManageOverviewShopAchievementReportDataRowsDims {
  TargetManageOverviewShopAchievementReportDataRowsDims copyWith({
    String? code,
    String? value,
    String? name,
    String? displayValue,
  }) {
    return TargetManageOverviewShopAchievementReportDataRowsDims()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..name = name ?? this.name
      ..displayValue = displayValue ?? this.displayValue;
  }
}

TargetManageOverviewShopAchievementReportDataRowsMetrics
    $TargetManageOverviewShopAchievementReportDataRowsMetricsFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementReportDataRowsMetrics
      targetManageOverviewShopAchievementReportDataRowsMetrics =
      TargetManageOverviewShopAchievementReportDataRowsMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    targetManageOverviewShopAchievementReportDataRowsMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    targetManageOverviewShopAchievementReportDataRowsMetrics.value = value;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    targetManageOverviewShopAchievementReportDataRowsMetrics.name = name;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    targetManageOverviewShopAchievementReportDataRowsMetrics.displayValue = displayValue;
  }
  final double? proportion = jsonConvert.convert<double>(json['proportion']);
  if (proportion != null) {
    targetManageOverviewShopAchievementReportDataRowsMetrics.proportion = proportion;
  }
  return targetManageOverviewShopAchievementReportDataRowsMetrics;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementReportDataRowsMetricsToJson(
    TargetManageOverviewShopAchievementReportDataRowsMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['name'] = entity.name;
  data['displayValue'] = entity.displayValue;
  data['proportion'] = entity.proportion;
  return data;
}

extension TargetManageOverviewShopAchievementReportDataRowsMetricsExtension
    on TargetManageOverviewShopAchievementReportDataRowsMetrics {
  TargetManageOverviewShopAchievementReportDataRowsMetrics copyWith({
    String? code,
    String? value,
    String? name,
    String? displayValue,
    double? proportion,
  }) {
    return TargetManageOverviewShopAchievementReportDataRowsMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..name = name ?? this.name
      ..displayValue = displayValue ?? this.displayValue
      ..proportion = proportion ?? this.proportion;
  }
}

TargetManageOverviewShopAchievementDetail $TargetManageOverviewShopAchievementDetailFromJson(
    Map<String, dynamic> json) {
  final TargetManageOverviewShopAchievementDetail targetManageOverviewShopAchievementDetail =
      TargetManageOverviewShopAchievementDetail();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewShopAchievementDetail.title = title;
  }
  final StorePKTableEntityTable? table = jsonConvert.convert<StorePKTableEntityTable>(json['table']);
  if (table != null) {
    targetManageOverviewShopAchievementDetail.table = table;
  }
  return targetManageOverviewShopAchievementDetail;
}

Map<String, dynamic> $TargetManageOverviewShopAchievementDetailToJson(
    TargetManageOverviewShopAchievementDetail entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['table'] = entity.table?.toJson();
  return data;
}

extension TargetManageOverviewShopAchievementDetailExtension on TargetManageOverviewShopAchievementDetail {
  TargetManageOverviewShopAchievementDetail copyWith({
    String? title,
    StorePKTableEntityTable? table,
  }) {
    return TargetManageOverviewShopAchievementDetail()
      ..title = title ?? this.title
      ..table = table ?? this.table;
  }
}

TargetManageOverviewCumulativeTrend $TargetManageOverviewCumulativeTrendFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewCumulativeTrend targetManageOverviewCumulativeTrend = TargetManageOverviewCumulativeTrend();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewCumulativeTrend.title = title;
  }
  final List<TargetManageOverviewChart>? chart = (json['chart'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewChart>(e) as TargetManageOverviewChart)
      .toList();
  if (chart != null) {
    targetManageOverviewCumulativeTrend.chart = chart;
  }
  return targetManageOverviewCumulativeTrend;
}

Map<String, dynamic> $TargetManageOverviewCumulativeTrendToJson(TargetManageOverviewCumulativeTrend entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['chart'] = entity.chart?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageOverviewCumulativeTrendExtension on TargetManageOverviewCumulativeTrend {
  TargetManageOverviewCumulativeTrend copyWith({
    String? title,
    List<TargetManageOverviewChart>? chart,
  }) {
    return TargetManageOverviewCumulativeTrend()
      ..title = title ?? this.title
      ..chart = chart ?? this.chart;
  }
}

TargetManageOverviewChart $TargetManageOverviewChartFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewChart targetManageOverviewChart = TargetManageOverviewChart();
  final List<TargetManageOverviewChartAxisY>? axisY = (json['axisY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewChartAxisY>(e) as TargetManageOverviewChartAxisY)
      .toList();
  if (axisY != null) {
    targetManageOverviewChart.axisY = axisY;
  }
  final List<TargetManageOverviewChartAxisCompY>? axisCompY = (json['axisCompY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewChartAxisCompY>(e) as TargetManageOverviewChartAxisCompY)
      .toList();
  if (axisCompY != null) {
    targetManageOverviewChart.axisCompY = axisCompY;
  }
  final TargetManageOverviewChartAxisX? axisX = jsonConvert.convert<TargetManageOverviewChartAxisX>(json['axisX']);
  if (axisX != null) {
    targetManageOverviewChart.axisX = axisX;
  }
  return targetManageOverviewChart;
}

Map<String, dynamic> $TargetManageOverviewChartToJson(TargetManageOverviewChart entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['axisY'] = entity.axisY?.map((v) => v.toJson()).toList();
  data['axisCompY'] = entity.axisCompY?.map((v) => v.toJson()).toList();
  data['axisX'] = entity.axisX?.toJson();
  return data;
}

extension TargetManageOverviewChartExtension on TargetManageOverviewChart {
  TargetManageOverviewChart copyWith({
    List<TargetManageOverviewChartAxisY>? axisY,
    List<TargetManageOverviewChartAxisCompY>? axisCompY,
    TargetManageOverviewChartAxisX? axisX,
  }) {
    return TargetManageOverviewChart()
      ..axisY = axisY ?? this.axisY
      ..axisCompY = axisCompY ?? this.axisCompY
      ..axisX = axisX ?? this.axisX;
  }
}

TargetManageOverviewChartAxisY $TargetManageOverviewChartAxisYFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewChartAxisY targetManageOverviewChartAxisY = TargetManageOverviewChartAxisY();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    targetManageOverviewChartAxisY.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    targetManageOverviewChartAxisY.metricName = metricName;
  }
  final String? metricValue = jsonConvert.convert<String>(json['metricValue']);
  if (metricValue != null) {
    targetManageOverviewChartAxisY.metricValue = metricValue;
  }
  final String? metricDisplayValue = jsonConvert.convert<String>(json['metricDisplayValue']);
  if (metricDisplayValue != null) {
    targetManageOverviewChartAxisY.metricDisplayValue = metricDisplayValue;
  }
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    targetManageOverviewChartAxisY.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    targetManageOverviewChartAxisY.dimName = dimName;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    targetManageOverviewChartAxisY.dimValue = dimValue;
  }
  final String? dimDisplayValue = jsonConvert.convert<String>(json['dimDisplayValue']);
  if (dimDisplayValue != null) {
    targetManageOverviewChartAxisY.dimDisplayValue = dimDisplayValue;
  }
  return targetManageOverviewChartAxisY;
}

Map<String, dynamic> $TargetManageOverviewChartAxisYToJson(TargetManageOverviewChartAxisY entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['metricValue'] = entity.metricValue;
  data['metricDisplayValue'] = entity.metricDisplayValue;
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['dimValue'] = entity.dimValue;
  data['dimDisplayValue'] = entity.dimDisplayValue;
  return data;
}

extension TargetManageOverviewChartAxisYExtension on TargetManageOverviewChartAxisY {
  TargetManageOverviewChartAxisY copyWith({
    String? metricCode,
    String? metricName,
    String? metricValue,
    String? metricDisplayValue,
    String? dimCode,
    String? dimName,
    String? dimValue,
    String? dimDisplayValue,
  }) {
    return TargetManageOverviewChartAxisY()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..metricValue = metricValue ?? this.metricValue
      ..metricDisplayValue = metricDisplayValue ?? this.metricDisplayValue
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..dimValue = dimValue ?? this.dimValue
      ..dimDisplayValue = dimDisplayValue ?? this.dimDisplayValue;
  }
}

TargetManageOverviewChartAxisCompY $TargetManageOverviewChartAxisCompYFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewChartAxisCompY targetManageOverviewChartAxisCompY = TargetManageOverviewChartAxisCompY();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    targetManageOverviewChartAxisCompY.metricCode = metricCode;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    targetManageOverviewChartAxisCompY.metricName = metricName;
  }
  final String? metricValue = jsonConvert.convert<String>(json['metricValue']);
  if (metricValue != null) {
    targetManageOverviewChartAxisCompY.metricValue = metricValue;
  }
  final String? metricDisplayValue = jsonConvert.convert<String>(json['metricDisplayValue']);
  if (metricDisplayValue != null) {
    targetManageOverviewChartAxisCompY.metricDisplayValue = metricDisplayValue;
  }
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    targetManageOverviewChartAxisCompY.dimCode = dimCode;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    targetManageOverviewChartAxisCompY.dimName = dimName;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    targetManageOverviewChartAxisCompY.dimValue = dimValue;
  }
  final String? dimDisplayValue = jsonConvert.convert<String>(json['dimDisplayValue']);
  if (dimDisplayValue != null) {
    targetManageOverviewChartAxisCompY.dimDisplayValue = dimDisplayValue;
  }
  return targetManageOverviewChartAxisCompY;
}

Map<String, dynamic> $TargetManageOverviewChartAxisCompYToJson(TargetManageOverviewChartAxisCompY entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricName'] = entity.metricName;
  data['metricValue'] = entity.metricValue;
  data['metricDisplayValue'] = entity.metricDisplayValue;
  data['dimCode'] = entity.dimCode;
  data['dimName'] = entity.dimName;
  data['dimValue'] = entity.dimValue;
  data['dimDisplayValue'] = entity.dimDisplayValue;
  return data;
}

extension TargetManageOverviewChartAxisCompYExtension on TargetManageOverviewChartAxisCompY {
  TargetManageOverviewChartAxisCompY copyWith({
    String? metricCode,
    String? metricName,
    String? metricValue,
    String? metricDisplayValue,
    String? dimCode,
    String? dimName,
    String? dimValue,
    String? dimDisplayValue,
  }) {
    return TargetManageOverviewChartAxisCompY()
      ..metricCode = metricCode ?? this.metricCode
      ..metricName = metricName ?? this.metricName
      ..metricValue = metricValue ?? this.metricValue
      ..metricDisplayValue = metricDisplayValue ?? this.metricDisplayValue
      ..dimCode = dimCode ?? this.dimCode
      ..dimName = dimName ?? this.dimName
      ..dimValue = dimValue ?? this.dimValue
      ..dimDisplayValue = dimDisplayValue ?? this.dimDisplayValue;
  }
}

TargetManageOverviewChartAxisX $TargetManageOverviewChartAxisXFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewChartAxisX targetManageOverviewChartAxisX = TargetManageOverviewChartAxisX();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    targetManageOverviewChartAxisX.dimCode = dimCode;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    targetManageOverviewChartAxisX.dimValue = dimValue;
  }
  final String? dimDisplayValue = jsonConvert.convert<String>(json['dimDisplayValue']);
  if (dimDisplayValue != null) {
    targetManageOverviewChartAxisX.dimDisplayValue = dimDisplayValue;
  }
  final String? dimName = jsonConvert.convert<String>(json['dimName']);
  if (dimName != null) {
    targetManageOverviewChartAxisX.dimName = dimName;
  }
  return targetManageOverviewChartAxisX;
}

Map<String, dynamic> $TargetManageOverviewChartAxisXToJson(TargetManageOverviewChartAxisX entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimValue'] = entity.dimValue;
  data['dimDisplayValue'] = entity.dimDisplayValue;
  data['dimName'] = entity.dimName;
  return data;
}

extension TargetManageOverviewChartAxisXExtension on TargetManageOverviewChartAxisX {
  TargetManageOverviewChartAxisX copyWith({
    String? dimCode,
    String? dimValue,
    String? dimDisplayValue,
    String? dimName,
  }) {
    return TargetManageOverviewChartAxisX()
      ..dimCode = dimCode ?? this.dimCode
      ..dimValue = dimValue ?? this.dimValue
      ..dimDisplayValue = dimDisplayValue ?? this.dimDisplayValue
      ..dimName = dimName ?? this.dimName;
  }
}

TargetManageOverviewDailyTrend $TargetManageOverviewDailyTrendFromJson(Map<String, dynamic> json) {
  final TargetManageOverviewDailyTrend targetManageOverviewDailyTrend = TargetManageOverviewDailyTrend();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    targetManageOverviewDailyTrend.title = title;
  }
  final List<TargetManageOverviewChart>? chart = (json['chart'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageOverviewChart>(e) as TargetManageOverviewChart)
      .toList();
  if (chart != null) {
    targetManageOverviewDailyTrend.chart = chart;
  }
  return targetManageOverviewDailyTrend;
}

Map<String, dynamic> $TargetManageOverviewDailyTrendToJson(TargetManageOverviewDailyTrend entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['chart'] = entity.chart?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageOverviewDailyTrendExtension on TargetManageOverviewDailyTrend {
  TargetManageOverviewDailyTrend copyWith({
    String? title,
    List<TargetManageOverviewChart>? chart,
  }) {
    return TargetManageOverviewDailyTrend()
      ..title = title ?? this.title
      ..chart = chart ?? this.chart;
  }
}
