import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/order_detail_setting_options_entity.dart';

OrderDetailSettingOptionsEntity $OrderDetailSettingOptionsEntityFromJson(Map<String, dynamic> json) {
  final OrderDetailSettingOptionsEntity orderDetailSettingOptionsEntity = OrderDetailSettingOptionsEntity();
  final List<OrderDetailSettingOptionsOptions>? options = (json['options'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<OrderDetailSettingOptionsOptions>(e) as OrderDetailSettingOptionsOptions).toList();
  if (options != null) {
    orderDetailSettingOptionsEntity.options = options;
  }
  return orderDetailSettingOptionsEntity;
}

Map<String, dynamic> $OrderDetailSettingOptionsEntityToJson(OrderDetailSettingOptionsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['options'] = entity.options?.map((v) => v.toJson()).toList();
  return data;
}

extension OrderDetailSettingOptionsEntityExtension on OrderDetailSettingOptionsEntity {
  OrderDetailSettingOptionsEntity copyWith({
    List<OrderDetailSettingOptionsOptions>? options,
  }) {
    return OrderDetailSettingOptionsEntity()
      ..options = options ?? this.options;
  }
}

OrderDetailSettingOptionsOptions $OrderDetailSettingOptionsOptionsFromJson(Map<String, dynamic> json) {
  final OrderDetailSettingOptionsOptions orderDetailSettingOptionsOptions = OrderDetailSettingOptionsOptions();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    orderDetailSettingOptionsOptions.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    orderDetailSettingOptionsOptions.code = code;
  }
  final bool? show = jsonConvert.convert<bool>(json['show']);
  if (show != null) {
    orderDetailSettingOptionsOptions.show = show;
  }
  return orderDetailSettingOptionsOptions;
}

Map<String, dynamic> $OrderDetailSettingOptionsOptionsToJson(OrderDetailSettingOptionsOptions entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['show'] = entity.show;
  return data;
}

extension OrderDetailSettingOptionsOptionsExtension on OrderDetailSettingOptionsOptions {
  OrderDetailSettingOptionsOptions copyWith({
    String? name,
    String? code,
    bool? show,
  }) {
    return OrderDetailSettingOptionsOptions()
      ..name = name ?? this.name
      ..code = code ?? this.code
      ..show = show ?? this.show;
  }
}