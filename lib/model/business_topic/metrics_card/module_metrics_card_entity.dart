import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/module_metrics_card_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class ModuleMetricsCardEntity {
  // 指标数据
  List<ModuleMetricsCardMetrics>? metrics;

  // 图表数据
  List<ModuleMetricsCardChart>? chart;

  // 表单数据
  ModuleMetricsCardTable? table;

  ModuleMetricsCardEntity();

  factory ModuleMetricsCardEntity.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardEntityFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardMetrics {
  String? code;
  String? value;

  // $22,223,566.00
  String? displayValue;

  // $22.22
  String? abbrDisplayValue;

  // 亿、百万
  String? abbrDisplayUnit;

  // 数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;

  // 对比数据项
  ModuleMetricsCardCompValue? compValue;

  // 目标达成数据
  ModuleMetricsCardCompValueAchievement? achievement;

  // 下转数据结构
  ModuleMetricsCardDrillDownInfo? drillDownInfo;

  ModuleMetricsCardMetrics();

  factory ModuleMetricsCardMetrics.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardMetricsFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardChart {
  // 图表 X轴 信息
  ModuleMetricsCardChartAxisX? axisX;

  // 图表 Y轴 信息
  List<ModuleMetricsCardChartAxisY>? axisY;

  // 图表 Y轴 对比信息
  List<ModuleMetricsCardChartAxisY>? axisDayCompY;
  List<ModuleMetricsCardChartAxisY>? axisWeekCompY;
  List<ModuleMetricsCardChartAxisY>? axisMonthCompY;
  List<ModuleMetricsCardChartAxisY>? axisYearCompY;

  ModuleMetricsCardChart();

  factory ModuleMetricsCardChart.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardChartFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardChartToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardChartAxisY {
  // 指标编码
  String? metricCode;

  // 指标实际值
  String? metricValue;

  // 指标名
  String? metricName;

  // 指标展示值——暂时未用
  String? metricDisplayValue;

  // 指标展示值（缩写）——暂时未用
  String? abbrMetricDisplayValue;

  // 货币缩写单位——暂时未用
  String? abbrMetricDisplayUnit;

  // 调整后的值：比如有时候画图，需要把value调整到某个范围，便于画图
  String? metricAdjustedValue;

  // 指标数据类型
  @JSONField(isEnum: true)
  MetricOrDimDataType? metricDataType;

  // 维度code
  String? dimCode;

  // 维度值
  String? dimValue;

  // 维度值——展示用
  String? dimDisplayValue;

  // 附加展示信息
  String? extraDisplayInfo;

  ModuleMetricsCardChartAxisY();

  factory ModuleMetricsCardChartAxisY.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardChartAxisYFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardChartAxisYToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardChartAxisX {
  // 维度code
  String? dimCode;

  // 维度值
  String? dimValue;

  // 维度展示值
  String? dimDisplayValue;

  ModuleMetricsCardChartAxisX();

  factory ModuleMetricsCardChartAxisX.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardChartAxisXFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardChartAxisXToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardTable {
  List<ModuleMetricsCardTableHeader>? header;
  List<dynamic>? rows;

  ModuleMetricsCardTable();

  factory ModuleMetricsCardTable.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardTableFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardTableToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardTableHeader {
  String? name;
  String? code;

  ModuleMetricsCardTableHeader();

  factory ModuleMetricsCardTableHeader.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardTableHeaderFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardTableHeaderToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardTableRowsSubElement {
  String? code;
  String? value;

  String? displayValue;

  // 数据展示颜色
  String? displayValueColor;

  @JSONField(isEnum: true)
  MetricOrDimDataType? dataType;
  ModuleMetricsCardDrillDownInfo? drillDownInfo;

  // 对比
  ModuleMetricsCardCompValue? compValue;

  ModuleMetricsCardTableRowsSubElement();

  factory ModuleMetricsCardTableRowsSubElement.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardTableRowsSubElementFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardTableRowsSubElementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardCompValue {
  // 对比昨天
  ModuleMetricsCardCompValueCompare? dayCompare;

  // 对比上周
  ModuleMetricsCardCompValueCompare? weekCompare;

  // 对比上月
  ModuleMetricsCardCompValueCompare? monthCompare;

  // 对比去年
  ModuleMetricsCardCompValueCompare? yearCompare;

  ModuleMetricsCardCompValue();

  factory ModuleMetricsCardCompValue.fromJson(Map<String, dynamic> json) => $ModuleMetricsCardCompValueFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardCompValueToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardCompValueCompare {
  // 实际值：1.4159
  String? value;

  // 展示值：+141.59%
  String? displayValue;

  // 颜色：0xFF2BA471
  String? color;

  ModuleMetricsCardCompValueCompare();

  factory ModuleMetricsCardCompValueCompare.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardCompValueCompareFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardCompValueCompareToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardCompValueAchievement {
  // 实际值：0.0~1.0(有可能大于1)
  double? achievementRate;

  // 展示值：+58.59%
  String? displayAchievementRate;

  ModuleMetricsCardCompValueAchievement();

  factory ModuleMetricsCardCompValueAchievement.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardCompValueAchievementFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardCompValueAchievementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardDrillDownInfo {
  // 跳转页类型
  @JSONField(isEnum: true)
  EntityJumpPageType? pageType;

  // 去往列表页时传参
  String? metricCode;

  // 下级传参 维度code
  String? dimCode;

  // 兼容老版本-实体
  String? entity;

  // 兼容老版本-实体标题
  String? entityTitle;

  // 去往单门店时传参
  List<String>? shopIds;

  // 过滤条件
  List<ModuleMetricsCardDrillDownInfoFilter>? filter;

  // 下级页面传参
  List<ModuleMetricsCardDrillDownInfoParameters>? parameters;

  ModuleMetricsCardDrillDownInfo();

  factory ModuleMetricsCardDrillDownInfo.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardDrillDownInfoFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardDrillDownInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardDrillDownInfoFilter {
  // 过滤字段Code
  String? fieldCode;

  // entity
  String? entity;

  // 过滤比较类型
  @JSONField(isEnum: true)
  EntityFilterType? filterType;

  // 过滤的值。
  // filterType 为 RANGE 时，filterValue 为 [] 且长度为 2
  // filterType 为 EQ 时，filterValue 为 [] 且长度为 1
  List<String>? filterValue;

  // 展示名
  String? displayName;

  ModuleMetricsCardDrillDownInfoFilter();

  factory ModuleMetricsCardDrillDownInfoFilter.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardDrillDownInfoFilterFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardDrillDownInfoFilterToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ModuleMetricsCardDrillDownInfoParameters {
  // key
  String? name;

  // value
  dynamic value;

  ModuleMetricsCardDrillDownInfoParameters();

  factory ModuleMetricsCardDrillDownInfoParameters.fromJson(Map<String, dynamic> json) =>
      $ModuleMetricsCardDrillDownInfoParametersFromJson(json);

  Map<String, dynamic> toJson() => $ModuleMetricsCardDrillDownInfoParametersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
