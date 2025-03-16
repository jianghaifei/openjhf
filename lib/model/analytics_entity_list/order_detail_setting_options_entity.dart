import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/order_detail_setting_options_entity.g.dart';

export 'package:flutter_report_project/generated/json/order_detail_setting_options_entity.g.dart';

@JsonSerializable()
class OrderDetailSettingOptionsEntity {
  List<OrderDetailSettingOptionsOptions>? options;

  OrderDetailSettingOptionsEntity();

  factory OrderDetailSettingOptionsEntity.fromJson(Map<String, dynamic> json) =>
      $OrderDetailSettingOptionsEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailSettingOptionsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailSettingOptionsOptions {
  String? name;
  String? code;
  bool show = false;

  OrderDetailSettingOptionsOptions();

  factory OrderDetailSettingOptionsOptions.fromJson(Map<String, dynamic> json) =>
      $OrderDetailSettingOptionsOptionsFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailSettingOptionsOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
