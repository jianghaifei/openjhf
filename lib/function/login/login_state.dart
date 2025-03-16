import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/login/login_area_code_entity.dart';

enum LoginType {
  phone,
  phonePassword,
  phoneVerificationCode,
  email,
  emailPassword,
  emailVerificationCode,
}

class LoginState {
  /// 手机区号模型
  var areaCodeEntityList = LoginAreaCodeEntity().obs;

  /// 选中的手机区号模型
  var selectAreaCodeEntity = LoginAreaCodeAreaCodeList().obs;

  /// 当前登录类型
  var loginType = LoginType.email.obs;

  /// 是否显示密码
  var isShowPass = false.obs;

  /// 是否同意协议
  var isAgreementProtocol = false.obs;

  /// 是否显示历史账号
  var isShowHistoryAccount = false.obs;
  var isShowHistoryAccountArrow = true.obs;

  /// 账号输入框
  var accountTextController = TextEditingController().obs;
  var accountTextString = ''.obs;
  var accountErrorTip = ''.obs;
  final GlobalKey globalKeyAccountTextField = GlobalKey(); //用来标记控件
  FocusNode accountFocusNode = FocusNode();

  /// 密码输入框
  var passwordTextController = TextEditingController().obs;
  var passwordTextString = ''.obs;
  var passwordErrorTip = ''.obs;

  /// 验证码输入框
  var codeTextController = TextEditingController().obs;
  var codeTextString = ''.obs;
  var codeErrorTip = ''.obs;

  /// 倒计时
  late Timer countdownTimer;
  var countdownCount = 0.obs;
  bool isCounting = false;

  LoginState() {
    ///Initialize variables
  }
}
