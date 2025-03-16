import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:get/get.dart';

import '../../../model/target_manage/target_manage_config_entity.dart';
import '../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../utils/network/request.dart';
import '../../card_load_state_layout.dart';
import 'target_analysis_state.dart';

class TargetAnalysisLogic extends GetxController {
  final TargetAnalysisState state = TargetAnalysisState();

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

  /// 目标管理-获取目标达成页面配置信息
  Future<void> getTargetAnalysisConfig() async {
    await request(() async {
      state.loadState.value = CardLoadState.stateLoading;

      TargetManageConfigEntity? targetManageConfigEntity = await requestClient.request(RSServerUrl.targetManageConfig,
          method: RequestType.post, data: {}, onResponse: (response) {}, onError: (error) {
        state.errorCode = error.code;
        state.errorMessage = error.message;
        state.loadState.value = CardLoadState.stateError;
        return false;
      });

      if (targetManageConfigEntity != null) {
        state.targetManageConfigEntity.value = targetManageConfigEntity;
        if (targetManageConfigEntity.metrics != null && targetManageConfigEntity.metrics!.isNotEmpty) {
          if (state.metricCode != null) {
            state.selectedMetric.value =
                targetManageConfigEntity.metrics!.firstWhere((element) => element.code == state.metricCode);
          }
        }

        getTargetAnalysisOverview();
      }
    });
  }

  /// 目标管理-目标达成概览页
  Future<void> getTargetAnalysisOverview() async {
    await request(() async {
      List<String> shopIds = state.selectedShops.map((e) => e.shopId ?? "").toList();

      Map<String, dynamic> params = {
        "shopIds": state.selectedShops.isNotEmpty ? shopIds : state.shopIds,
        "date": state.timeRange,
        "metricCode": state.metricCode,
        "dateType": state.customDateToolEnum.name,
      };

      state.loadState.value = CardLoadState.stateLoading;

      TargetManageOverviewEntity? targetManageOverviewEntity = await requestClient
          .request(RSServerUrl.targetManageOverview, method: RequestType.post, data: params, onResponse: (response) {
        state.loadState.value = CardLoadState.stateSuccess;
      }, onError: (error) {
        state.errorCode = error.code;
        state.errorMessage = error.message;
        state.loadState.value = CardLoadState.stateError;
        return false;
      });

      if (targetManageOverviewEntity != null) {
        state.targetManageOverviewEntity.value = targetManageOverviewEntity;
      }
    });
  }
}
