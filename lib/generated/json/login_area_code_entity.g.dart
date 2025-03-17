import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/login/login_area_code_entity.dart';

LoginAreaCodeEntity $LoginAreaCodeEntityFromJson(Map<String, dynamic> json) {
  final LoginAreaCodeEntity loginAreaCodeEntity = LoginAreaCodeEntity();
  final List<LoginAreaCodeAreaCodeList>? areaCodeList = (json['areaCodeList'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LoginAreaCodeAreaCodeList>(e) as LoginAreaCodeAreaCodeList).toList();
  if (areaCodeList != null) {
    loginAreaCodeEntity.areaCodeList = areaCodeList;
  }
  return loginAreaCodeEntity;
}

Map<String, dynamic> $LoginAreaCodeEntityToJson(LoginAreaCodeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['areaCodeList'] = entity.areaCodeList?.map((v) => v.toJson()).toList();
  return data;
}

extension LoginAreaCodeEntityExtension on LoginAreaCodeEntity {
  LoginAreaCodeEntity copyWith({
    List<LoginAreaCodeAreaCodeList>? areaCodeList,
  }) {
    return LoginAreaCodeEntity()
      ..areaCodeList = areaCodeList ?? this.areaCodeList;
  }
}

LoginAreaCodeAreaCodeList $LoginAreaCodeAreaCodeListFromJson(Map<String, dynamic> json) {
  final LoginAreaCodeAreaCodeList loginAreaCodeAreaCodeList = LoginAreaCodeAreaCodeList();
  final String? areaCode = jsonConvert.convert<String>(json['areaCode']);
  if (areaCode != null) {
    loginAreaCodeAreaCodeList.areaCode = areaCode;
  }
  final String? area = jsonConvert.convert<String>(json['area']);
  if (area != null) {
    loginAreaCodeAreaCodeList.area = area;
  }
  final String? banner = jsonConvert.convert<String>(json['banner']);
  if (banner != null) {
    loginAreaCodeAreaCodeList.banner = banner;
  }
  final String? phoneFormatRegular = jsonConvert.convert<String>(json['phoneFormatRegular']);
  if (phoneFormatRegular != null) {
    loginAreaCodeAreaCodeList.phoneFormatRegular = phoneFormatRegular;
  }
  final String? region = jsonConvert.convert<String>(json['region']);
  if (region != null) {
    loginAreaCodeAreaCodeList.region = region;
  }
  return loginAreaCodeAreaCodeList;
}

Map<String, dynamic> $LoginAreaCodeAreaCodeListToJson(LoginAreaCodeAreaCodeList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['areaCode'] = entity.areaCode;
  data['area'] = entity.area;
  data['banner'] = entity.banner;
  data['phoneFormatRegular'] = entity.phoneFormatRegular;
  data['region'] = entity.region;
  return data;
}

extension LoginAreaCodeAreaCodeListExtension on LoginAreaCodeAreaCodeList {
  LoginAreaCodeAreaCodeList copyWith({
    String? areaCode,
    String? area,
    String? banner,
    String? phoneFormatRegular,
    String? region,
  }) {
    return LoginAreaCodeAreaCodeList()
      ..areaCode = areaCode ?? this.areaCode
      ..area = area ?? this.area
      ..banner = banner ?? this.banner
      ..phoneFormatRegular = phoneFormatRegular ?? this.phoneFormatRegular
      ..region = region ?? this.region;
  }
}