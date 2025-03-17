import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';


AnalyticsEntityFilterComponentEntity $AnalyticsEntityFilterComponentEntityFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityFilterComponentEntity analyticsEntityFilterComponentEntity = AnalyticsEntityFilterComponentEntity();
  final List<AnalyticsEntityFilterComponentFilters>? filters = (json['filters'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<AnalyticsEntityFilterComponentFilters>(e) as AnalyticsEntityFilterComponentFilters)
      .toList();
  if (filters != null) {
    analyticsEntityFilterComponentEntity.filters = filters;
  }
  final List<AnalyticsEntityFilterComponentOrderBy>? orderBy = (json['orderBy'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<AnalyticsEntityFilterComponentOrderBy>(e) as AnalyticsEntityFilterComponentOrderBy)
      .toList();
  if (orderBy != null) {
    analyticsEntityFilterComponentEntity.orderBy = orderBy;
  }
  return analyticsEntityFilterComponentEntity;
}

Map<String, dynamic> $AnalyticsEntityFilterComponentEntityToJson(AnalyticsEntityFilterComponentEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['filters'] = entity.filters?.map((v) => v.toJson()).toList();
  data['orderBy'] = entity.orderBy?.map((v) => v.toJson()).toList();
  return data;
}

extension AnalyticsEntityFilterComponentEntityExtension on AnalyticsEntityFilterComponentEntity {
  AnalyticsEntityFilterComponentEntity copyWith({
    List<AnalyticsEntityFilterComponentFilters>? filters,
    List<AnalyticsEntityFilterComponentOrderBy>? orderBy,
  }) {
    return AnalyticsEntityFilterComponentEntity()
      ..filters = filters ?? this.filters
      ..orderBy = orderBy ?? this.orderBy;
  }
}

AnalyticsEntityFilterComponentFilters $AnalyticsEntityFilterComponentFiltersFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityFilterComponentFilters analyticsEntityFilterComponentFilters = AnalyticsEntityFilterComponentFilters();
  final String? fieldCode = jsonConvert.convert<String>(json['fieldCode']);
  if (fieldCode != null) {
    analyticsEntityFilterComponentFilters.fieldCode = fieldCode;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityFilterComponentFilters.displayName = displayName;
  }
  final EntityComponentType? componentType = jsonConvert.convert<EntityComponentType>(
      json['componentType'], enumConvert: (v) => EntityComponentType.values.byName(v));
  if (componentType != null) {
    analyticsEntityFilterComponentFilters.componentType = componentType;
  }
  final EntityFilterType? filterType = jsonConvert.convert<EntityFilterType>(
      json['filterType'], enumConvert: (v) => EntityFilterType.values.byName(v));
  if (filterType != null) {
    analyticsEntityFilterComponentFilters.filterType = filterType;
  }
  final List<AnalyticsEntityFilterComponentFiltersOptions>? options = (json['options'] as List<dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<AnalyticsEntityFilterComponentFiltersOptions>(
          e) as AnalyticsEntityFilterComponentFiltersOptions).toList();
  if (options != null) {
    analyticsEntityFilterComponentFilters.options = options;
  }
  return analyticsEntityFilterComponentFilters;
}

Map<String, dynamic> $AnalyticsEntityFilterComponentFiltersToJson(AnalyticsEntityFilterComponentFilters entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fieldCode'] = entity.fieldCode;
  data['displayName'] = entity.displayName;
  data['componentType'] = entity.componentType?.name;
  data['filterType'] = entity.filterType?.name;
  data['options'] = entity.options?.map((v) => v.toJson()).toList();
  return data;
}

extension AnalyticsEntityFilterComponentFiltersExtension on AnalyticsEntityFilterComponentFilters {
  AnalyticsEntityFilterComponentFilters copyWith({
    String? fieldCode,
    String? displayName,
    EntityComponentType? componentType,
    EntityFilterType? filterType,
    List<AnalyticsEntityFilterComponentFiltersOptions>? options,
  }) {
    return AnalyticsEntityFilterComponentFilters()
      ..fieldCode = fieldCode ?? this.fieldCode
      ..displayName = displayName ?? this.displayName
      ..componentType = componentType ?? this.componentType
      ..filterType = filterType ?? this.filterType
      ..options = options ?? this.options;
  }
}

AnalyticsEntityFilterComponentFiltersOptions $AnalyticsEntityFilterComponentFiltersOptionsFromJson(
    Map<String, dynamic> json) {
  final AnalyticsEntityFilterComponentFiltersOptions analyticsEntityFilterComponentFiltersOptions = AnalyticsEntityFilterComponentFiltersOptions();
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityFilterComponentFiltersOptions.displayName = displayName;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    analyticsEntityFilterComponentFiltersOptions.ifDefault = ifDefault;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    analyticsEntityFilterComponentFiltersOptions.isSelected = isSelected;
  }
  final List<String>? value = (json['value'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (value != null) {
    analyticsEntityFilterComponentFiltersOptions.value = value;
  }
  return analyticsEntityFilterComponentFiltersOptions;
}

Map<String, dynamic> $AnalyticsEntityFilterComponentFiltersOptionsToJson(
    AnalyticsEntityFilterComponentFiltersOptions entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['displayName'] = entity.displayName;
  data['ifDefault'] = entity.ifDefault;
  data['isSelected'] = entity.isSelected;
  data['value'] = entity.value;
  return data;
}

extension AnalyticsEntityFilterComponentFiltersOptionsExtension on AnalyticsEntityFilterComponentFiltersOptions {
  AnalyticsEntityFilterComponentFiltersOptions copyWith({
    String? displayName,
    bool? ifDefault,
    bool? isSelected,
    List<String>? value,
  }) {
    return AnalyticsEntityFilterComponentFiltersOptions()
      ..displayName = displayName ?? this.displayName
      ..ifDefault = ifDefault ?? this.ifDefault
      ..isSelected = isSelected ?? this.isSelected
      ..value = value ?? this.value;
  }
}

AnalyticsEntityFilterComponentOrderBy $AnalyticsEntityFilterComponentOrderByFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityFilterComponentOrderBy analyticsEntityFilterComponentOrderBy = AnalyticsEntityFilterComponentOrderBy();
  final String? fieldCode = jsonConvert.convert<String>(json['fieldCode']);
  if (fieldCode != null) {
    analyticsEntityFilterComponentOrderBy.fieldCode = fieldCode;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityFilterComponentOrderBy.displayName = displayName;
  }
  final String? defaultValue = jsonConvert.convert<String>(json['defaultValue']);
  if (defaultValue != null) {
    analyticsEntityFilterComponentOrderBy.defaultValue = defaultValue;
  }
  final bool? ifDefault = jsonConvert.convert<bool>(json['ifDefault']);
  if (ifDefault != null) {
    analyticsEntityFilterComponentOrderBy.ifDefault = ifDefault;
  }
  return analyticsEntityFilterComponentOrderBy;
}

Map<String, dynamic> $AnalyticsEntityFilterComponentOrderByToJson(AnalyticsEntityFilterComponentOrderBy entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fieldCode'] = entity.fieldCode;
  data['displayName'] = entity.displayName;
  data['defaultValue'] = entity.defaultValue;
  data['ifDefault'] = entity.ifDefault;
  return data;
}

extension AnalyticsEntityFilterComponentOrderByExtension on AnalyticsEntityFilterComponentOrderBy {
  AnalyticsEntityFilterComponentOrderBy copyWith({
    String? fieldCode,
    String? displayName,
    String? defaultValue,
    bool? ifDefault,
  }) {
    return AnalyticsEntityFilterComponentOrderBy()
      ..fieldCode = fieldCode ?? this.fieldCode
      ..displayName = displayName ?? this.displayName
      ..defaultValue = defaultValue ?? this.defaultValue
      ..ifDefault = ifDefault ?? this.ifDefault;
  }
}