import 'dart:math';

import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../utils/logger/logger_helper.dart';
import 'analytics_entity_list_drawer_state.dart';

class AnalyticsEntityListDrawerLogic extends GetxController {
  final AnalyticsEntityListDrawerState state = AnalyticsEntityListDrawerState();

  @override
  void onReady() {
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  void handleData(List<double?>? limitNum, String filterTypeString) {
    logger.d("handleData", StackTrace.current);

    state.currentSymbol.value = filterTypeString;

    if (limitNum != null) {
      if (limitNum.length == 1) {
        state.minimumController.text = limitNum.first!.toStringAsFixed(2);
      }
      if (limitNum.length == 2) {
        state.minimumController.text = limitNum.first!.toStringAsFixed(2);
        state.maximumController.text = limitNum.last!.toStringAsFixed(2);
      }
    }
  }

  void handleModelData(List<double?> limitList, List<AnalyticsEntityFilterComponentFilters>? filters) {
    if (limitList.isNotEmpty) {
      filters?.forEach((element) {
        if (element.componentType == EntityComponentType.NUM_FILTER) {
          element.filterType = AnalyticsTools().returnFilterType(state.currentSymbol.value);

          var tmpModel = AnalyticsEntityFilterComponentFiltersOptions();
          tmpModel.value = limitList.map((e) => e?.toString() ?? '').toList();

          element.options = [tmpModel];
        }
      });
    }
  }

  List<double?> returnLimitList() {
    double? minNum, maxNum;
    if (state.minimumController.text.isNotEmpty) {
      minNum = double.tryParse(state.minimumController.text) ?? 0;
    }
    if (state.maximumController.text.isNotEmpty) {
      maxNum = double.tryParse(state.maximumController.text) ?? 0;
    }

    if (state.currentSymbol.value == "~") {
      if (minNum != null || maxNum != null) {
        minNum ??= 0;
        maxNum ??= 0;
        return [min(minNum, maxNum), max(minNum, maxNum)];
      } else {
        return [];
      }
    } else {
      if (minNum == null && maxNum == null) {
        return [];
      }

      return [minNum];
    }
  }

  void cleanAllData(List<AnalyticsEntityFilterComponentFilters>? filters) {
    filters?.forEach((element) {
      if (element.options != null && element.options!.isNotEmpty) {
        element.options?.forEach((option) {
          option.isSelected = false;
        });
      }
      if (element.componentType == EntityComponentType.NUM_FILTER) {
        element.options?.clear();
      }
    });
    state.minimumController.clear();
    state.maximumController.clear();
  }

  bool getIfShowRange(List<AnalyticsEntityFilterComponentFilters>? filters) {
    /// 过滤出应该展示的
    filters?.forEach((element) {
      if (element.componentType == EntityComponentType.NUM_FILTER) {
        state.ifShowRange = true;
      }
    });
    return state.ifShowRange;
  }
}
