import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
  // 集团和员工信息
  List<UserInfoEmployeeList>? employeeList;

  // 用户换token的验证码
  String? verifyCode;

  // 登录邮箱
  String? email;

  // 区号
  String? phoneAreaCode;

  // 手机号
  String? phone;

  // 登录token
  String? accessToken;

  // 员工信息
  UserInfoEmployeeList? employee;

  // 权限相关
  UserInfoPermission? permission;

  // 账号下集团列表
  List<UserInfoCorporation>? corporations;

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
  // 员工code
  String? employeeCode;

  // 员工姓名
  String? employeeName;

  // 员工id
  String? employeeId;

  // 员工 联系电话
  String? employeePhone;

  // 员工 电子邮件
  String? employeeEmail;

  // 头像
  String? avatar;

  // 集团Id
  String? corporationId;

  // 集团名称
  String? corporationName;

  // 账号 联系电话
  String? phone;

  // 账号 电子邮件
  String? email;

  UserInfoEmployeeList();

  factory UserInfoEmployeeList.fromJson(Map<String, dynamic> json) => $UserInfoEmployeeListFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEmployeeListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class UserInfoPermission {
  // 老板通控制的整体开关类权限列表有值的表示有相关功能，没有的表示没有相关功能
  List<String>? featureToggles;

  UserInfoPermission();

  factory UserInfoPermission.fromJson(Map<String, dynamic> json) => $UserInfoPermissionFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoPermissionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class UserInfoCorporation {
  // 集团Id
  String? corporationId;

  // 集团名称
  String? corporationName;

  UserInfoCorporation();

  factory UserInfoCorporation.fromJson(Map<String, dynamic> json) => $UserInfoCorporationFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoCorporationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
