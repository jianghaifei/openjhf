import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';

import '../../../../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../login/account_manager/account_manager.dart';
import 'analytics_add_filter_sub_view_state.dart';

class AnalyticsAddFilterSubViewLogic extends GetxController {
  final AnalyticsAddFilterSubViewState state = AnalyticsAddFilterSubViewState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    var args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey("filterOptions") && args.containsKey("analysisChartEntity")) {
        state.filterOptions.value = args["filterOptions"];
        state.originalAnalysisChartEntity = args["analysisChartEntity"];
        state.analysisChartEntity = MetricsEditInfoMetricsCard.fromJson(state.originalAnalysisChartEntity!.toJson());

        if (args.containsKey("defaultIndex")) {
          state.selectedFilterIndex.value = args["defaultIndex"];
        }

        if (args.containsKey("selectedFilter")) {
          state.recordSelectedFilter = args["selectedFilter"];
        }
      } else {
        EasyLoading.showError('page arguments is null');
        Get.back();
      }
    } else {
      EasyLoading.showError('page arguments is null');
      Get.back();
    }

    getAllFiltersByDims();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 获取所有过滤器
  Future<void> getAllFiltersByDims() async {
    await request(() async {
      var componentDims = [];
      for (var option in state.filterOptions) {
        var componentDim = {
          "componentType": RSUtils.enumToString(option.componentType),
          "dimCode": option.fieldCode,
        };

        componentDims.add(componentDim);
      }

      var params = {
        "shopIds": RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
        "componentDims": componentDims,
      };

      AnalyticsEntityFilterComponentEntity? entity = await requestClient.request(RSServerUrl.filtersByDims,
          method: RequestType.post, data: params, onResponse: (response) {}, onError: (error) {
        return false;
      });

      if (entity != null) {
        state.entity = entity;
        setDefaultFilters();
      }
    }, showLoading: true);
  }

  void setDefaultFilters() {
    if (state.recordSelectedFilter != null &&
        state.recordSelectedFilter?.bindOptionsValue != null &&
        state.entity.filters != null &&
        state.entity.filters!.isNotEmpty) {
      // 用于存储匹配的下标
      List<int> matchingIndices = [];

      state.entity.filters?.forEach((element) {
        if (element.fieldCode == state.recordSelectedFilter?.fieldCode) {
          // 遍历element.options，找到和state.filterOptions[index].bindOptionsValue相交的元素，并获取到对应下标，加入到matchingIndices数组中
          if (element.options != null && element.options!.isNotEmpty) {
            for (int index = 0; index < element.options!.length; index++) {
              // 获取当前选项的 value
              List<String>? currentValue = element.options![index].value;
              if (currentValue != null && currentValue.isNotEmpty) {
                // 检查是否有目标值在当前 value 中
                for (String target in state.recordSelectedFilter!.bindOptionsValue!) {
                  if (currentValue.contains(target)) {
                    matchingIndices.add(index);
                    break;
                  }
                }
              }
            }
          }
        }
      });
      debugPrint("matchingIndices: $matchingIndices");

      if (matchingIndices.isNotEmpty) {
        state.selectedFilterBindOptionIndex.value = matchingIndices;
      }
    }
  }

  /// 获取已选指标过滤器
  Future<AnalyticsEntityFilterComponentFilters?> getSelectedMetricFilterByDims() async {
    if (state.entity.filters == null) {
      if (state.loopCount < 3) {
        await getAllFiltersByDims();
        getSelectedMetricFilterByDims();
        state.loopCount++;
      } else {
        state.loopCount = 0;
        EasyLoading.showError('Failed to obtain indicator filter');
      }
    } else {
      if (state.selectedFilterIndex.value == -1) {
        return null;
      }
      var tmpFieldCode = state.filterOptions[state.selectedFilterIndex.value].fieldCode;

      AnalyticsEntityFilterComponentFilters? filter =
          state.entity.filters?.firstWhere((element) => element.fieldCode == tmpFieldCode);

      return filter;
    }
    return null;
  }
}
