import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../model/user/user_info_entity.dart';
import '../../../router/app_routes.dart';
import '../../../utils/network/models/api_response_entity.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../account_manager/account_manager.dart';
import '../account_manager/history_account_manager.dart';
import '../login_state.dart';
import 'choose_perspective_state.dart';

class ChoosePerspectiveLogic extends GetxController {
  final ChoosePerspectiveState state = ChoosePerspectiveState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("corporationList")) {
        state.corporationList.value = args["corporationList"];
      }
      if (args.containsKey("loginType")) {
        state.loginType = args["loginType"];
      }
      if (args.containsKey("phoneAreaCode")) {
        state.phoneAreaCode = args["phoneAreaCode"];
      }
      if (args.containsKey("verifyCode")) {
        state.verifyCode = args["verifyCode"];
      }
      if (args.containsKey("account")) {
        state.account = args["account"];
      }
      if (state.account == null) {
        EasyLoading.showError("Account is Null");
        Get.back();
      }

      if ((state.loginType == LoginType.phonePassword || state.loginType == LoginType.phoneVerificationCode) &&
          state.phoneAreaCode == null) {
        EasyLoading.showError("PhoneAreaCode is Null");
        Get.back();
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 获取Token
  void getAccessToken(UserInfoEmployeeList userInfoEmployee) async {
    var currentGetType = LoginType.phonePassword;

    if (state.loginType == LoginType.phonePassword || state.loginType == LoginType.phoneVerificationCode) {
      currentGetType = LoginType.phone;
    } else if (state.loginType == LoginType.emailPassword || state.loginType == LoginType.emailVerificationCode) {
      currentGetType = LoginType.email;
    }

    var params = {};
    var url = RSServerUrl.loginEmailGetToken;
    if (currentGetType == LoginType.phone) {
      params = {
        "phone": state.account,
        "phoneAreaCode": state.phoneAreaCode,
        "corporationId": userInfoEmployee.corporationId,
        "employeeCode": userInfoEmployee.employeeCode,
        "employeeId": userInfoEmployee.employeeId,
        "verifyCode": state.verifyCode,
      };
      url = RSServerUrl.loginPhoneGetToken;
    } else if (currentGetType == LoginType.email) {
      params = {
        "email": state.account,
        "corporationId": userInfoEmployee.corporationId,
        "employeeCode": userInfoEmployee.employeeCode,
        "employeeId": userInfoEmployee.employeeId,
        "verifyCode": state.verifyCode,
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

        Map<String, dynamic> dataDic = response.data;
        if (dataDic.containsKey("accessToken")) {
          var userInfo = RSAccountManager().userInfoEntity;
          userInfo?.accessToken = dataDic["accessToken"];
          userInfo?.employee = userInfoEmployee;
          if (userInfo != null) {
            // 更新用户信息并跳转至首页
            RSAccountManager().updateUserInfo(userInfo);
            // 去首页
            Get.offAllNamed(AppRoutes.mainPage);
            // 账号历史
            HistoryAccountManager.saveAccount(state.account!, currentGetType);
          }
        }
      });
    }, showLoading: true);
  }
}
