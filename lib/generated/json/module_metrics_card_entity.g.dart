import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';

ModuleMetricsCardEntity $ModuleMetricsCardEntityFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardEntity moduleMetricsCardEntity = ModuleMetricsCardEntity();
  final List<ModuleMetricsCardMetrics>? metrics = (json['metrics'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardMetrics>(e) as ModuleMetricsCardMetrics)
      .toList();
  if (metrics != null) {
    moduleMetricsCardEntity.metrics = metrics;
  }
  final List<ModuleMetricsCardChart>? chart = (json['chart'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChart>(e) as ModuleMetricsCardChart)
      .toList();
  if (chart != null) {
    moduleMetricsCardEntity.chart = chart;
  }
  final ModuleMetricsCardTable? table = jsonConvert.convert<ModuleMetricsCardTable>(json['table']);
  if (table != null) {
    moduleMetricsCardEntity.table = table;
  }
  return moduleMetricsCardEntity;
}

Map<String, dynamic> $ModuleMetricsCardEntityToJson(ModuleMetricsCardEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metrics'] = entity.metrics?.map((v) => v.toJson()).toList();
  data['chart'] = entity.chart?.map((v) => v.toJson()).toList();
  data['table'] = entity.table?.toJson();
  return data;
}

extension ModuleMetricsCardEntityExtension on ModuleMetricsCardEntity {
  ModuleMetricsCardEntity copyWith({
    List<ModuleMetricsCardMetrics>? metrics,
    List<ModuleMetricsCardChart>? chart,
    ModuleMetricsCardTable? table,
  }) {
    return ModuleMetricsCardEntity()
      ..metrics = metrics ?? this.metrics
      ..chart = chart ?? this.chart
      ..table = table ?? this.table;
  }
}

ModuleMetricsCardMetrics $ModuleMetricsCardMetricsFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardMetrics moduleMetricsCardMetrics = ModuleMetricsCardMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleMetricsCardMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleMetricsCardMetrics.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleMetricsCardMetrics.displayValue = displayValue;
  }
  final String? abbrDisplayValue = jsonConvert.convert<String>(json['abbrDisplayValue']);
  if (abbrDisplayValue != null) {
    moduleMetricsCardMetrics.abbrDisplayValue = abbrDisplayValue;
  }
  final String? abbrDisplayUnit = jsonConvert.convert<String>(json['abbrDisplayUnit']);
  if (abbrDisplayUnit != null) {
    moduleMetricsCardMetrics.abbrDisplayUnit = abbrDisplayUnit;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    moduleMetricsCardMetrics.dataType = dataType;
  }
  final ModuleMetricsCardCompValue? compValue = jsonConvert.convert<ModuleMetricsCardCompValue>(json['compValue']);
  if (compValue != null) {
    moduleMetricsCardMetrics.compValue = compValue;
  }
  final ModuleMetricsCardCompValueAchievement? achievement =
      jsonConvert.convert<ModuleMetricsCardCompValueAchievement>(json['achievement']);
  if (achievement != null) {
    moduleMetricsCardMetrics.achievement = achievement;
  }
  final ModuleMetricsCardDrillDownInfo? drillDownInfo =
      jsonConvert.convert<ModuleMetricsCardDrillDownInfo>(json['drillDownInfo']);
  if (drillDownInfo != null) {
    moduleMetricsCardMetrics.drillDownInfo = drillDownInfo;
  }
  return moduleMetricsCardMetrics;
}

Map<String, dynamic> $ModuleMetricsCardMetricsToJson(ModuleMetricsCardMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['abbrDisplayValue'] = entity.abbrDisplayValue;
  data['abbrDisplayUnit'] = entity.abbrDisplayUnit;
  data['dataType'] = entity.dataType?.name;
  data['compValue'] = entity.compValue?.toJson();
  data['achievement'] = entity.achievement?.toJson();
  data['drillDownInfo'] = entity.drillDownInfo?.toJson();
  return data;
}

extension ModuleMetricsCardMetricsExtension on ModuleMetricsCardMetrics {
  ModuleMetricsCardMetrics copyWith({
    String? code,
    String? value,
    String? displayValue,
    String? abbrDisplayValue,
    String? abbrDisplayUnit,
    MetricOrDimDataType? dataType,
    ModuleMetricsCardCompValue? compValue,
    ModuleMetricsCardCompValueAchievement? achievement,
    ModuleMetricsCardDrillDownInfo? drillDownInfo,
  }) {
    return ModuleMetricsCardMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..abbrDisplayValue = abbrDisplayValue ?? this.abbrDisplayValue
      ..abbrDisplayUnit = abbrDisplayUnit ?? this.abbrDisplayUnit
      ..dataType = dataType ?? this.dataType
      ..compValue = compValue ?? this.compValue
      ..achievement = achievement ?? this.achievement
      ..drillDownInfo = drillDownInfo ?? this.drillDownInfo;
  }
}

ModuleMetricsCardChart $ModuleMetricsCardChartFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardChart moduleMetricsCardChart = ModuleMetricsCardChart();
  final ModuleMetricsCardChartAxisX? axisX = jsonConvert.convert<ModuleMetricsCardChartAxisX>(json['axisX']);
  if (axisX != null) {
    moduleMetricsCardChart.axisX = axisX;
  }
  final List<ModuleMetricsCardChartAxisY>? axisY = (json['axisY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChartAxisY>(e) as ModuleMetricsCardChartAxisY)
      .toList();
  if (axisY != null) {
    moduleMetricsCardChart.axisY = axisY;
  }
  final List<ModuleMetricsCardChartAxisY>? axisDayCompY = (json['axisDayCompY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChartAxisY>(e) as ModuleMetricsCardChartAxisY)
      .toList();
  if (axisDayCompY != null) {
    moduleMetricsCardChart.axisDayCompY = axisDayCompY;
  }
  final List<ModuleMetricsCardChartAxisY>? axisWeekCompY = (json['axisWeekCompY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChartAxisY>(e) as ModuleMetricsCardChartAxisY)
      .toList();
  if (axisWeekCompY != null) {
    moduleMetricsCardChart.axisWeekCompY = axisWeekCompY;
  }
  final List<ModuleMetricsCardChartAxisY>? axisMonthCompY = (json['axisMonthCompY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChartAxisY>(e) as ModuleMetricsCardChartAxisY)
      .toList();
  if (axisMonthCompY != null) {
    moduleMetricsCardChart.axisMonthCompY = axisMonthCompY;
  }
  final List<ModuleMetricsCardChartAxisY>? axisYearCompY = (json['axisYearCompY'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardChartAxisY>(e) as ModuleMetricsCardChartAxisY)
      .toList();
  if (axisYearCompY != null) {
    moduleMetricsCardChart.axisYearCompY = axisYearCompY;
  }
  return moduleMetricsCardChart;
}

Map<String, dynamic> $ModuleMetricsCardChartToJson(ModuleMetricsCardChart entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['axisX'] = entity.axisX?.toJson();
  data['axisY'] = entity.axisY?.map((v) => v.toJson()).toList();
  data['axisDayCompY'] = entity.axisDayCompY?.map((v) => v.toJson()).toList();
  data['axisWeekCompY'] = entity.axisWeekCompY?.map((v) => v.toJson()).toList();
  data['axisMonthCompY'] = entity.axisMonthCompY?.map((v) => v.toJson()).toList();
  data['axisYearCompY'] = entity.axisYearCompY?.map((v) => v.toJson()).toList();
  return data;
}

extension ModuleMetricsCardChartExtension on ModuleMetricsCardChart {
  ModuleMetricsCardChart copyWith({
    ModuleMetricsCardChartAxisX? axisX,
    List<ModuleMetricsCardChartAxisY>? axisY,
    List<ModuleMetricsCardChartAxisY>? axisDayCompY,
    List<ModuleMetricsCardChartAxisY>? axisWeekCompY,
    List<ModuleMetricsCardChartAxisY>? axisMonthCompY,
    List<ModuleMetricsCardChartAxisY>? axisYearCompY,
  }) {
    return ModuleMetricsCardChart()
      ..axisX = axisX ?? this.axisX
      ..axisY = axisY ?? this.axisY
      ..axisDayCompY = axisDayCompY ?? this.axisDayCompY
      ..axisWeekCompY = axisWeekCompY ?? this.axisWeekCompY
      ..axisMonthCompY = axisMonthCompY ?? this.axisMonthCompY
      ..axisYearCompY = axisYearCompY ?? this.axisYearCompY;
  }
}

ModuleMetricsCardChartAxisY $ModuleMetricsCardChartAxisYFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardChartAxisY moduleMetricsCardChartAxisY = ModuleMetricsCardChartAxisY();
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    moduleMetricsCardChartAxisY.metricCode = metricCode;
  }
  final String? metricValue = jsonConvert.convert<String>(json['metricValue']);
  if (metricValue != null) {
    moduleMetricsCardChartAxisY.metricValue = metricValue;
  }
  final String? metricName = jsonConvert.convert<String>(json['metricName']);
  if (metricName != null) {
    moduleMetricsCardChartAxisY.metricName = metricName;
  }
  final String? metricDisplayValue = jsonConvert.convert<String>(json['metricDisplayValue']);
  if (metricDisplayValue != null) {
    moduleMetricsCardChartAxisY.metricDisplayValue = metricDisplayValue;
  }
  final String? abbrMetricDisplayValue = jsonConvert.convert<String>(json['abbrMetricDisplayValue']);
  if (abbrMetricDisplayValue != null) {
    moduleMetricsCardChartAxisY.abbrMetricDisplayValue = abbrMetricDisplayValue;
  }
  final String? abbrMetricDisplayUnit = jsonConvert.convert<String>(json['abbrMetricDisplayUnit']);
  if (abbrMetricDisplayUnit != null) {
    moduleMetricsCardChartAxisY.abbrMetricDisplayUnit = abbrMetricDisplayUnit;
  }
  final String? metricAdjustedValue = jsonConvert.convert<String>(json['metricAdjustedValue']);
  if (metricAdjustedValue != null) {
    moduleMetricsCardChartAxisY.metricAdjustedValue = metricAdjustedValue;
  }
  final MetricOrDimDataType? metricDataType = jsonConvert.convert<MetricOrDimDataType>(json['metricDataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (metricDataType != null) {
    moduleMetricsCardChartAxisY.metricDataType = metricDataType;
  }
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    moduleMetricsCardChartAxisY.dimCode = dimCode;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    moduleMetricsCardChartAxisY.dimValue = dimValue;
  }
  final String? dimDisplayValue = jsonConvert.convert<String>(json['dimDisplayValue']);
  if (dimDisplayValue != null) {
    moduleMetricsCardChartAxisY.dimDisplayValue = dimDisplayValue;
  }
  final String? extraDisplayInfo = jsonConvert.convert<String>(json['extraDisplayInfo']);
  if (extraDisplayInfo != null) {
    moduleMetricsCardChartAxisY.extraDisplayInfo = extraDisplayInfo;
  }
  return moduleMetricsCardChartAxisY;
}

Map<String, dynamic> $ModuleMetricsCardChartAxisYToJson(ModuleMetricsCardChartAxisY entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['metricCode'] = entity.metricCode;
  data['metricValue'] = entity.metricValue;
  data['metricName'] = entity.metricName;
  data['metricDisplayValue'] = entity.metricDisplayValue;
  data['abbrMetricDisplayValue'] = entity.abbrMetricDisplayValue;
  data['abbrMetricDisplayUnit'] = entity.abbrMetricDisplayUnit;
  data['metricAdjustedValue'] = entity.metricAdjustedValue;
  data['metricDataType'] = entity.metricDataType?.name;
  data['dimCode'] = entity.dimCode;
  data['dimValue'] = entity.dimValue;
  data['dimDisplayValue'] = entity.dimDisplayValue;
  data['extraDisplayInfo'] = entity.extraDisplayInfo;
  return data;
}

extension ModuleMetricsCardChartAxisYExtension on ModuleMetricsCardChartAxisY {
  ModuleMetricsCardChartAxisY copyWith({
    String? metricCode,
    String? metricValue,
    String? metricName,
    String? metricDisplayValue,
    String? abbrMetricDisplayValue,
    String? abbrMetricDisplayUnit,
    String? metricAdjustedValue,
    MetricOrDimDataType? metricDataType,
    String? dimCode,
    String? dimValue,
    String? dimDisplayValue,
    String? extraDisplayInfo,
  }) {
    return ModuleMetricsCardChartAxisY()
      ..metricCode = metricCode ?? this.metricCode
      ..metricValue = metricValue ?? this.metricValue
      ..metricName = metricName ?? this.metricName
      ..metricDisplayValue = metricDisplayValue ?? this.metricDisplayValue
      ..abbrMetricDisplayValue = abbrMetricDisplayValue ?? this.abbrMetricDisplayValue
      ..abbrMetricDisplayUnit = abbrMetricDisplayUnit ?? this.abbrMetricDisplayUnit
      ..metricAdjustedValue = metricAdjustedValue ?? this.metricAdjustedValue
      ..metricDataType = metricDataType ?? this.metricDataType
      ..dimCode = dimCode ?? this.dimCode
      ..dimValue = dimValue ?? this.dimValue
      ..dimDisplayValue = dimDisplayValue ?? this.dimDisplayValue
      ..extraDisplayInfo = extraDisplayInfo ?? this.extraDisplayInfo;
  }
}

ModuleMetricsCardChartAxisX $ModuleMetricsCardChartAxisXFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardChartAxisX moduleMetricsCardChartAxisX = ModuleMetricsCardChartAxisX();
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    moduleMetricsCardChartAxisX.dimCode = dimCode;
  }
  final String? dimValue = jsonConvert.convert<String>(json['dimValue']);
  if (dimValue != null) {
    moduleMetricsCardChartAxisX.dimValue = dimValue;
  }
  final String? dimDisplayValue = jsonConvert.convert<String>(json['dimDisplayValue']);
  if (dimDisplayValue != null) {
    moduleMetricsCardChartAxisX.dimDisplayValue = dimDisplayValue;
  }
  return moduleMetricsCardChartAxisX;
}

Map<String, dynamic> $ModuleMetricsCardChartAxisXToJson(ModuleMetricsCardChartAxisX entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dimCode'] = entity.dimCode;
  data['dimValue'] = entity.dimValue;
  data['dimDisplayValue'] = entity.dimDisplayValue;
  return data;
}

extension ModuleMetricsCardChartAxisXExtension on ModuleMetricsCardChartAxisX {
  ModuleMetricsCardChartAxisX copyWith({
    String? dimCode,
    String? dimValue,
    String? dimDisplayValue,
  }) {
    return ModuleMetricsCardChartAxisX()
      ..dimCode = dimCode ?? this.dimCode
      ..dimValue = dimValue ?? this.dimValue
      ..dimDisplayValue = dimDisplayValue ?? this.dimDisplayValue;
  }
}

ModuleMetricsCardTable $ModuleMetricsCardTableFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardTable moduleMetricsCardTable = ModuleMetricsCardTable();
  final List<ModuleMetricsCardTableHeader>? header = (json['header'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardTableHeader>(e) as ModuleMetricsCardTableHeader)
      .toList();
  if (header != null) {
    moduleMetricsCardTable.header = header;
  }
  final List<dynamic>? rows = (json['rows'] as List<dynamic>?)?.map((e) => e).toList();
  if (rows != null) {
    moduleMetricsCardTable.rows = rows;
  }
  return moduleMetricsCardTable;
}

Map<String, dynamic> $ModuleMetricsCardTableToJson(ModuleMetricsCardTable entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['header'] = entity.header?.map((v) => v.toJson()).toList();
  data['rows'] = entity.rows;
  return data;
}

extension ModuleMetricsCardTableExtension on ModuleMetricsCardTable {
  ModuleMetricsCardTable copyWith({
    List<ModuleMetricsCardTableHeader>? header,
    List<dynamic>? rows,
  }) {
    return ModuleMetricsCardTable()
      ..header = header ?? this.header
      ..rows = rows ?? this.rows;
  }
}

ModuleMetricsCardTableHeader $ModuleMetricsCardTableHeaderFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardTableHeader moduleMetricsCardTableHeader = ModuleMetricsCardTableHeader();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    moduleMetricsCardTableHeader.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleMetricsCardTableHeader.code = code;
  }
  return moduleMetricsCardTableHeader;
}

Map<String, dynamic> $ModuleMetricsCardTableHeaderToJson(ModuleMetricsCardTableHeader entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  return data;
}

extension ModuleMetricsCardTableHeaderExtension on ModuleMetricsCardTableHeader {
  ModuleMetricsCardTableHeader copyWith({
    String? name,
    String? code,
  }) {
    return ModuleMetricsCardTableHeader()
      ..name = name ?? this.name
      ..code = code ?? this.code;
  }
}

ModuleMetricsCardTableRowsSubElement $ModuleMetricsCardTableRowsSubElementFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardTableRowsSubElement moduleMetricsCardTableRowsSubElement =
      ModuleMetricsCardTableRowsSubElement();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    moduleMetricsCardTableRowsSubElement.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleMetricsCardTableRowsSubElement.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleMetricsCardTableRowsSubElement.displayValue = displayValue;
  }
  final String? displayValueColor = jsonConvert.convert<String>(json['displayValueColor']);
  if (displayValueColor != null) {
    moduleMetricsCardTableRowsSubElement.displayValueColor = displayValueColor;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    moduleMetricsCardTableRowsSubElement.dataType = dataType;
  }
  final ModuleMetricsCardDrillDownInfo? drillDownInfo =
      jsonConvert.convert<ModuleMetricsCardDrillDownInfo>(json['drillDownInfo']);
  if (drillDownInfo != null) {
    moduleMetricsCardTableRowsSubElement.drillDownInfo = drillDownInfo;
  }
  final ModuleMetricsCardCompValue? compValue = jsonConvert.convert<ModuleMetricsCardCompValue>(json['compValue']);
  if (compValue != null) {
    moduleMetricsCardTableRowsSubElement.compValue = compValue;
  }
  return moduleMetricsCardTableRowsSubElement;
}

Map<String, dynamic> $ModuleMetricsCardTableRowsSubElementToJson(ModuleMetricsCardTableRowsSubElement entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['displayValueColor'] = entity.displayValueColor;
  data['dataType'] = entity.dataType?.name;
  data['drillDownInfo'] = entity.drillDownInfo?.toJson();
  data['compValue'] = entity.compValue?.toJson();
  return data;
}

extension ModuleMetricsCardTableRowsSubElementExtension on ModuleMetricsCardTableRowsSubElement {
  ModuleMetricsCardTableRowsSubElement copyWith({
    String? code,
    String? value,
    String? displayValue,
    String? displayValueColor,
    MetricOrDimDataType? dataType,
    ModuleMetricsCardDrillDownInfo? drillDownInfo,
    ModuleMetricsCardCompValue? compValue,
  }) {
    return ModuleMetricsCardTableRowsSubElement()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..displayValueColor = displayValueColor ?? this.displayValueColor
      ..dataType = dataType ?? this.dataType
      ..drillDownInfo = drillDownInfo ?? this.drillDownInfo
      ..compValue = compValue ?? this.compValue;
  }
}

ModuleMetricsCardCompValue $ModuleMetricsCardCompValueFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardCompValue moduleMetricsCardCompValue = ModuleMetricsCardCompValue();
  final ModuleMetricsCardCompValueCompare? dayCompare =
      jsonConvert.convert<ModuleMetricsCardCompValueCompare>(json['dayCompare']);
  if (dayCompare != null) {
    moduleMetricsCardCompValue.dayCompare = dayCompare;
  }
  final ModuleMetricsCardCompValueCompare? weekCompare =
      jsonConvert.convert<ModuleMetricsCardCompValueCompare>(json['weekCompare']);
  if (weekCompare != null) {
    moduleMetricsCardCompValue.weekCompare = weekCompare;
  }
  final ModuleMetricsCardCompValueCompare? monthCompare =
      jsonConvert.convert<ModuleMetricsCardCompValueCompare>(json['monthCompare']);
  if (monthCompare != null) {
    moduleMetricsCardCompValue.monthCompare = monthCompare;
  }
  final ModuleMetricsCardCompValueCompare? yearCompare =
      jsonConvert.convert<ModuleMetricsCardCompValueCompare>(json['yearCompare']);
  if (yearCompare != null) {
    moduleMetricsCardCompValue.yearCompare = yearCompare;
  }
  return moduleMetricsCardCompValue;
}

Map<String, dynamic> $ModuleMetricsCardCompValueToJson(ModuleMetricsCardCompValue entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dayCompare'] = entity.dayCompare?.toJson();
  data['weekCompare'] = entity.weekCompare?.toJson();
  data['monthCompare'] = entity.monthCompare?.toJson();
  data['yearCompare'] = entity.yearCompare?.toJson();
  return data;
}

extension ModuleMetricsCardCompValueExtension on ModuleMetricsCardCompValue {
  ModuleMetricsCardCompValue copyWith({
    ModuleMetricsCardCompValueCompare? dayCompare,
    ModuleMetricsCardCompValueCompare? weekCompare,
    ModuleMetricsCardCompValueCompare? monthCompare,
    ModuleMetricsCardCompValueCompare? yearCompare,
  }) {
    return ModuleMetricsCardCompValue()
      ..dayCompare = dayCompare ?? this.dayCompare
      ..weekCompare = weekCompare ?? this.weekCompare
      ..monthCompare = monthCompare ?? this.monthCompare
      ..yearCompare = yearCompare ?? this.yearCompare;
  }
}

ModuleMetricsCardCompValueCompare $ModuleMetricsCardCompValueCompareFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardCompValueCompare moduleMetricsCardCompValueCompare = ModuleMetricsCardCompValueCompare();
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    moduleMetricsCardCompValueCompare.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    moduleMetricsCardCompValueCompare.displayValue = displayValue;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    moduleMetricsCardCompValueCompare.color = color;
  }
  return moduleMetricsCardCompValueCompare;
}

Map<String, dynamic> $ModuleMetricsCardCompValueCompareToJson(ModuleMetricsCardCompValueCompare entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['color'] = entity.color;
  return data;
}

extension ModuleMetricsCardCompValueCompareExtension on ModuleMetricsCardCompValueCompare {
  ModuleMetricsCardCompValueCompare copyWith({
    String? value,
    String? displayValue,
    String? color,
  }) {
    return ModuleMetricsCardCompValueCompare()
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..color = color ?? this.color;
  }
}

ModuleMetricsCardCompValueAchievement $ModuleMetricsCardCompValueAchievementFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardCompValueAchievement moduleMetricsCardCompValueAchievement =
      ModuleMetricsCardCompValueAchievement();
  final double? achievementRate = jsonConvert.convert<double>(json['achievementRate']);
  if (achievementRate != null) {
    moduleMetricsCardCompValueAchievement.achievementRate = achievementRate;
  }
  final String? displayAchievementRate = jsonConvert.convert<String>(json['displayAchievementRate']);
  if (displayAchievementRate != null) {
    moduleMetricsCardCompValueAchievement.displayAchievementRate = displayAchievementRate;
  }
  return moduleMetricsCardCompValueAchievement;
}

Map<String, dynamic> $ModuleMetricsCardCompValueAchievementToJson(ModuleMetricsCardCompValueAchievement entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['achievementRate'] = entity.achievementRate;
  data['displayAchievementRate'] = entity.displayAchievementRate;
  return data;
}

extension ModuleMetricsCardCompValueAchievementExtension on ModuleMetricsCardCompValueAchievement {
  ModuleMetricsCardCompValueAchievement copyWith({
    double? achievementRate,
    String? displayAchievementRate,
  }) {
    return ModuleMetricsCardCompValueAchievement()
      ..achievementRate = achievementRate ?? this.achievementRate
      ..displayAchievementRate = displayAchievementRate ?? this.displayAchievementRate;
  }
}

ModuleMetricsCardDrillDownInfo $ModuleMetricsCardDrillDownInfoFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardDrillDownInfo moduleMetricsCardDrillDownInfo = ModuleMetricsCardDrillDownInfo();
  final EntityJumpPageType? pageType = jsonConvert.convert<EntityJumpPageType>(json['pageType'],
      enumConvert: (v) => EntityJumpPageType.values.byName(v));
  if (pageType != null) {
    moduleMetricsCardDrillDownInfo.pageType = pageType;
  }
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    moduleMetricsCardDrillDownInfo.metricCode = metricCode;
  }
  final String? dimCode = jsonConvert.convert<String>(json['dimCode']);
  if (dimCode != null) {
    moduleMetricsCardDrillDownInfo.dimCode = dimCode;
  }
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    moduleMetricsCardDrillDownInfo.entity = entity;
  }
  final String? entityTitle = jsonConvert.convert<String>(json['entityTitle']);
  if (entityTitle != null) {
    moduleMetricsCardDrillDownInfo.entityTitle = entityTitle;
  }
  final List<String>? shopIds =
      (json['shopIds'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (shopIds != null) {
    moduleMetricsCardDrillDownInfo.shopIds = shopIds;
  }
  final List<ModuleMetricsCardDrillDownInfoFilter>? filter = (json['filter'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<ModuleMetricsCardDrillDownInfoFilter>(e) as ModuleMetricsCardDrillDownInfoFilter)
      .toList();
  if (filter != null) {
    moduleMetricsCardDrillDownInfo.filter = filter;
  }
  final List<ModuleMetricsCardDrillDownInfoParameters>? parameters = (json['parameters'] as List<dynamic>?)
      ?.map((e) =>
          jsonConvert.convert<ModuleMetricsCardDrillDownInfoParameters>(e) as ModuleMetricsCardDrillDownInfoParameters)
      .toList();
  if (parameters != null) {
    moduleMetricsCardDrillDownInfo.parameters = parameters;
  }
  return moduleMetricsCardDrillDownInfo;
}

Map<String, dynamic> $ModuleMetricsCardDrillDownInfoToJson(ModuleMetricsCardDrillDownInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['pageType'] = entity.pageType?.name;
  data['metricCode'] = entity.metricCode;
  data['dimCode'] = entity.dimCode;
  data['entity'] = entity.entity;
  data['entityTitle'] = entity.entityTitle;
  data['shopIds'] = entity.shopIds;
  data['filter'] = entity.filter?.map((v) => v.toJson()).toList();
  data['parameters'] = entity.parameters?.map((v) => v.toJson()).toList();
  return data;
}

extension ModuleMetricsCardDrillDownInfoExtension on ModuleMetricsCardDrillDownInfo {
  ModuleMetricsCardDrillDownInfo copyWith({
    EntityJumpPageType? pageType,
    String? metricCode,
    String? dimCode,
    String? entity,
    String? entityTitle,
    List<String>? shopIds,
    List<ModuleMetricsCardDrillDownInfoFilter>? filter,
    List<ModuleMetricsCardDrillDownInfoParameters>? parameters,
  }) {
    return ModuleMetricsCardDrillDownInfo()
      ..pageType = pageType ?? this.pageType
      ..metricCode = metricCode ?? this.metricCode
      ..dimCode = dimCode ?? this.dimCode
      ..entity = entity ?? this.entity
      ..entityTitle = entityTitle ?? this.entityTitle
      ..shopIds = shopIds ?? this.shopIds
      ..filter = filter ?? this.filter
      ..parameters = parameters ?? this.parameters;
  }
}

ModuleMetricsCardDrillDownInfoFilter $ModuleMetricsCardDrillDownInfoFilterFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardDrillDownInfoFilter moduleMetricsCardDrillDownInfoFilter =
      ModuleMetricsCardDrillDownInfoFilter();
  final String? fieldCode = jsonConvert.convert<String>(json['fieldCode']);
  if (fieldCode != null) {
    moduleMetricsCardDrillDownInfoFilter.fieldCode = fieldCode;
  }
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    moduleMetricsCardDrillDownInfoFilter.entity = entity;
  }
  final EntityFilterType? filterType =
      jsonConvert.convert<EntityFilterType>(json['filterType'], enumConvert: (v) => EntityFilterType.values.byName(v));
  if (filterType != null) {
    moduleMetricsCardDrillDownInfoFilter.filterType = filterType;
  }
  final List<String>? filterValue =
      (json['filterValue'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (filterValue != null) {
    moduleMetricsCardDrillDownInfoFilter.filterValue = filterValue;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    moduleMetricsCardDrillDownInfoFilter.displayName = displayName;
  }
  return moduleMetricsCardDrillDownInfoFilter;
}

Map<String, dynamic> $ModuleMetricsCardDrillDownInfoFilterToJson(ModuleMetricsCardDrillDownInfoFilter entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fieldCode'] = entity.fieldCode;
  data['entity'] = entity.entity;
  data['filterType'] = entity.filterType?.name;
  data['filterValue'] = entity.filterValue;
  data['displayName'] = entity.displayName;
  return data;
}

extension ModuleMetricsCardDrillDownInfoFilterExtension on ModuleMetricsCardDrillDownInfoFilter {
  ModuleMetricsCardDrillDownInfoFilter copyWith({
    String? fieldCode,
    String? entity,
    EntityFilterType? filterType,
    List<String>? filterValue,
    String? displayName,
  }) {
    return ModuleMetricsCardDrillDownInfoFilter()
      ..fieldCode = fieldCode ?? this.fieldCode
      ..entity = entity ?? this.entity
      ..filterType = filterType ?? this.filterType
      ..filterValue = filterValue ?? this.filterValue
      ..displayName = displayName ?? this.displayName;
  }
}

ModuleMetricsCardDrillDownInfoParameters $ModuleMetricsCardDrillDownInfoParametersFromJson(Map<String, dynamic> json) {
  final ModuleMetricsCardDrillDownInfoParameters moduleMetricsCardDrillDownInfoParameters =
      ModuleMetricsCardDrillDownInfoParameters();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    moduleMetricsCardDrillDownInfoParameters.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    moduleMetricsCardDrillDownInfoParameters.value = value;
  }
  return moduleMetricsCardDrillDownInfoParameters;
}

Map<String, dynamic> $ModuleMetricsCardDrillDownInfoParametersToJson(ModuleMetricsCardDrillDownInfoParameters entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  return data;
}

extension ModuleMetricsCardDrillDownInfoParametersExtension on ModuleMetricsCardDrillDownInfoParameters {
  ModuleMetricsCardDrillDownInfoParameters copyWith({
    String? name,
    dynamic value,
  }) {
    return ModuleMetricsCardDrillDownInfoParameters()
      ..name = name ?? this.name
      ..value = value ?? this.value;
  }
}
