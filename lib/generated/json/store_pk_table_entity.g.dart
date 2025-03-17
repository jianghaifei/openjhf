import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/store/store_pk/store_pk_table_entity.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';


StorePKTableEntity $StorePKTableEntityFromJson(Map<String, dynamic> json) {
  final StorePKTableEntity storePKTableEntity = StorePKTableEntity();
  final StorePKTableEntityTable? table = jsonConvert.convert<StorePKTableEntityTable>(json['table']);
  if (table != null) {
    storePKTableEntity.table = table;
  }
  return storePKTableEntity;
}

Map<String, dynamic> $StorePKTableEntityToJson(StorePKTableEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['table'] = entity.table?.toJson();
  return data;
}

extension StorePKTableEntityExtension on StorePKTableEntity {
  StorePKTableEntity copyWith({
    StorePKTableEntityTable? table,
  }) {
    return StorePKTableEntity()
      ..table = table ?? this.table;
  }
}

StorePKTableEntityTable $StorePKTableEntityTableFromJson(Map<String, dynamic> json) {
  final StorePKTableEntityTable storePKTableEntityTable = StorePKTableEntityTable();
  final List<StorePKTableEntityTableHeader>? header = (json['header'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StorePKTableEntityTableHeader>(e) as StorePKTableEntityTableHeader).toList();
  if (header != null) {
    storePKTableEntityTable.header = header;
  }
  final List<dynamic>? rows = (json['rows'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (rows != null) {
    storePKTableEntityTable.rows = rows;
  }
  final dynamic total = json['total'];
  if (total != null) {
    storePKTableEntityTable.total = total;
  }
  return storePKTableEntityTable;
}

Map<String, dynamic> $StorePKTableEntityTableToJson(StorePKTableEntityTable entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['header'] = entity.header?.map((v) => v.toJson()).toList();
  data['rows'] = entity.rows;
  data['total'] = entity.total;
  return data;
}

extension StorePKTableEntityTableExtension on StorePKTableEntityTable {
  StorePKTableEntityTable copyWith({
    List<StorePKTableEntityTableHeader>? header,
    List<dynamic>? rows,
    dynamic total,
  }) {
    return StorePKTableEntityTable()
      ..header = header ?? this.header
      ..rows = rows ?? this.rows
      ..total = total ?? this.total;
  }
}

StorePKTableEntityTableHeader $StorePKTableEntityTableHeaderFromJson(Map<String, dynamic> json) {
  final StorePKTableEntityTableHeader storePKTableEntityTableHeader = StorePKTableEntityTableHeader();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    storePKTableEntityTableHeader.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    storePKTableEntityTableHeader.code = code;
  }
  return storePKTableEntityTableHeader;
}

Map<String, dynamic> $StorePKTableEntityTableHeaderToJson(StorePKTableEntityTableHeader entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  return data;
}

extension StorePKTableEntityTableHeaderExtension on StorePKTableEntityTableHeader {
  StorePKTableEntityTableHeader copyWith({
    String? name,
    String? code,
  }) {
    return StorePKTableEntityTableHeader()
      ..name = name ?? this.name
      ..code = code ?? this.code;
  }
}

StorePKTableEntityTableRows $StorePKTableEntityTableRowsFromJson(Map<String, dynamic> json) {
  final StorePKTableEntityTableRows storePKTableEntityTableRows = StorePKTableEntityTableRows();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    storePKTableEntityTableRows.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    storePKTableEntityTableRows.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    storePKTableEntityTableRows.displayValue = displayValue;
  }
  final ModuleMetricsCardDrillDownInfo? drillDownInfo = jsonConvert.convert<ModuleMetricsCardDrillDownInfo>(
      json['drillDownInfo']);
  if (drillDownInfo != null) {
    storePKTableEntityTableRows.drillDownInfo = drillDownInfo;
  }
  final ModuleMetricsCardCompValue? compValue = jsonConvert.convert<ModuleMetricsCardCompValue>(json['compValue']);
  if (compValue != null) {
    storePKTableEntityTableRows.compValue = compValue;
  }
  final List<StorePKTableEntityTableExtras>? extras = (json['extras'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StorePKTableEntityTableExtras>(e) as StorePKTableEntityTableExtras).toList();
  if (extras != null) {
    storePKTableEntityTableRows.extras = extras;
  }
  return storePKTableEntityTableRows;
}

Map<String, dynamic> $StorePKTableEntityTableRowsToJson(StorePKTableEntityTableRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  data['drillDownInfo'] = entity.drillDownInfo?.toJson();
  data['compValue'] = entity.compValue?.toJson();
  data['extras'] = entity.extras?.map((v) => v.toJson()).toList();
  return data;
}

extension StorePKTableEntityTableRowsExtension on StorePKTableEntityTableRows {
  StorePKTableEntityTableRows copyWith({
    String? code,
    String? value,
    String? displayValue,
    ModuleMetricsCardDrillDownInfo? drillDownInfo,
    ModuleMetricsCardCompValue? compValue,
    List<StorePKTableEntityTableExtras>? extras,
  }) {
    return StorePKTableEntityTableRows()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue
      ..drillDownInfo = drillDownInfo ?? this.drillDownInfo
      ..compValue = compValue ?? this.compValue
      ..extras = extras ?? this.extras;
  }
}

StorePKTableEntityTableExtras $StorePKTableEntityTableExtrasFromJson(Map<String, dynamic> json) {
  final StorePKTableEntityTableExtras storePKTableEntityTableExtras = StorePKTableEntityTableExtras();
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    storePKTableEntityTableExtras.displayValue = displayValue;
  }
  return storePKTableEntityTableExtras;
}

Map<String, dynamic> $StorePKTableEntityTableExtrasToJson(StorePKTableEntityTableExtras entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['displayValue'] = entity.displayValue;
  return data;
}

extension StorePKTableEntityTableExtrasExtension on StorePKTableEntityTableExtras {
  StorePKTableEntityTableExtras copyWith({
    String? displayValue,
  }) {
    return StorePKTableEntityTableExtras()
      ..displayValue = displayValue ?? this.displayValue;
  }
}

StorePKTableEntityTableTotal $StorePKTableEntityTableTotalFromJson(Map<String, dynamic> json) {
  final StorePKTableEntityTableTotal storePKTableEntityTableTotal = StorePKTableEntityTableTotal();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    storePKTableEntityTableTotal.code = code;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    storePKTableEntityTableTotal.value = value;
  }
  final String? displayValue = jsonConvert.convert<String>(json['displayValue']);
  if (displayValue != null) {
    storePKTableEntityTableTotal.displayValue = displayValue;
  }
  return storePKTableEntityTableTotal;
}

Map<String, dynamic> $StorePKTableEntityTableTotalToJson(StorePKTableEntityTableTotal entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['value'] = entity.value;
  data['displayValue'] = entity.displayValue;
  return data;
}

extension StorePKTableEntityTableTotalExtension on StorePKTableEntityTableTotal {
  StorePKTableEntityTableTotal copyWith({
    String? code,
    String? value,
    String? displayValue,
  }) {
    return StorePKTableEntityTableTotal()
      ..code = code ?? this.code
      ..value = value ?? this.value
      ..displayValue = displayValue ?? this.displayValue;
  }
}