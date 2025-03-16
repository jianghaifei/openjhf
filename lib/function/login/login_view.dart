import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/function/login/widget/history_account_view.dart';
import 'package:flutter_report_project/function/login/widget/login_custom_text_field/login_custom_text_field_view.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:flutter_report_project/widget/bottom_sheet/login_switch_area_code/login_switch_area_code_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../router/app_routes.dart';
import '../../utils/app_info.dart';
import '../../utils/network/server_url.dart';
import 'account_manager/history_account_manager.dart';
import 'login_logic.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logic = Get.find<LoginLogic>();
  final state = Get.find<LoginLogic>().state;

  final double topWidgetHeight = 200;

  @override
  void dispose() {
    Get.delete<LoginLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    state.accountFocusNode.addListener(() {
      bool hasFocus = state.accountFocusNode.hasFocus;
      state.isShowHistoryAccount.value = hasFocus;
      debugPrint("hasFocus = $hasFocus");
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          decoration:
              const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.imageLoginBg), fit: BoxFit.cover)),
          child: SafeArea(child: _createBody()),
        ),
      ),
    );
  }

  Widget _createBody() {
    return Column(
      children: [
        _createAppBarWidget(),
        Image.asset(
          Assets.imageLoginLogo,
          width: 70,
          height: 70,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            RSAppInfo().appDisplayName,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Obx(() {
          return Container(
            padding: EdgeInsets.only(
                left: 28,
                right: 28,
                bottom: 24,
                top: (state.loginType.value == LoginType.email || state.loginType.value == LoginType.phone) ? 90 : 58),
            child: _createLoginBody(),
          );
        })),
      ],
    );
  }

  Widget _createAppBarWidget() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 1.sw,
      child: Stack(
        children: [
          Positioned(
              left: 12,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  // 防止键盘消失慢导致上个页面报错
                  if (state.accountFocusNode.hasFocus) {
                    state.accountFocusNode.unfocus();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Get.back();
                    });
                  } else {
                    Get.back();
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _createLoginBody() {
    switch (state.loginType.value) {
      case LoginType.phone:
        return _createPhoneOrEmailWidget(LoginType.phone);
      case LoginType.phonePassword:
        return _createPhoneOrEmailPasswordWidget(LoginType.phonePassword);
      case LoginType.phoneVerificationCode:
        return _createPhoneOrEmailCodeWidget(LoginType.phoneVerificationCode);
      case LoginType.email:
        return _createPhoneOrEmailWidget(LoginType.email);
      case LoginType.emailPassword:
        return _createPhoneOrEmailPasswordWidget(LoginType.emailPassword);
      case LoginType.emailVerificationCode:
        return _createPhoneOrEmailCodeWidget(LoginType.emailVerificationCode);
    }
  }

  /// 构建历史账号ListView
  Widget? _createHistoryAccountWidget() {
    /// widget在屏幕上的坐标。
    if (state.globalKeyAccountTextField.currentContext != null) {
      // /// widget在屏幕上的坐标。
      // Offset offset = flustars.WidgetUtil.getWidgetLocalToGlobal(state.globalKeyAccountTextField.currentContext!);

      // /// widget宽高。
      Rect rect = flustars.WidgetUtil.getWidgetBounds(state.globalKeyAccountTextField.currentContext!);

      return HistoryAccountView(
        rect: rect,
        accountType: state.loginType.value,
        selectCallBack: (String string) {
          state.accountTextController.value.text = string;
          state.accountTextString.value = string;
          if (state.accountErrorTip.value.isNotEmpty) {
            state.accountErrorTip.value = '';
          }
        },
        delCallBack: () {
          if (HistoryAccountManager.getAccounts(state.loginType.value).isEmpty) {
            state.isShowHistoryAccountArrow.value = false;
          }
        },
      );
    }

    return null;
  }

  Widget _createPhoneOrEmailWidget(LoginType type) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginCustomTextFieldPage(
              key: state.globalKeyAccountTextField,
              focusNode: state.accountFocusNode,
              controller: state.accountTextController.value,
              labelText: type == LoginType.phone ? S.current.rs_login_phone_number : S.current.rs_login_email,
              errorText: (state.accountErrorTip.value.isNotEmpty && !state.isShowHistoryAccount.value)
                  ? state.accountErrorTip.value
                  : null,
              onChanged: (value) {
                state.accountErrorTip.value = '';
                state.accountTextString.value = value;
              },
              prefixWidget: type == LoginType.phone ? _createPhonePrefixWidget() : null,
              suffixWidget: HistoryAccountManager.getAccounts(state.loginType.value).isNotEmpty &&
                      state.isShowHistoryAccountArrow.value
                  ? InkWell(
                      onTap: () {
                        state.isShowHistoryAccount.value = !state.isShowHistoryAccount.value;
                      },
                      child: Icon(
                        state.isShowHistoryAccount.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: RSColor.color_0x60000000,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: () => _clickAction("switchLoginMethod"),
                child: Text(
                  type == LoginType.phone ? S.current.rs_login_use_email : S.current.rs_login_use_phone,
                  style: TextStyle(
                    color: RSColor.color_0xFF5C57E6,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
            _createBottomButtonWidget(S.current.rs_next, "NEXT", isEdit: state.accountTextString.value.isNotEmpty),
          ],
        ),
        Offstage(
          offstage: !state.isShowHistoryAccount.value,
          child: _createHistoryAccountWidget(),
        )
      ],
    );
  }

  Widget _createPhoneOrEmailPasswordWidget(LoginType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (type == LoginType.phonePassword)
              Text(
                "+${state.selectAreaCodeEntity.value.areaCode ?? "00"} ",
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Flexible(
              child: Text(
                state.accountTextController.value.text,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
                onPressed: () => _clickAction("Change"),
                child: Text(
                  S.current.rs_login_change,
                  style: TextStyle(
                    color: RSColor.color_0xFF5C57E6,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: LoginCustomTextFieldPage(
            controller: state.passwordTextController.value,
            labelText: S.current.rs_login_password_tip,
            errorText: state.passwordErrorTip.value.isNotEmpty ? state.passwordErrorTip.value : null,
            onChanged: (value) {
              state.passwordErrorTip.value = '';
              state.passwordTextString.value = value;
            },
            suffixWidget: _createPasswordSuffixWidget(),
            obscureText: !state.isShowPass.value,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: InkWell(
            onTap: () => _clickAction("switchLoginMethod"),
            child: Text(
              S.current.rs_login_use_verification_code,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: _createPrivacyAgreementWidget(),
        ),
        const Spacer(),
        _createBottomButtonWidget(S.current.rs_login_uppercase, "SignIn",
            isEdit: state.passwordTextString.value.isNotEmpty),
      ],
    );
  }

  Widget _createPhoneOrEmailCodeWidget(LoginType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (type == LoginType.phoneVerificationCode)
              Text(
                "+${state.selectAreaCodeEntity.value.areaCode ?? "00"} ",
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Flexible(
              child: Text(
                state.accountTextController.value.text,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
                onPressed: () => _clickAction("Change"),
                child: Text(
                  S.current.rs_login_change,
                  style: TextStyle(
                    color: RSColor.color_0xFF5C57E6,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: LoginCustomTextFieldPage(
            controller: state.codeTextController.value,
            labelText: S.current.rs_login_verification_code_tip,
            errorText: state.codeErrorTip.value.isNotEmpty ? state.codeErrorTip.value : null,
            onChanged: (value) {
              state.codeErrorTip.value = '';
              state.codeTextString.value = value;
            },
            suffixWidget: _createCodeSuffixWidget(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: InkWell(
            onTap: () => _clickAction("switchLoginMethod"),
            child: Text(
              S.current.rs_login_use_password,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: _createPrivacyAgreementWidget(),
        ),
        const Spacer(),
        _createBottomButtonWidget(S.current.rs_login_uppercase, "SignIn",
            isEdit: state.codeTextString.value.isNotEmpty),
      ],
    );
  }

  Widget _createPrivacyAgreementWidget() {
    return InkWell(
      onTap: () {
        state.isAgreementProtocol.value = !state.isAgreementProtocol.value;
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return Image.asset(
              state.isAgreementProtocol.value ? Assets.imageLoginCheckboxSel : Assets.imageLoginCheckbox,
              fit: BoxFit.fill,
              width: 16,
              height: 16,
            );
          }),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: RichText(
                  text: TextSpan(
                      text: S.current.rs_login_privacy_agreement_prefix,
                      style: TextStyle(
                        color: RSColor.color_0x60000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                    TextSpan(
                        text: '《${S.current.rs_login_privacy_agreement}》',
                        style: TextStyle(fontSize: 12, color: RSColor.color_0xFF5C57E6, fontWeight: FontWeight.w400),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Get.toNamed(AppRoutes.webViewPage, arguments: {"url": RSServerUrl.appUserPrivacyPolicyUrl});
                          }),
                  ])),
            ),
          )
        ],
      ),
    );
  }

  Widget _createPhonePrefixWidget() {
    return InkWell(
      onTap: () => _clickAction("switchAreaCode"),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state.selectAreaCodeEntity.value.banner != null)
              SvgPicture.network(
                state.selectAreaCodeEntity.value.banner!,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "+${state.selectAreaCodeEntity.value.areaCode ?? '00'}",
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: RSColor.color_0x90000000,
            )
          ],
        ),
      ),
    );
  }

  Widget _createPasswordSuffixWidget() {
    return InkWell(
      child: Icon(
        state.isShowPass.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: RSColor.color_0x60000000,
        size: 18,
      ),
      onTap: () {
        state.isShowPass.value = !state.isShowPass.value;
      },
    );
  }

  Widget _createCodeSuffixWidget() {
    return InkWell(
      onTap: () => _clickAction("sendVerificationCode"),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: RSColor.color_0xFFE7E7E7,
              width: 1,
              height: 15,
            ),
          ),
          SizedBox(width: 5),
          Container(
            alignment: Alignment.center,
            child: Text(
              state.countdownCount.value > 0
                  ? '${S.current.rs_login_resend}(${state.countdownCount.value}s)'
                  : S.current.rs_login_get_code,
              maxLines: 1,
              style: TextStyle(
                color: state.countdownCount.value > 0 ? RSColor.color_0x40000000 : RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createBottomButtonWidget(String title, String action, {bool isEdit = false}) {
    return InkWell(
      onTap: () => _clickAction(action),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28),
        height: 48,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: isEdit ? RSColor.color_0xFF5C57E6 : RSColor.color_0xFF5C57E6.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: RSColor.color_0xFFFFFFFF,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _clickAction(String action) {
    if (action == "switchAreaCode") {
      if (state.areaCodeEntityList.value.areaCodeList != null) {
        Get.bottomSheet(
          LoginSwitchAreaCodePage(
            entity: state.areaCodeEntityList.value,
            currentArea: state.selectAreaCodeEntity.value,
            selectedEntity: (entity) {
              state.selectAreaCodeEntity.value = entity;
            },
          ),
          isScrollControlled: true,
        );
      } else {
        EasyLoading.showError('areaCodeList null');
      }
    } else if (action == "switchLoginMethod") {
      RSUtils.hideKeyboard();
      if (state.loginType.value == LoginType.phone) {
        state.accountTextController.value.clear();
        state.accountErrorTip.value = '';

        state.loginType.value = LoginType.email;
      } else if (state.loginType.value == LoginType.email) {
        state.accountTextController.value.clear();
        state.accountErrorTip.value = '';

        state.loginType.value = LoginType.phone;
      } else if (state.loginType.value == LoginType.phonePassword) {
        state.loginType.value = LoginType.phoneVerificationCode;
      } else if (state.loginType.value == LoginType.emailPassword) {
        state.loginType.value = LoginType.emailVerificationCode;
      } else if (state.loginType.value == LoginType.phoneVerificationCode) {
        state.loginType.value = LoginType.phonePassword;
      } else if (state.loginType.value == LoginType.emailVerificationCode) {
        state.loginType.value = LoginType.emailPassword;
      }
    } else if (action == "NEXT") {
      if (state.accountTextController.value.text.isEmpty || !logic.verifyCondition()) {
        return;
      }
      if (state.loginType.value == LoginType.phone) {
        state.loginType.value = LoginType.phonePassword;
      } else if (state.loginType.value == LoginType.email) {
        state.loginType.value = LoginType.emailPassword;
      }
    } else if (action == "Change") {
      state.passwordTextController.value.clear();
      state.codeTextController.value.clear();
      state.isAgreementProtocol.value = false;

      if (state.loginType.value == LoginType.phonePassword ||
          state.loginType.value == LoginType.phoneVerificationCode) {
        state.loginType.value = LoginType.phone;
      } else if (state.loginType.value == LoginType.emailPassword ||
          state.loginType.value == LoginType.emailVerificationCode) {
        state.loginType.value = LoginType.email;
      }
    } else if (action == "sendVerificationCode") {
      logic.sendVerificationCode();
    } else if (action == "SignIn") {
      RSUtils.hideKeyboard();
      logic.login();
    }
  }
}
