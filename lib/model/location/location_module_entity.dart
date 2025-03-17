import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/location_module_entity.g.dart';

export 'package:flutter_report_project/generated/json/location_module_entity.g.dart';

@JsonSerializable()
class LocationModuleEntity {
  List<LocationModuleShops>? shops;
  List<LocationModuleCurrencyShops>? currencyShops;
  List<LocationModuleBrandShops>? brandShops;
  List<LocationModuleGroupShops>? groupShops;

  LocationModuleEntity();

  factory LocationModuleEntity.fromJson(Map<String, dynamic> json) => $LocationModuleEntityFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleShops {
  String? shopId;
  String? shopName;

  // 是否选中——自定义字段
  bool isSelected = false;

  LocationModuleShops();

  factory LocationModuleShops.fromJson(Map<String, dynamic> json) => $LocationModuleShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleCurrencyShops {
  LocationModuleCurrencyShopsCurrency? currency;
  List<String>? shopIds;

  LocationModuleCurrencyShops();

  factory LocationModuleCurrencyShops.fromJson(Map<String, dynamic> json) => $LocationModuleCurrencyShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleCurrencyShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleCurrencyShopsCurrency {
  String? name;
  String? value;
  String? symbol;

  LocationModuleCurrencyShopsCurrency();

  factory LocationModuleCurrencyShopsCurrency.fromJson(Map<String, dynamic> json) =>
      $LocationModuleCurrencyShopsCurrencyFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleCurrencyShopsCurrencyToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleBrandShops {
  LocationModuleBrandShopsBrand? brand;
  List<LocationModuleBrandShopsCurrencyShops>? currencyShops;

  LocationModuleBrandShops();

  factory LocationModuleBrandShops.fromJson(Map<String, dynamic> json) => $LocationModuleBrandShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleBrandShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleBrandShopsBrand {
  String? brandId;
  String? brandName;

  LocationModuleBrandShopsBrand();

  factory LocationModuleBrandShopsBrand.fromJson(Map<String, dynamic> json) =>
      $LocationModuleBrandShopsBrandFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleBrandShopsBrandToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleBrandShopsCurrencyShops {
  LocationModuleBrandShopsCurrencyShopsCurrency? currency;
  List<String>? shopIds;

  LocationModuleBrandShopsCurrencyShops();

  factory LocationModuleBrandShopsCurrencyShops.fromJson(Map<String, dynamic> json) =>
      $LocationModuleBrandShopsCurrencyShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleBrandShopsCurrencyShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleBrandShopsCurrencyShopsCurrency {
  String? name;
  String? value;
  String? symbol;

  LocationModuleBrandShopsCurrencyShopsCurrency();

  factory LocationModuleBrandShopsCurrencyShopsCurrency.fromJson(Map<String, dynamic> json) =>
      $LocationModuleBrandShopsCurrencyShopsCurrencyFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleBrandShopsCurrencyShopsCurrencyToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleGroupShops {
  LocationModuleGroupShopsShopGroup? shopGroup;
  List<LocationModuleGroupShopsCurrencyShops>? currencyShops;

  LocationModuleGroupShops();

  factory LocationModuleGroupShops.fromJson(Map<String, dynamic> json) => $LocationModuleGroupShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleGroupShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleGroupShopsShopGroup {
  String? shopGroupId;
  String? shopGroupName;

  LocationModuleGroupShopsShopGroup();

  factory LocationModuleGroupShopsShopGroup.fromJson(Map<String, dynamic> json) =>
      $LocationModuleGroupShopsShopGroupFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleGroupShopsShopGroupToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleGroupShopsCurrencyShops {
  LocationModuleGroupShopsCurrencyShopsCurrency? currency;
  List<String>? shopIds;

  LocationModuleGroupShopsCurrencyShops();

  factory LocationModuleGroupShopsCurrencyShops.fromJson(Map<String, dynamic> json) =>
      $LocationModuleGroupShopsCurrencyShopsFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleGroupShopsCurrencyShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationModuleGroupShopsCurrencyShopsCurrency {
  String? name;
  String? value;
  String? symbol;

  LocationModuleGroupShopsCurrencyShopsCurrency();

  factory LocationModuleGroupShopsCurrencyShopsCurrency.fromJson(Map<String, dynamic> json) =>
      $LocationModuleGroupShopsCurrencyShopsCurrencyFromJson(json);

  Map<String, dynamic> toJson() => $LocationModuleGroupShopsCurrencyShopsCurrencyToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
