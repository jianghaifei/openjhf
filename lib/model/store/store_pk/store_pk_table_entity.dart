import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/store_pk_table_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';

@JsonSerializable()
class StorePKTableEntity {
  StorePKTableEntityTable? table;

  StorePKTableEntity();

  factory StorePKTableEntity.fromJson(Map<String, dynamic> json) => $StorePKTableEntityFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKTableEntityTable {
  List<StorePKTableEntityTableHeader>? header;
  List<dynamic>? rows;
  dynamic total;

  StorePKTableEntityTable();

  factory StorePKTableEntityTable.fromJson(Map<String, dynamic> json) => $StorePKTableEntityTableFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityTableToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKTableEntityTableHeader {
  String? name;
  String? code;

  StorePKTableEntityTableHeader();

  factory StorePKTableEntityTableHeader.fromJson(Map<String, dynamic> json) =>
      $StorePKTableEntityTableHeaderFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityTableHeaderToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKTableEntityTableRows {
  String? code;
  String? value;
  String? displayValue;

  // 下转实体
  ModuleMetricsCardDrillDownInfo? drillDownInfo;
  ModuleMetricsCardCompValue? compValue;

  // 附加信息
  List<StorePKTableEntityTableExtras>? extras;

  StorePKTableEntityTableRows();

  factory StorePKTableEntityTableRows.fromJson(Map<String, dynamic> json) => $StorePKTableEntityTableRowsFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityTableRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKTableEntityTableExtras {
  // 展示值
  String? displayValue;

  StorePKTableEntityTableExtras();

  factory StorePKTableEntityTableExtras.fromJson(Map<String, dynamic> json) =>
      $StorePKTableEntityTableExtrasFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityTableExtrasToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StorePKTableEntityTableTotal {
  String? code;
  String? value;
  String? displayValue;

  StorePKTableEntityTableTotal();

  factory StorePKTableEntityTableTotal.fromJson(Map<String, dynamic> json) =>
      $StorePKTableEntityTableTotalFromJson(json);

  Map<String, dynamic> toJson() => $StorePKTableEntityTableTotalToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
