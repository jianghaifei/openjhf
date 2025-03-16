import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:get/get.dart';

import '../../../../utils/logger/logger_helper.dart';
import '../../../../utils/network/models/api_response_entity.dart';
import '../../../../utils/network/request_client.dart';
import '../../analytics_logic.dart';
import 'analytics_add_template_state.dart';

class AnalyticsAddTemplateLogic extends GetxController {
  final AnalyticsAddTemplateState state = AnalyticsAddTemplateState();

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

  Future<void> updateTabTemplate() async {
    logger.d("updateTabTemplate", StackTrace.current);

    await request(() async {
      var params = {
        "targetTabId": state.tabTemplate?[state.selectIndexList.first].templateId,
        "sourceTabId": state.tabId,
        "navId": state.navId,
      };

      await requestClient.request(
        RSServerUrl.updateTabTemplate,
        method: RequestType.post,
        data: params,
        onResponse: (ApiResponseEntity response) {
          var tmpResponseData = response.data;

          if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
            if (tmpResponseData.containsKey("success")) {
              bool success = tmpResponseData["success"];
              if (success) {
                final AnalyticsLogic logic = Get.find<AnalyticsLogic>();
                logic.loadAllData();

                Get.until((route) => route.isFirst);
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
