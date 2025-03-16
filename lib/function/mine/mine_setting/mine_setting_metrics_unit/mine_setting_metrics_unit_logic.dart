import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';

import '../../../../utils/network/request.dart';
import '../../../../utils/network/request_client.dart';
import '../../../../utils/network/server_url.dart';
import '../../../analytics/analytics_logic.dart';
import 'mine_setting_metrics_unit_state.dart';

class MineSettingMetricsUnitLogic extends GetxController {
  final MineSettingMetricsUnitState state = MineSettingMetricsUnitState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("config")) {
        state.settingConfig.value = args["config"];
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void switchMetricsUnit(int index) async {
    var configType = RSUtils.enumToString(state.settingConfig.value.configType);
    var configValue = state.settingConfig.value.configOptions?[index].configValue;

    await request(() async {
      await requestClient.request(
        RSServerUrl.editUserConfig,
        method: RequestType.post,
        data: {
          'configType': configType,
          'configValue': [configValue],
        },
        onResponse: (response) {
          state.settingConfig.update((entity) {
            entity?.configOptions?.forEach((element) {
              if (element.configValue == configValue) {
                element.selected = true;
                final AnalyticsLogic logic = Get.find<AnalyticsLogic>();
                logic.loadAllData();
              } else {
                element.selected = false;
              }
            });
          });
        },
        onError: (error) {
          debugPrint('原始 error = ${error.message}');
          return false;
        },
      );
    });
  }
}
