import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../utils/logger/logger_helper.dart';
import '../../../../../utils/network/request.dart';
import '../../../../../utils/network/request_client.dart';
import '../../../../../utils/network/server_url.dart';
import 'order_detail_setting_state.dart';

class OrderDetailSettingLogic extends GetxController {
  final OrderDetailSettingState state = OrderDetailSettingState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    var args = Get.arguments;

    if (args != null && args is Map<String, dynamic> && args.containsKey("entityModel")) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.settingOptionsEntity.value = args["entityModel"];
        state.entity = args["entity"];
      });
    } else {
      EasyLoading.showError("Missing parameter: Entity");
      logger.w("onReady - Missing parameter: Entity", StackTrace.current);
      Get.back();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void editOrderDetailBaseOptions() async {
    await request(() async {
      var params = getRequestParams();

      await requestClient.request(RSServerUrl.editOrderDetailBaseOptions, method: RequestType.post, data: params,
          onResponse: (response) {
        debugPrint("response = $response");
        Get.back(result: true);
      }, onError: (error) {
        return false;
      });
    });
  }

  Map<String, dynamic> getRequestParams() {
    List<String?> baseIds = [];
    List<String?> showIds = [];
    state.settingOptionsEntity.value.options?.forEach((element) {
      baseIds.add(element.code);
      if (element.show) {
        showIds.add(element.code);
      }
    });
    return {
      "baseIds": baseIds,
      "showIds": showIds,
      "entity": state.entity,
    };
  }
}
