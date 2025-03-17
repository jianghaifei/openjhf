import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_list_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

AnalyticsEntityListEntity $AnalyticsEntityListEntityFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListEntity analyticsEntityListEntity = AnalyticsEntityListEntity();
  final AnalyticsEntityListPage? page = jsonConvert.convert<AnalyticsEntityListPage>(json['page']);
  if (page != null) {
    analyticsEntityListEntity.page = page;
  }
  final List<AnalyticsEntityListList>? list = (json['list'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<AnalyticsEntityListList>(e) as AnalyticsEntityListList)
      .toList();
  if (list != null) {
    analyticsEntityListEntity.list = list;
  }
  return analyticsEntityListEntity;
}

Map<String, dynamic> $AnalyticsEntityListEntityToJson(AnalyticsEntityListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page?.toJson();
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension AnalyticsEntityListEntityExtension on AnalyticsEntityListEntity {
  AnalyticsEntityListEntity copyWith({
    AnalyticsEntityListPage? page,
    List<AnalyticsEntityListList>? list,
  }) {
    return AnalyticsEntityListEntity()
      ..page = page ?? this.page
      ..list = list ?? this.list;
  }
}

AnalyticsEntityListPage $AnalyticsEntityListPageFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListPage analyticsEntityListPage = AnalyticsEntityListPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    analyticsEntityListPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    analyticsEntityListPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    analyticsEntityListPage.pageSize = pageSize;
  }
  final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
  if (pageCount != null) {
    analyticsEntityListPage.pageCount = pageCount;
  }
  return analyticsEntityListPage;
}

Map<String, dynamic> $AnalyticsEntityListPageToJson(AnalyticsEntityListPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  data['pageCount'] = entity.pageCount;
  return data;
}

extension AnalyticsEntityListPageExtension on AnalyticsEntityListPage {
  AnalyticsEntityListPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
    int? pageCount,
  }) {
    return AnalyticsEntityListPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize
      ..pageCount = pageCount ?? this.pageCount;
  }
}

AnalyticsEntityListList $AnalyticsEntityListListFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListList analyticsEntityListList = AnalyticsEntityListList();
  final AnalyticsEntityListListMetrics? primaryField =
      jsonConvert.convert<AnalyticsEntityListListMetrics>(json['primaryField']);
  if (primaryField != null) {
    analyticsEntityListList.primaryField = primaryField;
  }
  final List<AnalyticsEntityListListDims>? dims = (json['dims'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<AnalyticsEntityListListDims>(e) as AnalyticsEntityListListDims)
      .toList();
  if (dims != null) {
    analyticsEntityListList.dims = dims;
  }
  final List<AnalyticsEntityListListTags>? tags = (json['tags'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<AnalyticsEntityListListTags>(e) as AnalyticsEntityListListTags)
      .toList();
  if (tags != null) {
    analyticsEntityListList.tags = tags;
  }
  final AnalyticsEntityListNext? next = jsonConvert.convert<AnalyticsEntityListNext>(json['next']);
  if (next != null) {
    analyticsEntityListList.next = next;
  }
  return analyticsEntityListList;
}

Map<String, dynamic> $AnalyticsEntityListListToJson(AnalyticsEntityListList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['primaryField'] = entity.primaryField?.toJson();
  data['dims'] = entity.dims?.map((v) => v.toJson()).toList();
  data['tags'] = entity.tags?.map((v) => v.toJson()).toList();
  data['next'] = entity.next?.toJson();
  return data;
}

extension AnalyticsEntityListListExtension on AnalyticsEntityListList {
  AnalyticsEntityListList copyWith({
    AnalyticsEntityListListMetrics? primaryField,
    List<AnalyticsEntityListListDims>? dims,
    List<AnalyticsEntityListListTags>? tags,
    AnalyticsEntityListNext? next,
  }) {
    return AnalyticsEntityListList()
      ..primaryField = primaryField ?? this.primaryField
      ..dims = dims ?? this.dims
      ..tags = tags ?? this.tags
      ..next = next ?? this.next;
  }
}

AnalyticsEntityListListMetrics $AnalyticsEntityListListMetricsFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListListMetrics analyticsEntityListListMetrics = AnalyticsEntityListListMetrics();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    analyticsEntityListListMetrics.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    analyticsEntityListListMetrics.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    analyticsEntityListListMetrics.displayValue = displayValue;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityListListMetrics.displayName = displayName;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    analyticsEntityListListMetrics.dataType = dataType;
  }
  return analyticsEntityListListMetrics;
}

Map<String, dynamic> $AnalyticsEntityListListMetricsToJson(AnalyticsEntityListListMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['displayName'] = entity.displayName;
  data['dataType'] = entity.dataType?.name;
  return data;
}

extension AnalyticsEntityListListMetricsExtension on AnalyticsEntityListListMetrics {
  AnalyticsEntityListListMetrics copyWith({
    String? code,
    String? value,
    String? displayValue,
    String? displayName,
    MetricOrDimDataType? dataType,
  }) {
    return AnalyticsEntityListListMetrics()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..displayName = displayName ?? this.displayName
      ..dataType = dataType ?? this.dataType;
  }
}

AnalyticsEntityListListDims $AnalyticsEntityListListDimsFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListListDims analyticsEntityListListDims = AnalyticsEntityListListDims();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    analyticsEntityListListDims.code = code;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityListListDims.displayName = displayName;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    analyticsEntityListListDims.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    analyticsEntityListListDims.displayValue = displayValue;
  }
  final bool? showing = jsonConvert.convert<bool>(json['showing']);
  if (showing != null) {
    analyticsEntityListListDims.showing = showing;
  }
  final MetricOrDimDataType? dataType = jsonConvert.convert<MetricOrDimDataType>(json['dataType'],
      enumConvert: (v) => MetricOrDimDataType.values.byName(v));
  if (dataType != null) {
    analyticsEntityListListDims.dataType = dataType;
  }
  final bool? primaryKey = jsonConvert.convert<bool>(json['primaryKey']);
  if (primaryKey != null) {
    analyticsEntityListListDims.primaryKey = primaryKey;
  }
  return analyticsEntityListListDims;
}

Map<String, dynamic> $AnalyticsEntityListListDimsToJson(AnalyticsEntityListListDims entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['displayName'] = entity.displayName;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['showing'] = entity.showing;
  data['dataType'] = entity.dataType?.name;
  data['primaryKey'] = entity.primaryKey;
  return data;
}

extension AnalyticsEntityListListDimsExtension on AnalyticsEntityListListDims {
  AnalyticsEntityListListDims copyWith({
    String? code,
    String? displayName,
    String? value,
    String? displayValue,
    bool? showing,
    MetricOrDimDataType? dataType,
    bool? primaryKey,
  }) {
    return AnalyticsEntityListListDims()
      ..code = code ?? this.code
      ..displayName = displayName ?? this.displayName
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..showing = showing ?? this.showing
      ..dataType = dataType ?? this.dataType
      ..primaryKey = primaryKey ?? this.primaryKey;
  }
}

AnalyticsEntityListListTags $AnalyticsEntityListListTagsFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListListTags analyticsEntityListListTags = AnalyticsEntityListListTags();
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    analyticsEntityListListTags.displayName = displayName;
  }
  final OrderEntityTagType? tagEnum =
      jsonConvert.convert<OrderEntityTagType>(json['tagEnum'], enumConvert: (v) => OrderEntityTagType.values.byName(v));
  if (tagEnum != null) {
    analyticsEntityListListTags.tagEnum = tagEnum;
  }
  return analyticsEntityListListTags;
}

Map<String, dynamic> $AnalyticsEntityListListTagsToJson(AnalyticsEntityListListTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['displayName'] = entity.displayName;
  data['tagEnum'] = entity.tagEnum?.name;
  return data;
}

extension AnalyticsEntityListListTagsExtension on AnalyticsEntityListListTags {
  AnalyticsEntityListListTags copyWith({
    String? displayName,
    OrderEntityTagType? tagEnum,
  }) {
    return AnalyticsEntityListListTags()
      ..displayName = displayName ?? this.displayName
      ..tagEnum = tagEnum ?? this.tagEnum;
  }
}

AnalyticsEntityListNext $AnalyticsEntityListNextFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListNext analyticsEntityListNext = AnalyticsEntityListNext();
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    analyticsEntityListNext.entity = entity;
  }
  final String? entityTitle = jsonConvert.convert<String>(json['entityTitle']);
  if (entityTitle != null) {
    analyticsEntityListNext.entityTitle = entityTitle;
  }
  final String? metricCode = jsonConvert.convert<String>(json['metricCode']);
  if (metricCode != null) {
    analyticsEntityListNext.metricCode = metricCode;
  }
  final AnalyticsEntityListNextFilterPassingInfo? filtersPassingInfo =
      jsonConvert.convert<AnalyticsEntityListNextFilterPassingInfo>(json['filtersPassingInfo']);
  if (filtersPassingInfo != null) {
    analyticsEntityListNext.filtersPassingInfo = filtersPassingInfo;
  }
  final EntityJumpPageType? pageType = jsonConvert.convert<EntityJumpPageType>(json['pageType'],
      enumConvert: (v) => EntityJumpPageType.values.byName(v));
  if (pageType != null) {
    analyticsEntityListNext.pageType = pageType;
  }
  return analyticsEntityListNext;
}

Map<String, dynamic> $AnalyticsEntityListNextToJson(AnalyticsEntityListNext entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['entity'] = entity.entity;
  data['entityTitle'] = entity.entityTitle;
  data['metricCode'] = entity.metricCode;
  data['filtersPassingInfo'] = entity.filtersPassingInfo?.toJson();
  data['pageType'] = entity.pageType?.name;
  return data;
}

extension AnalyticsEntityListNextExtension on AnalyticsEntityListNext {
  AnalyticsEntityListNext copyWith({
    String? entity,
    String? entityTitle,
    String? metricCode,
    AnalyticsEntityListNextFilterPassingInfo? filtersPassingInfo,
    EntityJumpPageType? pageType,
  }) {
    return AnalyticsEntityListNext()
      ..entity = entity ?? this.entity
      ..entityTitle = entityTitle ?? this.entityTitle
      ..metricCode = metricCode ?? this.metricCode
      ..filtersPassingInfo = filtersPassingInfo ?? this.filtersPassingInfo
      ..pageType = pageType ?? this.pageType;
  }
}

AnalyticsEntityListNextFilterPassingInfo $AnalyticsEntityListNextFilterPassingInfoFromJson(Map<String, dynamic> json) {
  final AnalyticsEntityListNextFilterPassingInfo analyticsEntityListNextFilterPassingInfo =
      AnalyticsEntityListNextFilterPassingInfo();
  final List<String>? dims =
      (json['dims'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (dims != null) {
    analyticsEntityListNextFilterPassingInfo.dims = dims;
  }
  return analyticsEntityListNextFilterPassingInfo;
}

Map<String, dynamic> $AnalyticsEntityListNextFilterPassingInfoToJson(AnalyticsEntityListNextFilterPassingInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['dims'] = entity.dims;
  return data;
}

extension AnalyticsEntityListNextFilterPassingInfoExtension on AnalyticsEntityListNextFilterPassingInfo {
  AnalyticsEntityListNextFilterPassingInfo copyWith({
    List<String>? dims,
  }) {
    return AnalyticsEntityListNextFilterPassingInfo()..dims = dims ?? this.dims;
  }
}
