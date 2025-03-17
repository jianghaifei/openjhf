import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/target_manage_shops_entity.g.dart';

export 'package:flutter_report_project/generated/json/target_manage_shops_entity.g.dart';

@JsonSerializable()
class TargetManageShopsEntity {
  List<TargetManageShopsCurrencyShop>? currencyShop;

  TargetManageShopsEntity();

  factory TargetManageShopsEntity.fromJson(Map<String, dynamic> json) => $TargetManageShopsEntityFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageShopsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TargetManageShopsCurrencyShop {
  // 货币
  String? currency;
  // 选中可以修改
  List<String>? currentConfigShopIds;
  // 选中不能修改
  List<String>? relatedConfigShopIds;
  // 从数据源中直接移除
  List<String>? unconfigurableShopIds;

  TargetManageShopsCurrencyShop();

  factory TargetManageShopsCurrencyShop.fromJson(Map<String, dynamic> json) =>
      $TargetManageShopsCurrencyShopFromJson(json);

  Map<String, dynamic> toJson() => $TargetManageShopsCurrencyShopToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
