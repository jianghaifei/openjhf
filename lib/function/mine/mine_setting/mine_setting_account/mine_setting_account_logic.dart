import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/network/models/api_response_entity.dart';
import '../../../../utils/network/request.dart';
import '../../../../utils/network/request_client.dart';
import '../../../../utils/network/server_url.dart';
import '../../../login/account_manager/account_manager.dart';
import 'mine_setting_account_state.dart';

class MineSettingAccountLogic extends GetxController {
  final MineSettingAccountState state = MineSettingAccountState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> sendLogoutRequest() async {
    await request(() async {
      await requestClient.request(RSServerUrl.logout, method: RequestType.get, data: {}, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });
    });

    /// 退出登录操作
    await RSAccountManager().logout();
  }

  void setListTitle() {
    state.listTitle = [
      S.current.rs_employee_name,
      S.current.rs_employee_code,
      // S.current.rs_account,
      S.current.rs_email,
      S.current.rs_phone,
      S.current.rs_corporation
    ];
  }
}
