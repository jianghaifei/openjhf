import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/user/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final List<UserInfoEmployeeList>? employeeList = (json['employeeList'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UserInfoEmployeeList>(e) as UserInfoEmployeeList).toList();
  if (employeeList != null) {
    userInfoEntity.employeeList = employeeList;
  }
  final String? verifyCode = jsonConvert.convert<String>(json['verifyCode']);
  if (verifyCode != null) {
    userInfoEntity.verifyCode = verifyCode;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userInfoEntity.email = email;
  }
  final String? phoneAreaCode = jsonConvert.convert<String>(json['phoneAreaCode']);
  if (phoneAreaCode != null) {
    userInfoEntity.phoneAreaCode = phoneAreaCode;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoEntity.phone = phone;
  }
  final String? accessToken = jsonConvert.convert<String>(json['accessToken']);
  if (accessToken != null) {
    userInfoEntity.accessToken = accessToken;
  }
  final UserInfoEmployeeList? employee = jsonConvert.convert<UserInfoEmployeeList>(json['employee']);
  if (employee != null) {
    userInfoEntity.employee = employee;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['employeeList'] = entity.employeeList?.map((v) => v.toJson()).toList();
  data['verifyCode'] = entity.verifyCode;
  data['email'] = entity.email;
  data['phoneAreaCode'] = entity.phoneAreaCode;
  data['phone'] = entity.phone;
  data['accessToken'] = entity.accessToken;
  data['employee'] = entity.employee?.toJson();
  return data;
}

extension UserInfoEntityExtension on UserInfoEntity {
  UserInfoEntity copyWith({
    List<UserInfoEmployeeList>? employeeList,
    String? verifyCode,
    String? email,
    String? phoneAreaCode,
    String? phone,
    String? accessToken,
    UserInfoEmployeeList? employee,
  }) {
    return UserInfoEntity()
      ..employeeList = employeeList ?? this.employeeList
      ..verifyCode = verifyCode ?? this.verifyCode
      ..email = email ?? this.email
      ..phoneAreaCode = phoneAreaCode ?? this.phoneAreaCode
      ..phone = phone ?? this.phone
      ..accessToken = accessToken ?? this.accessToken
      ..employee = employee ?? this.employee;
  }
}

UserInfoEmployeeList $UserInfoEmployeeListFromJson(Map<String, dynamic> json) {
  final UserInfoEmployeeList userInfoEmployeeList = UserInfoEmployeeList();
  final String? employeeCode = jsonConvert.convert<String>(json['employeeCode']);
  if (employeeCode != null) {
    userInfoEmployeeList.employeeCode = employeeCode;
  }
  final String? employeeName = jsonConvert.convert<String>(json['employeeName']);
  if (employeeName != null) {
    userInfoEmployeeList.employeeName = employeeName;
  }
  final String? employeeId = jsonConvert.convert<String>(json['employeeId']);
  if (employeeId != null) {
    userInfoEmployeeList.employeeId = employeeId;
  }
  final String? employeePhone = jsonConvert.convert<String>(json['employeePhone']);
  if (employeePhone != null) {
    userInfoEmployeeList.employeePhone = employeePhone;
  }
  final String? employeeEmail = jsonConvert.convert<String>(json['employeeEmail']);
  if (employeeEmail != null) {
    userInfoEmployeeList.employeeEmail = employeeEmail;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    userInfoEmployeeList.avatar = avatar;
  }
  final String? corporationId = jsonConvert.convert<String>(json['corporationId']);
  if (corporationId != null) {
    userInfoEmployeeList.corporationId = corporationId;
  }
  final String? corporationName = jsonConvert.convert<String>(json['corporationName']);
  if (corporationName != null) {
    userInfoEmployeeList.corporationName = corporationName;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoEmployeeList.phone = phone;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userInfoEmployeeList.email = email;
  }
  return userInfoEmployeeList;
}

Map<String, dynamic> $UserInfoEmployeeListToJson(UserInfoEmployeeList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['employeeCode'] = entity.employeeCode;
  data['employeeName'] = entity.employeeName;
  data['employeeId'] = entity.employeeId;
  data['employeePhone'] = entity.employeePhone;
  data['employeeEmail'] = entity.employeeEmail;
  data['avatar'] = entity.avatar;
  data['corporationId'] = entity.corporationId;
  data['corporationName'] = entity.corporationName;
  data['phone'] = entity.phone;
  data['email'] = entity.email;
  return data;
}

extension UserInfoEmployeeListExtension on UserInfoEmployeeList {
  UserInfoEmployeeList copyWith({
    String? employeeCode,
    String? employeeName,
    String? employeeId,
    String? employeePhone,
    String? employeeEmail,
    String? avatar,
    String? corporationId,
    String? corporationName,
    String? phone,
    String? email,
  }) {
    return UserInfoEmployeeList()
      ..employeeCode = employeeCode ?? this.employeeCode
      ..employeeName = employeeName ?? this.employeeName
      ..employeeId = employeeId ?? this.employeeId
      ..employeePhone = employeePhone ?? this.employeePhone
      ..employeeEmail = employeeEmail ?? this.employeeEmail
      ..avatar = avatar ?? this.avatar
      ..corporationId = corporationId ?? this.corporationId
      ..corporationName = corporationName ?? this.corporationName
      ..phone = phone ?? this.phone
      ..email = email ?? this.email;
  }
}