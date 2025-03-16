import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/index.dart';
import 'package:flutter_report_project/model/login/login_area_code_entity.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';

import '../../generated/l10n.dart';
import '../../model/user/user_info_entity.dart';
import '../../utils/network/app_compile_env.dart';
import '../../utils/network/models/api_response_entity.dart';
import '../../utils/network/request.dart';
import '../../utils/network/request_client.dart';
import '../../utils/network/server_url.dart';
import '../../widget/popup_widget/rs_alert/rs_alert_view.dart';
import 'account_manager/account_manager.dart';
import 'account_manager/history_account_manager.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  @override
  void onReady() {
    // 请求区号
    requestAreaCode();

    super.onReady();

    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    super.onClose();

    logger.d("onClose", StackTrace.current);
  }

  /// 请求区号
  void requestAreaCode() async {
    await request(() async {
      LoginAreaCodeEntity? entity =
          await requestClient.request(RSServerUrl.loginAreaCode, method: RequestType.post, onError: (e) {
        return false;
      });

      if (entity != null) {
        state.areaCodeEntityList.value = entity;
        if (state.areaCodeEntityList.value.areaCodeList != null &&
            state.areaCodeEntityList.value.areaCodeList!.isNotEmpty) {
          // CN环境默认展示 +86
          if (RSAppCompileEnv.getCurrentEnvType() == EnvType.cn) {
            var tmpModel = state.areaCodeEntityList.value.areaCodeList
                ?.firstWhere((element) => element.areaCode != null && element.areaCode!.contains("86"));

            if (tmpModel != null) {
              state.selectAreaCodeEntity.value = tmpModel;
            } else {
              state.selectAreaCodeEntity.value = state.areaCodeEntityList.value.areaCodeList!.first;
            }
          } else {
            state.selectAreaCodeEntity.value = state.areaCodeEntityList.value.areaCodeList!.first;
          }
        }
      }
    }, showLoading: true);
  }

  /// 登录
  void login() async {
    if (!verifyCondition()) {
      return;
    }

    switch (state.loginType.value) {
      case LoginType.phonePassword:
        _loginByMobileAndPwd();
        return;
      case LoginType.phoneVerificationCode:
        _loginByMobileAndCaptcha();
        return;
      case LoginType.emailPassword:
        _loginByEmailAndPwd();
        return;
      case LoginType.emailVerificationCode:
        _loginByEmailAndCaptcha();
        return;
      default:
        EasyLoading.showError("loginType error");
        return;
    }
  }

  /// 手机+验证码登录
  _loginByMobileAndCaptcha() async {
    await request(() async {
      var params = {
        "smsCode": state.codeTextController.value.text,
        "phone": state.accountTextController.value.text,
        "phoneAreaCode": state.selectAreaCodeEntity.value.areaCode,
        "region": state.selectAreaCodeEntity.value.region,
      };

      UserInfoEntity? userInfoEntity = await requestClient.request<UserInfoEntity>(RSServerUrl.loginByMobileAndCaptcha,
          method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });

      _loginSuccess(userInfoEntity);
    }, showLoading: true);
  }

  /// 手机+密码登录
  _loginByMobileAndPwd() async {
    await request(() async {
      var params = {
        "password": state.passwordTextController.value.text,
        "phone": state.accountTextController.value.text,
        "phoneAreaCode": state.selectAreaCodeEntity.value.areaCode,
        "region": state.selectAreaCodeEntity.value.region,
      };

      UserInfoEntity? userInfoEntity = await requestClient.request<UserInfoEntity>(RSServerUrl.loginByMobileAndPwd,
          method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });

      _loginSuccess(userInfoEntity);
    }, showLoading: true);
  }

  /// 邮箱+验证码登录
  _loginByEmailAndCaptcha() async {
    await request(() async {
      var params = {
        "email": state.accountTextController.value.text,
        "captcha": state.codeTextController.value.text,
      };

      UserInfoEntity? userInfoEntity = await requestClient.request<UserInfoEntity>(RSServerUrl.loginByEmailAndCaptcha,
          method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });

      _loginSuccess(userInfoEntity);
    }, showLoading: true);
  }

  /// 邮箱+密码登录
  _loginByEmailAndPwd() async {
    await request(() async {
      var params = {
        "email": state.accountTextController.value.text,
        "password": state.passwordTextController.value.text,
      };

      UserInfoEntity? userInfoEntity = await requestClient.request<UserInfoEntity>(RSServerUrl.loginByEmailAndPwd,
          method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });

      _loginSuccess(userInfoEntity);
    }, showLoading: true);
  }

  /// 登录成功后的操作
  _loginSuccess(UserInfoEntity? entity) {
    /// 登录成功
    if (entity?.employeeList != null && entity!.employeeList!.isNotEmpty) {
      if (entity.employeeList?.length == 1) {
        // 默认取第一个公司信息
        entity.employee = entity.employeeList?.first;
        // 存储登录信息
        RSAccountManager().loginSuccess(entity);
        // 获取Token
        _getAccessToken(entity.employeeList!.first, entity.verifyCode, state.loginType.value);
      } else {
        // 存储登录信息
        RSAccountManager().loginSuccess(entity);
        // 去选视角页
        Get.toNamed(AppRoutes.choosePerspectivePage, arguments: {
          "corporationList": entity.employeeList,
          "verifyCode": entity.verifyCode,
          "loginType": state.loginType.value,
          "phoneAreaCode": state.selectAreaCodeEntity.value.areaCode,
          "account": state.accountTextController.value.text,
        });
      }
    } else {
      EasyLoading.showError("No Permission");
    }
  }

  /// 获取Token
  _getAccessToken(UserInfoEmployeeList userInfoEmployee, String? verifyCode, LoginType loginType) async {
    var currentGetType = LoginType.phonePassword;

    if (loginType == LoginType.phonePassword || loginType == LoginType.phoneVerificationCode) {
      currentGetType = LoginType.phone;
    } else if (loginType == LoginType.emailPassword || loginType == LoginType.emailVerificationCode) {
      currentGetType = LoginType.email;
    }

    var params = {};
    var url = RSServerUrl.loginEmailGetToken;

    if (currentGetType == LoginType.phone) {
      params = {
        "phone": state.accountTextController.value.text,
        "phoneAreaCode": state.selectAreaCodeEntity.value.areaCode,
        "region": state.selectAreaCodeEntity.value.region,
        "corporationId": userInfoEmployee.corporationId,
        "employeeCode": userInfoEmployee.employeeCode,
        "employeeId": userInfoEmployee.employeeId,
        "verifyCode": verifyCode,
      };
      url = RSServerUrl.loginPhoneGetToken;
    } else if (currentGetType == LoginType.email) {
      params = {
        "email": state.accountTextController.value.text,
        "corporationId": userInfoEmployee.corporationId,
        "employeeCode": userInfoEmployee.employeeCode,
        "employeeId": userInfoEmployee.employeeId,
        "verifyCode": verifyCode,
      };
      url = RSServerUrl.loginEmailGetToken;
    }

    await request(() async {
      await requestClient.request(url, method: RequestType.post, data: params, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');

        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');

        var tmpResponseData = response.data;

        if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
          Map<String, dynamic> dataDic = response.data;
          if (dataDic.containsKey("accessToken")) {
            var userInfo = RSAccountManager().userInfoEntity;
            userInfo?.accessToken = dataDic["accessToken"];
            if (userInfo != null) {
              RSAccountManager().updateUserInfo(userInfo);

              // 保存账号历史
              HistoryAccountManager.saveAccount(state.accountTextController.value.text, currentGetType);

              // TODO: 根据权限获取可选身份，目前只有老板和供应链管理员，本地写死
              if(RSIdentify.getIdentify() == '') {
                Get.offAllNamed(AppRoutes.mineChangeIdentityPage);
              }else {
                // 去首页
                Get.offAllNamed(AppRoutes.mainPage);
              }

            }
          }
        }
      });
    }, showLoading: true);
  }

  /// 验证条件
  bool verifyCondition() {
    // 判断账号是否填写
    if (!validatePhoneNumberOrEmail()) {
      if (state.loginType.value == LoginType.phone) {
        state.accountErrorTip.value = S.current.rs_login_phone_format_error_tip;
      } else if (state.loginType.value == LoginType.email) {
        state.accountErrorTip.value = S.current.rs_login_email_format_error_tip;
      }
      return false;
    } else {
      state.accountErrorTip.value = '';
    }
    if (state.accountErrorTip.value.isNotEmpty) {
      return false;
    }

    // 判断密码是否填写
    if (state.loginType.value == LoginType.phonePassword || state.loginType.value == LoginType.emailPassword) {
      if (state.passwordTextController.value.text.isEmpty) {
        return false;
      }

      return isAgreeAgreement();
    }

    // 判断验证码是否填写
    if (state.loginType.value == LoginType.phoneVerificationCode ||
        state.loginType.value == LoginType.emailVerificationCode) {
      if (state.codeTextController.value.text.isEmpty) {
        return false;
      }

      return isAgreeAgreement();
    }

    return true;
  }

  /// 是否同意协议
  bool isAgreeAgreement() {
    debugPrint("isAgreeAgreement = ${state.isAgreementProtocol.value}");
    if (state.isAgreementProtocol.value == false) {
      debugPrint("isCheck == ${state.isAgreementProtocol.value}");

      Get.dialog(
          RSAlertPopup(
              customContentWidget: createPrivacyTextWidget(),
              alertPopupType: RSAlertPopupType.normal,
              leftButtonTitle: S.current.rs_later,
              rightButtonTitle: S.current.rs_agreed,
              doneCallback: () async {
                state.isAgreementProtocol.value = true;
              }),
          barrierDismissible: false);
      return false;
    }
    return true;
  }

  Widget createPrivacyTextWidget() {
    String clickableText = '《${S.current.rs_login_privacy_agreement}》';

    String text = S.current.rs_read_agree_privacy_policy + clickableText;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, text.indexOf(clickableText)),
            style: TextStyle(
              color: RSColor.color_0x60000000,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: clickableText,
            style: TextStyle(
              color: RSColor.color_0xFF5C57E6,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.webViewPage, arguments: {"url": RSServerUrl.appUserPrivacyPolicyUrl});
              },
          ),
          TextSpan(
            text: text.substring(text.indexOf(clickableText) + clickableText.length),
            style: TextStyle(
              color: RSColor.color_0x60000000,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// 使用正则表达式检查手机号码格式
  bool validatePhoneNumberOrEmail() {
    RegExp regExp;

    if (state.loginType.value == LoginType.email) {
      regExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
      return regExp.hasMatch(state.accountTextController.value.text);
    } else if (state.loginType.value == LoginType.phone) {
      // return true;
      regExp = RegExp(state.selectAreaCodeEntity.value.phoneFormatRegular ?? '.*');
      return regExp.hasMatch(state.accountTextController.value.text);
    }

    return true;
  }

  /// 发送验证码
  void sendVerificationCode() async {
    var params = {};
    var url = "";

    if (state.loginType.value == LoginType.phoneVerificationCode) {
      debugPrint("发送手机验证码");

      params = {
        "phone": state.accountTextController.value.text,
        "phoneAreaCode": state.selectAreaCodeEntity.value.areaCode,
        "region": state.selectAreaCodeEntity.value.region,
      };

      url = RSServerUrl.loginSendMobileCaptcha;
    } else if (state.loginType.value == LoginType.emailVerificationCode) {
      debugPrint("发送邮箱验证码");

      params = {
        "email": state.accountTextController.value.text,
      };
      url = RSServerUrl.loginSendEmailCaptcha;
    } else {
      EasyLoading.showError("parametersAreMissing");
      return;
    }

    await request(() async {
      await requestClient.request(url, method: RequestType.post, data: params, onError: (e) {
        return false;
      }, onResponse: (ApiResponseEntity response) {
        var code = response.code;

        if (code == "000") {
          if (!state.isCounting) {
            startCountdown();
          }
        }
      });
    }, showLoading: true);
  }

  /// 开始倒计时
  void startCountdown() {
    state.isCounting = true;
    state.countdownCount.value = kDebugMode ? 10 : 60;

    state.countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdownCount.value <= 0) {
        stopCountdown();
      } else {
        state.countdownCount.value--;
      }
    });
  }

  /// 结束倒计时
  void stopCountdown() {
    if (state.countdownTimer.isActive) {
      state.countdownTimer.cancel();
      state.isCounting = false;
    }
  }
}
