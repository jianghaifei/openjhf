import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/login_area_code_entity.g.dart';

export 'package:flutter_report_project/generated/json/login_area_code_entity.g.dart';

@JsonSerializable()
class LoginAreaCodeEntity {
  List<LoginAreaCodeAreaCodeList>? areaCodeList;

  LoginAreaCodeEntity();

  factory LoginAreaCodeEntity.fromJson(Map<String, dynamic> json) => $LoginAreaCodeEntityFromJson(json);

  Map<String, dynamic> toJson() => $LoginAreaCodeEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LoginAreaCodeAreaCodeList {
  String? areaCode;
  String? area;
  String? banner;
  String? phoneFormatRegular;
  String? region;

  LoginAreaCodeAreaCodeList();

  factory LoginAreaCodeAreaCodeList.fromJson(Map<String, dynamic> json) => $LoginAreaCodeAreaCodeListFromJson(json);

  Map<String, dynamic> toJson() => $LoginAreaCodeAreaCodeListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
