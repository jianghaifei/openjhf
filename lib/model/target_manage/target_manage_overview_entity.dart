import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/target_manage_overview_entity.g.dart';
import 'package:flutter_report_project/model/store/store_pk/store_pk_table_entity.dart';

@JsonSerializable()
class TargetManageOverviewEntity {
  TargetManageOverviewUnSetShopInfo? unSetShopInfo;
  TargetManageOverviewSummary? summary;
  TargetManageOverviewOverall? overall;
  TargetManageOverviewShopAchievement? shopAchievement;
  TargetManageOverviewShopAchievementDetail? shopAchievementDetail;
  TargetManageOverviewCumulativeTrend? cumulativeTrend;
  TargetManageOverviewDailyTrend? dailyTrend;

  TargetManageOverviewEntity();

  factory TargetManageOverviewEntity.fromJson(Map<String, dynamic> json) => $TargetManageOverviewEntityFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewUnSetShopInfo {
  String? msg;
  List<TargetManageOverviewUnSetShopInfoShopInfos>? shopInfos;

  TargetManageOverviewUnSetShopInfo();

  factory TargetManageOverviewUnSetShopInfo.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewUnSetShopInfoFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewUnSetShopInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewUnSetShopInfoShopInfos {
  String? shopId;
  String? shopName;

  TargetManageOverviewUnSetShopInfoShopInfos();

  factory TargetManageOverviewUnSetShopInfoShopInfos.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewUnSetShopInfoShopInfosFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewUnSetShopInfoShopInfosToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewSummary {
  String? title;
  String? msg;
  bool drillDown = false;

  TargetManageOverviewSummary();

  factory TargetManageOverviewSummary.fromJson(Map<String, dynamic> json) => $TargetManageOverviewSummaryFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewSummaryToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewOverall {
  String? title;
  TargetManageOverviewOverallAchievementRate? achievementRate;
  TargetManageOverviewOverallTarget? target;
  TargetManageOverviewOverallAchieved? achieved;
  TargetManageOverviewOverallNotAchieved? notAchieved;

  TargetManageOverviewOverall();

  factory TargetManageOverviewOverall.fromJson(Map<String, dynamic> json) => $TargetManageOverviewOverallFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewOverallToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewOverallAchievementRate {
  String? name;
  String? value;
  String? displayValue;

  TargetManageOverviewOverallAchievementRate();

  factory TargetManageOverviewOverallAchievementRate.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewOverallAchievementRateFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewOverallAchievementRateToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewOverallTarget {
  String? name;
  String? value;
  String? displayValue;

  TargetManageOverviewOverallTarget();

  factory TargetManageOverviewOverallTarget.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewOverallTargetFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewOverallTargetToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewOverallAchieved {
  String? name;
  String? value;
  String? displayValue;

  TargetManageOverviewOverallAchieved();

  factory TargetManageOverviewOverallAchieved.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewOverallAchievedFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewOverallAchievedToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewOverallNotAchieved {
  String? name;
  String? value;
  String? displayValue;

  TargetManageOverviewOverallNotAchieved();

  factory TargetManageOverviewOverallNotAchieved.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewOverallNotAchievedFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewOverallNotAchievedToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievement {
  String? title;
  List<TargetManageOverviewShopAchievementMetrics>? metrics;
  TargetManageOverviewShopAchievementReportData? reportData;

  TargetManageOverviewShopAchievement();

  factory TargetManageOverviewShopAchievement.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementMetrics {
  String? code;
  String? value;
  String? name;
  String? displayValue;

  TargetManageOverviewShopAchievementMetrics();

  factory TargetManageOverviewShopAchievementMetrics.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementReportData {
  List<TargetManageOverviewShopAchievementReportDataRows>? rows;

  TargetManageOverviewShopAchievementReportData();

  factory TargetManageOverviewShopAchievementReportData.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementReportDataFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementReportDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementReportDataRows {
  List<TargetManageOverviewShopAchievementReportDataRowsDims>? dims;
  List<TargetManageOverviewShopAchievementReportDataRowsMetrics>? metrics;

  TargetManageOverviewShopAchievementReportDataRows();

  factory TargetManageOverviewShopAchievementReportDataRows.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementReportDataRowsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementReportDataRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementReportDataRowsDims {
  String? code;
  String? value;
  String? name;
  String? displayValue;

  TargetManageOverviewShopAchievementReportDataRowsDims();

  factory TargetManageOverviewShopAchievementReportDataRowsDims.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementReportDataRowsDimsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementReportDataRowsDimsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementReportDataRowsMetrics {
  String? code;
  String? value;
  String? name;
  String? displayValue;
  double? proportion;

  TargetManageOverviewShopAchievementReportDataRowsMetrics();

  factory TargetManageOverviewShopAchievementReportDataRowsMetrics.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementReportDataRowsMetricsFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementReportDataRowsMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewShopAchievementDetail {
  String? title;
  StorePKTableEntityTable? table;

  TargetManageOverviewShopAchievementDetail();

  factory TargetManageOverviewShopAchievementDetail.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewShopAchievementDetailFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewShopAchievementDetailToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewCumulativeTrend {
  String? title;
  List<TargetManageOverviewChart>? chart;

  TargetManageOverviewCumulativeTrend();

  factory TargetManageOverviewCumulativeTrend.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewCumulativeTrendFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewCumulativeTrendToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewChart {
  List<TargetManageOverviewChartAxisY>? axisY;
  List<TargetManageOverviewChartAxisCompY>? axisCompY;
  TargetManageOverviewChartAxisX? axisX;

  TargetManageOverviewChart();

  factory TargetManageOverviewChart.fromJson(Map<String, dynamic> json) => $TargetManageOverviewChartFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewChartToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewChartAxisY {
  String? metricCode;
  String? metricName;
  String? metricValue;
  String? metricDisplayValue;
  String? dimCode;
  String? dimName;
  String? dimValue;
  String? dimDisplayValue;

  TargetManageOverviewChartAxisY();

  factory TargetManageOverviewChartAxisY.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewChartAxisYFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewChartAxisYToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewChartAxisCompY {
  String? metricCode;
  String? metricName;
  String? metricValue;
  String? metricDisplayValue;
  String? dimCode;
  String? dimName;
  String? dimValue;
  String? dimDisplayValue;

  TargetManageOverviewChartAxisCompY();

  factory TargetManageOverviewChartAxisCompY.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewChartAxisCompYFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewChartAxisCompYToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewChartAxisX {
  String? dimCode;
  String? dimValue;
  String? dimDisplayValue;
  String? dimName;

  TargetManageOverviewChartAxisX();

  factory TargetManageOverviewChartAxisX.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewChartAxisXFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewChartAxisXToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageOverviewDailyTrend {
  String? title;
  List<TargetManageOverviewChart>? chart;

  TargetManageOverviewDailyTrend();

  factory TargetManageOverviewDailyTrend.fromJson(Map<String, dynamic> json) =>
      $TargetManageOverviewDailyTrendFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageOverviewDailyTrendToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
