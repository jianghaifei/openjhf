import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/store_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class StoreEntity {
  // 门店信息
  List<StoreShops>? shops;

  // 品牌信息
  List<StoreBrands>? brands;

  // 货币门店信息
  List<StoreCurrencyShops>? currencyShops;

  // 当前选中的分组类型，allType:全部，groupType:分组
  @JSONField(isEnum: true)
  StoreSelectedGroupType selectedGroupType = StoreSelectedGroupType.allType;

  StoreEntity();

  factory StoreEntity.fromJson(Map<String, dynamic> json) => $StoreEntityFromJson(json);

  Map<String, dynamic> toJson() => $StoreEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreShops {
  String? brandId;
  String? shopId;
  String? shopName;

  StoreShops();

  factory StoreShops.fromJson(Map<String, dynamic> json) => $StoreShopsFromJson(json);

  Map<String, dynamic> toJson() => $StoreShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreBrands {
  String? brandId;
  String? brandName;

  // 是否选中——自用字段(品牌默认全选)
  bool isSelected = false;

  StoreBrands();

  factory StoreBrands.fromJson(Map<String, dynamic> json) => $StoreBrandsFromJson(json);

  Map<String, dynamic> toJson() => $StoreBrandsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreCurrencyShops {
  // 货币信息
  StoreCurrencyShopsCurrency? currency;

  // 全部
  List<StoreCurrencyShopsGroupShops>? allShops;

  // 分组
  List<StoreCurrencyShopsGroupShops>? groupShops;

  StoreCurrencyShops();

  factory StoreCurrencyShops.fromJson(Map<String, dynamic> json) => $StoreCurrencyShopsFromJson(json);

  Map<String, dynamic> toJson() => $StoreCurrencyShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreCurrencyShopsCurrency {
  String? name;
  String? value;
  String? symbol;

  StoreCurrencyShopsCurrency();

  factory StoreCurrencyShopsCurrency.fromJson(Map<String, dynamic> json) => $StoreCurrencyShopsCurrencyFromJson(json);

  Map<String, dynamic> toJson() => $StoreCurrencyShopsCurrencyToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreCurrencyShopsGroupShops {
  StoreCurrencyShopsGroupShopsShopGroup? shopGroup;
  List<StoreCurrencyShopsGroupShopsBrandShops>? brandShops;

  // 当前分组是否全选——自用字段
  bool isAllSelected = false;

  StoreCurrencyShopsGroupShops();

  factory StoreCurrencyShopsGroupShops.fromJson(Map<String, dynamic> json) =>
      $StoreCurrencyShopsGroupShopsFromJson(json);

  Map<String, dynamic> toJson() => $StoreCurrencyShopsGroupShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreCurrencyShopsGroupShopsShopGroup {
  String? shopGroupId;
  String? shopGroupName;

  StoreCurrencyShopsGroupShopsShopGroup();

  factory StoreCurrencyShopsGroupShopsShopGroup.fromJson(Map<String, dynamic> json) =>
      $StoreCurrencyShopsGroupShopsShopGroupFromJson(json);

  Map<String, dynamic> toJson() => $StoreCurrencyShopsGroupShopsShopGroupToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreCurrencyShopsGroupShopsBrandShops {
  String? brandId;
  String? shopId;
  String? shopName;

  // 当前门店是否选中——自用字段
  bool isSelected = false;

  // 是否可编辑——自用字段
  bool isEditable = true;

  StoreCurrencyShopsGroupShopsBrandShops();

  factory StoreCurrencyShopsGroupShopsBrandShops.fromJson(Map<String, dynamic> json) =>
      $StoreCurrencyShopsGroupShopsBrandShopsFromJson(json);

  Map<String, dynamic> toJson() => $StoreCurrencyShopsGroupShopsBrandShopsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
