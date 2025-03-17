import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../utils/logger/logger_helper.dart';
import '../../utils/network/models/api_response_entity.dart';
import '../../utils/network/request_client.dart';
import '../../utils/network/server_url.dart';
import '../analytics/analytics_logic.dart';
import '../login/account_manager/account_manager.dart';
import 'mine_state.dart';

class MineLogic extends GetxController {
  final MineState state = MineState();

  VoidCallback? refreshCallback;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    logger.d("onClose", StackTrace.current);
  }

  void setListTitle() {
    state.listTitle = [
      // S.current.rs_report,
      S.current.rs_setting,
      // S.current.rs_give_feedback,
      // S.current.rs_help_center,
      S.current.rs_version
    ];
  }

  // 切换集团
  void changeCorporation(int index) async {
    logger.d("changeCorporation", StackTrace.current);

    // 获取集团列表
    var corporations = RSAccountManager().userInfoEntity?.corporations;

    // 获取当前集团
    var currentCorporation = corporations?[index];

    if (currentCorporation != null &&
        currentCorporation.corporationId != null &&
        currentCorporation.corporationId!.isNotEmpty) {
      request(() async {
        var params = {
          "exchangeCorporationId": currentCorporation.corporationId ?? '',
        };

        await requestClient.request(
          RSServerUrl.exchangeToken,
          method: RequestType.post,
          data: params,
          onResponse: (ApiResponseEntity response) async {
            var tmpResponseData = response.data;

            if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
              if (tmpResponseData.containsKey("accessToken")) {
                var accessToken = tmpResponseData["accessToken"];
                if (accessToken != null) {
                  await RSAccountManager().setAccessToken(accessToken);
                  await RSAccountManager().setCorporationId(currentCorporation.corporationId!);
                  RSAccountManager().switchCorporationAction();

                  final AnalyticsLogic analyticsLogic = Get.find<AnalyticsLogic>();
                  await analyticsLogic.loadAllData();

                  refreshCallback?.call();
                } else {
                  EasyLoading.showError('accessToken is empty');
                }
              }
            } else {
              EasyLoading.showError('${response.code}\n${response.msg}');
            }
          },
          onError: (error) {
            return false;
          },
        );
      }, showLoading: true);
    }
  }
}
