import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
  /// 集团和员工信息
  List<UserInfoEmployeeList>? employeeList;

  /// 用户换token的验证码
  String? verifyCode;

  /// 登录邮箱
  String? email;

  /// 区号
  String? phoneAreaCode;

  /// 手机号
  String? phone;

  /// 自留字段
  String? accessToken;

  /// 自留字段
  UserInfoEmployeeList? employee;

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class UserInfoEmployeeList {
  String? employeeCode;
  String? employeeName;
  String? employeeId;
  String? employeePhone;
  String? employeeEmail;
  String? avatar;
  String? corporationId;
  String? corporationName;

  String? phone;
  String? email;

  UserInfoEmployeeList();

  factory UserInfoEmployeeList.fromJson(Map<String, dynamic> json) => $UserInfoEmployeeListFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEmployeeListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
