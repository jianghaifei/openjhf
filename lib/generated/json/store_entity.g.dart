import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/store/store_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';


StoreEntity $StoreEntityFromJson(Map<String, dynamic> json) {
  final StoreEntity storeEntity = StoreEntity();
  final List<StoreShops>? shops = (json['shops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StoreShops>(e) as StoreShops).toList();
  if (shops != null) {
    storeEntity.shops = shops;
  }
  final List<StoreBrands>? brands = (json['brands'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StoreBrands>(e) as StoreBrands).toList();
  if (brands != null) {
    storeEntity.brands = brands;
  }
  final List<StoreCurrencyShops>? currencyShops = (json['currencyShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StoreCurrencyShops>(e) as StoreCurrencyShops).toList();
  if (currencyShops != null) {
    storeEntity.currencyShops = currencyShops;
  }
  final StoreSelectedGroupType? selectedGroupType = jsonConvert.convert<StoreSelectedGroupType>(
      json['selectedGroupType'], enumConvert: (v) => StoreSelectedGroupType.values.byName(v));
  if (selectedGroupType != null) {
    storeEntity.selectedGroupType = selectedGroupType;
  }
  return storeEntity;
}

Map<String, dynamic> $StoreEntityToJson(StoreEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shops'] = entity.shops?.map((v) => v.toJson()).toList();
  data['brands'] = entity.brands?.map((v) => v.toJson()).toList();
  data['currencyShops'] = entity.currencyShops?.map((v) => v.toJson()).toList();
  data['selectedGroupType'] = entity.selectedGroupType.name;
  return data;
}

extension StoreEntityExtension on StoreEntity {
  StoreEntity copyWith({
    List<StoreShops>? shops,
    List<StoreBrands>? brands,
    List<StoreCurrencyShops>? currencyShops,
    StoreSelectedGroupType? selectedGroupType,
  }) {
    return StoreEntity()
      ..shops = shops ?? this.shops
      ..brands = brands ?? this.brands
      ..currencyShops = currencyShops ?? this.currencyShops
      ..selectedGroupType = selectedGroupType ?? this.selectedGroupType;
  }
}

StoreShops $StoreShopsFromJson(Map<String, dynamic> json) {
  final StoreShops storeShops = StoreShops();
  final String? brandId = jsonConvert.convert<String>(json['brandId']);
  if (brandId != null) {
    storeShops.brandId = brandId;
  }
  final String? shopId = jsonConvert.convert<String>(json['shopId']);
  if (shopId != null) {
    storeShops.shopId = shopId;
  }
  final String? shopName = jsonConvert.convert<String>(json['shopName']);
  if (shopName != null) {
    storeShops.shopName = shopName;
  }
  return storeShops;
}

Map<String, dynamic> $StoreShopsToJson(StoreShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['brandId'] = entity.brandId;
  data['shopId'] = entity.shopId;
  data['shopName'] = entity.shopName;
  return data;
}

extension StoreShopsExtension on StoreShops {
  StoreShops copyWith({
    String? brandId,
    String? shopId,
    String? shopName,
  }) {
    return StoreShops()
      ..brandId = brandId ?? this.brandId
      ..shopId = shopId ?? this.shopId
      ..shopName = shopName ?? this.shopName;
  }
}

StoreBrands $StoreBrandsFromJson(Map<String, dynamic> json) {
  final StoreBrands storeBrands = StoreBrands();
  final String? brandId = jsonConvert.convert<String>(json['brandId']);
  if (brandId != null) {
    storeBrands.brandId = brandId;
  }
  final String? brandName = jsonConvert.convert<String>(json['brandName']);
  if (brandName != null) {
    storeBrands.brandName = brandName;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    storeBrands.isSelected = isSelected;
  }
  return storeBrands;
}

Map<String, dynamic> $StoreBrandsToJson(StoreBrands entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['brandId'] = entity.brandId;
  data['brandName'] = entity.brandName;
  data['isSelected'] = entity.isSelected;
  return data;
}

extension StoreBrandsExtension on StoreBrands {
  StoreBrands copyWith({
    String? brandId,
    String? brandName,
    bool? isSelected,
  }) {
    return StoreBrands()
      ..brandId = brandId ?? this.brandId
      ..brandName = brandName ?? this.brandName
      ..isSelected = isSelected ?? this.isSelected;
  }
}

StoreCurrencyShops $StoreCurrencyShopsFromJson(Map<String, dynamic> json) {
  final StoreCurrencyShops storeCurrencyShops = StoreCurrencyShops();
  final StoreCurrencyShopsCurrency? currency = jsonConvert.convert<StoreCurrencyShopsCurrency>(json['currency']);
  if (currency != null) {
    storeCurrencyShops.currency = currency;
  }
  final List<StoreCurrencyShopsGroupShops>? allShops = (json['allShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StoreCurrencyShopsGroupShops>(e) as StoreCurrencyShopsGroupShops).toList();
  if (allShops != null) {
    storeCurrencyShops.allShops = allShops;
  }
  final List<StoreCurrencyShopsGroupShops>? groupShops = (json['groupShops'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<StoreCurrencyShopsGroupShops>(e) as StoreCurrencyShopsGroupShops).toList();
  if (groupShops != null) {
    storeCurrencyShops.groupShops = groupShops;
  }
  return storeCurrencyShops;
}

Map<String, dynamic> $StoreCurrencyShopsToJson(StoreCurrencyShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currency'] = entity.currency?.toJson();
  data['allShops'] = entity.allShops?.map((v) => v.toJson()).toList();
  data['groupShops'] = entity.groupShops?.map((v) => v.toJson()).toList();
  return data;
}

extension StoreCurrencyShopsExtension on StoreCurrencyShops {
  StoreCurrencyShops copyWith({
    StoreCurrencyShopsCurrency? currency,
    List<StoreCurrencyShopsGroupShops>? allShops,
    List<StoreCurrencyShopsGroupShops>? groupShops,
  }) {
    return StoreCurrencyShops()
      ..currency = currency ?? this.currency
      ..allShops = allShops ?? this.allShops
      ..groupShops = groupShops ?? this.groupShops;
  }
}

StoreCurrencyShopsCurrency $StoreCurrencyShopsCurrencyFromJson(Map<String, dynamic> json) {
  final StoreCurrencyShopsCurrency storeCurrencyShopsCurrency = StoreCurrencyShopsCurrency();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    storeCurrencyShopsCurrency.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    storeCurrencyShopsCurrency.value = value;
  }
  final String? symbol = jsonConvert.convert<String>(json['symbol']);
  if (symbol != null) {
    storeCurrencyShopsCurrency.symbol = symbol;
  }
  return storeCurrencyShopsCurrency;
}

Map<String, dynamic> $StoreCurrencyShopsCurrencyToJson(StoreCurrencyShopsCurrency entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['symbol'] = entity.symbol;
  return data;
}

extension StoreCurrencyShopsCurrencyExtension on StoreCurrencyShopsCurrency {
  StoreCurrencyShopsCurrency copyWith({
    String? name,
    String? value,
    String? symbol,
  }) {
    return StoreCurrencyShopsCurrency()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..symbol = symbol ?? this.symbol;
  }
}

StoreCurrencyShopsGroupShops $StoreCurrencyShopsGroupShopsFromJson(Map<String, dynamic> json) {
  final StoreCurrencyShopsGroupShops storeCurrencyShopsGroupShops = StoreCurrencyShopsGroupShops();
  final StoreCurrencyShopsGroupShopsShopGroup? shopGroup = jsonConvert.convert<StoreCurrencyShopsGroupShopsShopGroup>(
      json['shopGroup']);
  if (shopGroup != null) {
    storeCurrencyShopsGroupShops.shopGroup = shopGroup;
  }
  final List<StoreCurrencyShopsGroupShopsBrandShops>? brandShops = (json['brandShops'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<StoreCurrencyShopsGroupShopsBrandShops>(e) as StoreCurrencyShopsGroupShopsBrandShops)
      .toList();
  if (brandShops != null) {
    storeCurrencyShopsGroupShops.brandShops = brandShops;
  }
  final bool? isAllSelected = jsonConvert.convert<bool>(json['isAllSelected']);
  if (isAllSelected != null) {
    storeCurrencyShopsGroupShops.isAllSelected = isAllSelected;
  }
  return storeCurrencyShopsGroupShops;
}

Map<String, dynamic> $StoreCurrencyShopsGroupShopsToJson(StoreCurrencyShopsGroupShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopGroup'] = entity.shopGroup?.toJson();
  data['brandShops'] = entity.brandShops?.map((v) => v.toJson()).toList();
  data['isAllSelected'] = entity.isAllSelected;
  return data;
}

extension StoreCurrencyShopsGroupShopsExtension on StoreCurrencyShopsGroupShops {
  StoreCurrencyShopsGroupShops copyWith({
    StoreCurrencyShopsGroupShopsShopGroup? shopGroup,
    List<StoreCurrencyShopsGroupShopsBrandShops>? brandShops,
    bool? isAllSelected,
  }) {
    return StoreCurrencyShopsGroupShops()
      ..shopGroup = shopGroup ?? this.shopGroup
      ..brandShops = brandShops ?? this.brandShops
      ..isAllSelected = isAllSelected ?? this.isAllSelected;
  }
}

StoreCurrencyShopsGroupShopsShopGroup $StoreCurrencyShopsGroupShopsShopGroupFromJson(Map<String, dynamic> json) {
  final StoreCurrencyShopsGroupShopsShopGroup storeCurrencyShopsGroupShopsShopGroup = StoreCurrencyShopsGroupShopsShopGroup();
  final String? shopGroupId = jsonConvert.convert<String>(json['shopGroupId']);
  if (shopGroupId != null) {
    storeCurrencyShopsGroupShopsShopGroup.shopGroupId = shopGroupId;
  }
  final String? shopGroupName = jsonConvert.convert<String>(json['shopGroupName']);
  if (shopGroupName != null) {
    storeCurrencyShopsGroupShopsShopGroup.shopGroupName = shopGroupName;
  }
  return storeCurrencyShopsGroupShopsShopGroup;
}

Map<String, dynamic> $StoreCurrencyShopsGroupShopsShopGroupToJson(StoreCurrencyShopsGroupShopsShopGroup entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['shopGroupId'] = entity.shopGroupId;
  data['shopGroupName'] = entity.shopGroupName;
  return data;
}

extension StoreCurrencyShopsGroupShopsShopGroupExtension on StoreCurrencyShopsGroupShopsShopGroup {
  StoreCurrencyShopsGroupShopsShopGroup copyWith({
    String? shopGroupId,
    String? shopGroupName,
  }) {
    return StoreCurrencyShopsGroupShopsShopGroup()
      ..shopGroupId = shopGroupId ?? this.shopGroupId
      ..shopGroupName = shopGroupName ?? this.shopGroupName;
  }
}

StoreCurrencyShopsGroupShopsBrandShops $StoreCurrencyShopsGroupShopsBrandShopsFromJson(Map<String, dynamic> json) {
  final StoreCurrencyShopsGroupShopsBrandShops storeCurrencyShopsGroupShopsBrandShops = StoreCurrencyShopsGroupShopsBrandShops();
  final String? brandId = jsonConvert.convert<String>(json['brandId']);
  if (brandId != null) {
    storeCurrencyShopsGroupShopsBrandShops.brandId = brandId;
  }
  final String? shopId = jsonConvert.convert<String>(json['shopId']);
  if (shopId != null) {
    storeCurrencyShopsGroupShopsBrandShops.shopId = shopId;
  }
  final String? shopName = jsonConvert.convert<String>(json['shopName']);
  if (shopName != null) {
    storeCurrencyShopsGroupShopsBrandShops.shopName = shopName;
  }
  final bool? isSelected = jsonConvert.convert<bool>(json['isSelected']);
  if (isSelected != null) {
    storeCurrencyShopsGroupShopsBrandShops.isSelected = isSelected;
  }
  final bool? isEditable = jsonConvert.convert<bool>(json['isEditable']);
  if (isEditable != null) {
    storeCurrencyShopsGroupShopsBrandShops.isEditable = isEditable;
  }
  return storeCurrencyShopsGroupShopsBrandShops;
}

Map<String, dynamic> $StoreCurrencyShopsGroupShopsBrandShopsToJson(StoreCurrencyShopsGroupShopsBrandShops entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['brandId'] = entity.brandId;
  data['shopId'] = entity.shopId;
  data['shopName'] = entity.shopName;
  data['isSelected'] = entity.isSelected;
  data['isEditable'] = entity.isEditable;
  return data;
}

extension StoreCurrencyShopsGroupShopsBrandShopsExtension on StoreCurrencyShopsGroupShopsBrandShops {
  StoreCurrencyShopsGroupShopsBrandShops copyWith({
    String? brandId,
    String? shopId,
    String? shopName,
    bool? isSelected,
    bool? isEditable,
  }) {
    return StoreCurrencyShopsGroupShopsBrandShops()
      ..brandId = brandId ?? this.brandId
      ..shopId = shopId ?? this.shopId
      ..shopName = shopName ?? this.shopName
      ..isSelected = isSelected ?? this.isSelected
      ..isEditable = isEditable ?? this.isEditable;
  }
}