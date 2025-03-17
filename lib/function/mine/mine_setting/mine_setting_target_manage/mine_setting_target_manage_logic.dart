import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/target_manage/target_manage_edit_config_entity.dart';
import '../../../../model/target_manage/target_manage_list_targets_entity.dart';
import '../../../../utils/network/request.dart';
import '../../../../utils/network/server_url.dart';
import '../../../../widget/card_load_state_layout.dart';
import 'mine_setting_target_manage_state.dart';

class MineSettingTargetManageLogic extends GetxController {
  final MineSettingTargetManageState state = MineSettingTargetManageState();

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

  /// 目标管理-可选指标
  Future<void> getTargetsOptionalMetrics() async {
    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      TargetManageEditConfigEntity? targetManageEditConfigEntity = await requestClient
          .request(RSServerUrl.targetManageEditConfig, method: RequestType.post, data: {}, onResponse: (response) {},
              onError: (error) {
        state.errorCode = error.code;
        state.errorMessage = error.message;
        state.loadState.value = CardLoadState.stateError;

        return false;
      });

      if (targetManageEditConfigEntity != null) {
        state.targetManageEditConfigEntity.value = targetManageEditConfigEntity;

        getTargetManageListTargets();
      }
    });
  }

  /// 目标管理-获取集团下所有目标列表
  Future<void> getTargetManageListTargets({List<String>? filterMetricCodes}) async {
    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      Map<String, dynamic> params = {
        "month": state.month,
        "metricCodes": state.targetManageEditConfigEntity.value.metrics?.map((e) => e.code).toList(),
      };

      if (filterMetricCodes != null) {
        params['metricCodes'] = filterMetricCodes;
      }

      TargetManageListTargetsEntity? targetManageListTargetsEntity = await requestClient
          .request(RSServerUrl.targetManageListTargets, method: RequestType.post, data: params, onResponse: (response) {
        state.loadState.value = CardLoadState.stateSuccess;
      }, onError: (error) {
        state.errorCode = error.code;
        state.errorMessage = error.message;
        state.loadState.value = CardLoadState.stateError;

        return false;
      });

      if (targetManageListTargetsEntity != null) {
        state.targetManageListTargetsEntity.value = targetManageListTargetsEntity;
      }
    });
  }

  ///  获取指标名称
  String getMetricsTitle() {
    if (state.targetManageEditConfigEntity.value.metrics?.isEmpty ?? true) {
      return '';
    }

    // 获取选中的key
    var keys = state.targetManageEditConfigEntity.value.metrics
            ?.where((element) => element.isSelected)
            .map((e) => e.name)
            .toList() ??
        [];
    if (keys.isEmpty) {
      return '';
    }

    // 如果选中的key数量等于总数量，则返回全部
    if (keys.length == state.targetManageEditConfigEntity.value.metrics?.length) {
      return S.current.rs_all;
    }

    return keys.join(',');
  }

  /// 根据filterList数组下标，获取筛选后的MetricsCode
  List<String> getTargetManageListTargetsMetricsCode(List<int> selectedFilterList) {
    List<String> metrics = [];

    selectedFilterList.map((e) {
      return state.targetManageEditConfigEntity.value.metrics?[e].code ?? '';
    }).forEach((element) {
      metrics.add(element);
    });

    return metrics;
  }
}
