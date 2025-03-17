import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/target_manage/target_manage_shops_entity.dart';

TargetManageShopsEntity $TargetManageShopsEntityFromJson(Map<String, dynamic> json) {
  final TargetManageShopsEntity targetManageShopsEntity = TargetManageShopsEntity();
  final List<TargetManageShopsCurrencyShop>? currencyShop = (json['currencyShop'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<TargetManageShopsCurrencyShop>(e) as TargetManageShopsCurrencyShop)
      .toList();
  if (currencyShop != null) {
    targetManageShopsEntity.currencyShop = currencyShop;
  }
  return targetManageShopsEntity;
}

Map<String, dynamic> $TargetManageShopsEntityToJson(TargetManageShopsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currencyShop'] = entity.currencyShop?.map((v) => v.toJson()).toList();
  return data;
}

extension TargetManageShopsEntityExtension on TargetManageShopsEntity {
  TargetManageShopsEntity copyWith({
    List<TargetManageShopsCurrencyShop>? currencyShop,
  }) {
    return TargetManageShopsEntity()..currencyShop = currencyShop ?? this.currencyShop;
  }
}

TargetManageShopsCurrencyShop $TargetManageShopsCurrencyShopFromJson(Map<String, dynamic> json) {
  final TargetManageShopsCurrencyShop targetManageShopsCurrencyShop = TargetManageShopsCurrencyShop();
  final String? currency = jsonConvert.convert<String>(json['currency']);
  if (currency != null) {
    targetManageShopsCurrencyShop.currency = currency;
  }
  final List<String>? currentConfigShopIds =
      (json['currentConfigShopIds'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (currentConfigShopIds != null) {
    targetManageShopsCurrencyShop.currentConfigShopIds = currentConfigShopIds;
  }
  final List<String>? relatedConfigShopIds =
      (json['relatedConfigShopIds'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (relatedConfigShopIds != null) {
    targetManageShopsCurrencyShop.relatedConfigShopIds = relatedConfigShopIds;
  }
  final List<String>? unconfigurableShopIds =
      (json['unconfigurableShopIds'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (unconfigurableShopIds != null) {
    targetManageShopsCurrencyShop.unconfigurableShopIds = unconfigurableShopIds;
  }
  return targetManageShopsCurrencyShop;
}

Map<String, dynamic> $TargetManageShopsCurrencyShopToJson(TargetManageShopsCurrencyShop entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currency'] = entity.currency;
  data['currentConfigShopIds'] = entity.currentConfigShopIds;
  data['relatedConfigShopIds'] = entity.relatedConfigShopIds;
  data['unconfigurableShopIds'] = entity.unconfigurableShopIds;
  return data;
}

extension TargetManageShopsCurrencyShopExtension on TargetManageShopsCurrencyShop {
  TargetManageShopsCurrencyShop copyWith({
    String? currency,
    List<String>? currentConfigShopIds,
    List<String>? relatedConfigShopIds,
    List<String>? unconfigurableShopIds,
  }) {
    return TargetManageShopsCurrencyShop()
      ..currency = currency ?? this.currency
      ..currentConfigShopIds = currentConfigShopIds ?? this.currentConfigShopIds
      ..relatedConfigShopIds = relatedConfigShopIds ?? this.relatedConfigShopIds
      ..unconfigurableShopIds = unconfigurableShopIds ?? this.unconfigurableShopIds;
  }
}
