import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/location/location_module_entity.dart';

LocationModuleEntity $LocationModuleEntityFromJson(Map<String, dynamic> json) {
  final LocationModuleEntity locationModuleEntity = LocationModuleEntity();
  final List<LocationModuleShops>? shops = (json['shops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LocationModuleShops>(e) as LocationModuleShops).toList();
  if (shops != null) {
    locationModuleEntity.shops = shops;
  }
  final List<LocationModuleCurrencyShops>? currencyShops = (json['currencyShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LocationModuleCurrencyShops>(e) as LocationModuleCurrencyShops).toList();
  if (currencyShops != null) {
    locationModuleEntity.currencyShops = currencyShops;
  }
  final List<LocationModuleBrandShops>? brandShops = (json['brandShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LocationModuleBrandShops>(e) as LocationModuleBrandShops).toList();
  if (brandShops != null) {
    locationModuleEntity.brandShops = brandShops;
  }
  final List<LocationModuleGroupShops>? groupShops = (json['groupShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LocationModuleGroupShops>(e) as LocationModuleGroupShops).toList();
  if (groupShops != null) {
    locationModuleEntity.groupShops = groupShops;
  }
  return locationModuleEntity;
}

Map<String, dynamic> $LocationModuleEntityToJson(LocationModuleEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shops'] = entity.shops?.map((v) => v.toJson()).toList();
  data['currencyShops'] = entity.currencyShops?.map((v) => v.toJson()).toList();
  data['brandShops'] = entity.brandShops?.map((v) => v.toJson()).toList();
  data['groupShops'] = entity.groupShops?.map((v) => v.toJson()).toList();
  return data;
}

extension LocationModuleEntityExtension on LocationModuleEntity {
  LocationModuleEntity copyWith({
    List<LocationModuleShops>? shops,
    List<LocationModuleCurrencyShops>? currencyShops,
    List<LocationModuleBrandShops>? brandShops,
    List<LocationModuleGroupShops>? groupShops,
  }) {
    return LocationModuleEntity()
      ..shops = shops ?? this.shops
      ..currencyShops = currencyShops ?? this.currencyShops
      ..brandShops = brandShops ?? this.brandShops
      ..groupShops = groupShops ?? this.groupShops;
  }
}

LocationModuleShops $LocationModuleShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleShops locationModuleShops = LocationModuleShops();
  final String? shopId = jsonConvert.convert<String>(json['shopId']);
  if (shopId != null) {
    locationModuleShops.shopId = shopId;
  }
  final String? shopName = jsonConvert.convert<String>(json['shopName']);
  if (shopName != null) {
    locationModuleShops.shopName = shopName;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    locationModuleShops.isSelected = isSelected;
  }
  return locationModuleShops;
}

Map<String, dynamic> $LocationModuleShopsToJson(LocationModuleShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopId'] = entity.shopId;
  data['shopName'] = entity.shopName;
  data['isSelected'] = entity.isSelected;
  return data;
}

extension LocationModuleShopsExtension on LocationModuleShops {
  LocationModuleShops copyWith({
    String? shopId,
    String? shopName,
    bool? isSelected,
  }) {
    return LocationModuleShops()
      ..shopId = shopId ?? this.shopId
      ..shopName = shopName ?? this.shopName
      ..isSelected = isSelected ?? this.isSelected;
  }
}

LocationModuleCurrencyShops $LocationModuleCurrencyShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleCurrencyShops locationModuleCurrencyShops = LocationModuleCurrencyShops();
  final LocationModuleCurrencyShopsCurrency? currency = jsonConvert.convert<LocationModuleCurrencyShopsCurrency>(
      json['currency']);
  if (currency != null) {
    locationModuleCurrencyShops.currency = currency;
  }
  final List<String>? shopIds = (json['shopIds'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (shopIds != null) {
    locationModuleCurrencyShops.shopIds = shopIds;
  }
  return locationModuleCurrencyShops;
}

Map<String, dynamic> $LocationModuleCurrencyShopsToJson(LocationModuleCurrencyShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currency'] = entity.currency?.toJson();
  data['shopIds'] = entity.shopIds;
  return data;
}

extension LocationModuleCurrencyShopsExtension on LocationModuleCurrencyShops {
  LocationModuleCurrencyShops copyWith({
    LocationModuleCurrencyShopsCurrency? currency,
    List<String>? shopIds,
  }) {
    return LocationModuleCurrencyShops()
      ..currency = currency ?? this.currency
      ..shopIds = shopIds ?? this.shopIds;
  }
}

LocationModuleCurrencyShopsCurrency $LocationModuleCurrencyShopsCurrencyFromJson(Map<String, dynamic> json) {
  final LocationModuleCurrencyShopsCurrency locationModuleCurrencyShopsCurrency = LocationModuleCurrencyShopsCurrency();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    locationModuleCurrencyShopsCurrency.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    locationModuleCurrencyShopsCurrency.value = value;
  }
  final String? symbol = jsonConvert.convert<String>(json['symbol']);
  if (symbol != null) {
    locationModuleCurrencyShopsCurrency.symbol = symbol;
  }
  return locationModuleCurrencyShopsCurrency;
}

Map<String, dynamic> $LocationModuleCurrencyShopsCurrencyToJson(LocationModuleCurrencyShopsCurrency entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['symbol'] = entity.symbol;
  return data;
}

extension LocationModuleCurrencyShopsCurrencyExtension on LocationModuleCurrencyShopsCurrency {
  LocationModuleCurrencyShopsCurrency copyWith({
    String? name,
    String? value,
    String? symbol,
  }) {
    return LocationModuleCurrencyShopsCurrency()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..symbol = symbol ?? this.symbol;
  }
}

LocationModuleBrandShops $LocationModuleBrandShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleBrandShops locationModuleBrandShops = LocationModuleBrandShops();
  final LocationModuleBrandShopsBrand? brand = jsonConvert.convert<LocationModuleBrandShopsBrand>(json['brand']);
  if (brand != null) {
    locationModuleBrandShops.brand = brand;
  }
  final List<LocationModuleBrandShopsCurrencyShops>? currencyShops = (json['currencyShops'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<LocationModuleBrandShopsCurrencyShops>(e) as LocationModuleBrandShopsCurrencyShops)
      .toList();
  if (currencyShops != null) {
    locationModuleBrandShops.currencyShops = currencyShops;
  }
  return locationModuleBrandShops;
}

Map<String, dynamic> $LocationModuleBrandShopsToJson(LocationModuleBrandShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['brand'] = entity.brand?.toJson();
  data['currencyShops'] = entity.currencyShops?.map((v) => v.toJson()).toList();
  return data;
}

extension LocationModuleBrandShopsExtension on LocationModuleBrandShops {
  LocationModuleBrandShops copyWith({
    LocationModuleBrandShopsBrand? brand,
    List<LocationModuleBrandShopsCurrencyShops>? currencyShops,
  }) {
    return LocationModuleBrandShops()
      ..brand = brand ?? this.brand
      ..currencyShops = currencyShops ?? this.currencyShops;
  }
}

LocationModuleBrandShopsBrand $LocationModuleBrandShopsBrandFromJson(Map<String, dynamic> json) {
  final LocationModuleBrandShopsBrand locationModuleBrandShopsBrand = LocationModuleBrandShopsBrand();
  final String? brandId = jsonConvert.convert<String>(json['brandId']);
  if (brandId != null) {
    locationModuleBrandShopsBrand.brandId = brandId;
  }
  final String? brandName = jsonConvert.convert<String>(json['brandName']);
  if (brandName != null) {
    locationModuleBrandShopsBrand.brandName = brandName;
  }
  return locationModuleBrandShopsBrand;
}

Map<String, dynamic> $LocationModuleBrandShopsBrandToJson(LocationModuleBrandShopsBrand entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['brandId'] = entity.brandId;
  data['brandName'] = entity.brandName;
  return data;
}

extension LocationModuleBrandShopsBrandExtension on LocationModuleBrandShopsBrand {
  LocationModuleBrandShopsBrand copyWith({
    String? brandId,
    String? brandName,
  }) {
    return LocationModuleBrandShopsBrand()
      ..brandId = brandId ?? this.brandId
      ..brandName = brandName ?? this.brandName;
  }
}

LocationModuleBrandShopsCurrencyShops $LocationModuleBrandShopsCurrencyShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleBrandShopsCurrencyShops locationModuleBrandShopsCurrencyShops = LocationModuleBrandShopsCurrencyShops();
  final LocationModuleBrandShopsCurrencyShopsCurrency? currency = jsonConvert.convert<
      LocationModuleBrandShopsCurrencyShopsCurrency>(json['currency']);
  if (currency != null) {
    locationModuleBrandShopsCurrencyShops.currency = currency;
  }
  final List<String>? shopIds = (json['shopIds'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (shopIds != null) {
    locationModuleBrandShopsCurrencyShops.shopIds = shopIds;
  }
  return locationModuleBrandShopsCurrencyShops;
}

Map<String, dynamic> $LocationModuleBrandShopsCurrencyShopsToJson(LocationModuleBrandShopsCurrencyShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currency'] = entity.currency?.toJson();
  data['shopIds'] = entity.shopIds;
  return data;
}

extension LocationModuleBrandShopsCurrencyShopsExtension on LocationModuleBrandShopsCurrencyShops {
  LocationModuleBrandShopsCurrencyShops copyWith({
    LocationModuleBrandShopsCurrencyShopsCurrency? currency,
    List<String>? shopIds,
  }) {
    return LocationModuleBrandShopsCurrencyShops()
      ..currency = currency ?? this.currency
      ..shopIds = shopIds ?? this.shopIds;
  }
}

LocationModuleBrandShopsCurrencyShopsCurrency $LocationModuleBrandShopsCurrencyShopsCurrencyFromJson(
    Map<String, dynamic> json) {
  final LocationModuleBrandShopsCurrencyShopsCurrency locationModuleBrandShopsCurrencyShopsCurrency = LocationModuleBrandShopsCurrencyShopsCurrency();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    locationModuleBrandShopsCurrencyShopsCurrency.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    locationModuleBrandShopsCurrencyShopsCurrency.value = value;
  }
  final String? symbol = jsonConvert.convert<String>(json['symbol']);
  if (symbol != null) {
    locationModuleBrandShopsCurrencyShopsCurrency.symbol = symbol;
  }
  return locationModuleBrandShopsCurrencyShopsCurrency;
}

Map<String, dynamic> $LocationModuleBrandShopsCurrencyShopsCurrencyToJson(
    LocationModuleBrandShopsCurrencyShopsCurrency entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['symbol'] = entity.symbol;
  return data;
}

extension LocationModuleBrandShopsCurrencyShopsCurrencyExtension on LocationModuleBrandShopsCurrencyShopsCurrency {
  LocationModuleBrandShopsCurrencyShopsCurrency copyWith({
    String? name,
    String? value,
    String? symbol,
  }) {
    return LocationModuleBrandShopsCurrencyShopsCurrency()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..symbol = symbol ?? this.symbol;
  }
}

LocationModuleGroupShops $LocationModuleGroupShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleGroupShops locationModuleGroupShops = LocationModuleGroupShops();
  final LocationModuleGroupShopsShopGroup? shopGroup = jsonConvert.convert<LocationModuleGroupShopsShopGroup>(
      json['shopGroup']);
  if (shopGroup != null) {
    locationModuleGroupShops.shopGroup = shopGroup;
  }
  final List<LocationModuleGroupShopsCurrencyShops>? currencyShops = (json['currencyShops'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<LocationModuleGroupShopsCurrencyShops>(e) as LocationModuleGroupShopsCurrencyShops)
      .toList();
  if (currencyShops != null) {
    locationModuleGroupShops.currencyShops = currencyShops;
  }
  return locationModuleGroupShops;
}

Map<String, dynamic> $LocationModuleGroupShopsToJson(LocationModuleGroupShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopGroup'] = entity.shopGroup?.toJson();
  data['currencyShops'] = entity.currencyShops?.map((v) => v.toJson()).toList();
  return data;
}

extension LocationModuleGroupShopsExtension on LocationModuleGroupShops {
  LocationModuleGroupShops copyWith({
    LocationModuleGroupShopsShopGroup? shopGroup,
    List<LocationModuleGroupShopsCurrencyShops>? currencyShops,
  }) {
    return LocationModuleGroupShops()
      ..shopGroup = shopGroup ?? this.shopGroup
      ..currencyShops = currencyShops ?? this.currencyShops;
  }
}

LocationModuleGroupShopsShopGroup $LocationModuleGroupShopsShopGroupFromJson(Map<String, dynamic> json) {
  final LocationModuleGroupShopsShopGroup locationModuleGroupShopsShopGroup = LocationModuleGroupShopsShopGroup();
  final String? shopGroupId = jsonConvert.convert<String>(json['shopGroupId']);
  if (shopGroupId != null) {
    locationModuleGroupShopsShopGroup.shopGroupId = shopGroupId;
  }
  final String? shopGroupName = jsonConvert.convert<String>(json['shopGroupName']);
  if (shopGroupName != null) {
    locationModuleGroupShopsShopGroup.shopGroupName = shopGroupName;
  }
  return locationModuleGroupShopsShopGroup;
}

Map<String, dynamic> $LocationModuleGroupShopsShopGroupToJson(LocationModuleGroupShopsShopGroup entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopGroupId'] = entity.shopGroupId;
  data['shopGroupName'] = entity.shopGroupName;
  return data;
}

extension LocationModuleGroupShopsShopGroupExtension on LocationModuleGroupShopsShopGroup {
  LocationModuleGroupShopsShopGroup copyWith({
    String? shopGroupId,
    String? shopGroupName,
  }) {
    return LocationModuleGroupShopsShopGroup()
      ..shopGroupId = shopGroupId ?? this.shopGroupId
      ..shopGroupName = shopGroupName ?? this.shopGroupName;
  }
}

LocationModuleGroupShopsCurrencyShops $LocationModuleGroupShopsCurrencyShopsFromJson(Map<String, dynamic> json) {
  final LocationModuleGroupShopsCurrencyShops locationModuleGroupShopsCurrencyShops = LocationModuleGroupShopsCurrencyShops();
  final LocationModuleGroupShopsCurrencyShopsCurrency? currency = jsonConvert.convert<
      LocationModuleGroupShopsCurrencyShopsCurrency>(json['currency']);
  if (currency != null) {
    locationModuleGroupShopsCurrencyShops.currency = currency;
  }
  final List<String>? shopIds = (json['shopIds'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (shopIds != null) {
    locationModuleGroupShopsCurrencyShops.shopIds = shopIds;
  }
  return locationModuleGroupShopsCurrencyShops;
}

Map<String, dynamic> $LocationModuleGroupShopsCurrencyShopsToJson(LocationModuleGroupShopsCurrencyShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currency'] = entity.currency?.toJson();
  data['shopIds'] = entity.shopIds;
  return data;
}

extension LocationModuleGroupShopsCurrencyShopsExtension on LocationModuleGroupShopsCurrencyShops {
  LocationModuleGroupShopsCurrencyShops copyWith({
    LocationModuleGroupShopsCurrencyShopsCurrency? currency,
    List<String>? shopIds,
  }) {
    return LocationModuleGroupShopsCurrencyShops()
      ..currency = currency ?? this.currency
      ..shopIds = shopIds ?? this.shopIds;
  }
}

LocationModuleGroupShopsCurrencyShopsCurrency $LocationModuleGroupShopsCurrencyShopsCurrencyFromJson(
    Map<String, dynamic> json) {
  final LocationModuleGroupShopsCurrencyShopsCurrency locationModuleGroupShopsCurrencyShopsCurrency = LocationModuleGroupShopsCurrencyShopsCurrency();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    locationModuleGroupShopsCurrencyShopsCurrency.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    locationModuleGroupShopsCurrencyShopsCurrency.value = value;
  }
  final String? symbol = jsonConvert.convert<String>(json['symbol']);
  if (symbol != null) {
    locationModuleGroupShopsCurrencyShopsCurrency.symbol = symbol;
  }
  return locationModuleGroupShopsCurrencyShopsCurrency;
}

Map<String, dynamic> $LocationModuleGroupShopsCurrencyShopsCurrencyToJson(
    LocationModuleGroupShopsCurrencyShopsCurrency entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['symbol'] = entity.symbol;
  return data;
}

extension LocationModuleGroupShopsCurrencyShopsCurrencyExtension on LocationModuleGroupShopsCurrencyShopsCurrency {
  LocationModuleGroupShopsCurrencyShopsCurrency copyWith({
    String? name,
    String? value,
    String? symbol,
  }) {
    return LocationModuleGroupShopsCurrencyShopsCurrency()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..symbol = symbol ?? this.symbol;
  }
}