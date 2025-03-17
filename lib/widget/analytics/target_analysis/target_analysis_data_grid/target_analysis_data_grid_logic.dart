import 'dart:math';

import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../../model/target_manage/target_manage_config_entity.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../card_load_state_layout.dart';
import 'target_analysis_data_grid_state.dart';

class TargetAnalysisDataGridLogic extends GetxController {
  final TargetAnalysisDataGridState state = TargetAnalysisDataGridState();

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

  void setGridData(TargetManageOverviewShopAchievementDetail? shopAchievementDetail) {
    state.loadState.value = CardLoadState.stateLoading;

    if (shopAchievementDetail == null || shopAchievementDetail.table == null) {
      return;
    }
    // 延迟500 ms
    Future.delayed(const Duration(milliseconds: 500), () {
      state.loadState.value = CardLoadState.stateSuccess;
      state.resultStorePKTableEntity.value = StorePKTableEntity.fromJson(shopAchievementDetail.toJson());
    });
  }

  /// 根据filterList数组下标，获取筛选后的filterInfo数据
  List<List<TargetManageConfigFilterInfoAchievementFilterRule>> getFilterRules(
      TargetManageConfigFilterInfo? filterInfo, List<int> selectedFilterList) {
    List<List<TargetManageConfigFilterInfoAchievementFilterRule>> filterRules = [];
    selectedFilterList.map((index) => filterInfo?.achievementFilter?[index]).toList().forEach((element) {
      filterRules.add(element?.rule ?? []);
    });

    return filterRules;
  }

  /// 筛选数据
  StorePKTableEntity? filterData(List<List<TargetManageConfigFilterInfoAchievementFilterRule>> filterRules,
      String filterCode, TargetManageOverviewShopAchievementDetail? shopAchievementDetail,
      {bool isReturn = false}) {
    if (!isReturn) {
      state.loadState.value = CardLoadState.stateLoading;
    }
    if (shopAchievementDetail == null || shopAchievementDetail.table == null) {
      return null;
    }

    // 深拷贝源数据
    var shopAchievementDetailCopy = TargetManageOverviewShopAchievementDetail.fromJson(shopAchievementDetail.toJson());

    // 根据筛选条件，筛选数据
    shopAchievementDetailCopy.table?.rows?.removeWhere((element) {
      Map<String, dynamic> rowsData = element;

      if (rowsData.containsKey(filterCode)) {
        StorePKTableEntityTableRows? tableRow = StorePKTableEntityTableRows.fromJson(rowsData[filterCode]);
        if (tableRow.code == filterCode) {
          // 根据筛选条件，筛选数据
          bool tmp = !isMeetCondition(tableRow.value, filterRules);
          return tmp;
        }
      }
      return false;
    });

    if (shopAchievementDetailCopy.table == null) {
      return null;
    }

    if (isReturn) {
      return StorePKTableEntity.fromJson(shopAchievementDetailCopy.toJson());
    } else {
      // 延迟500 ms
      Future.delayed(const Duration(milliseconds: 500), () {
        state.loadState.value = CardLoadState.stateSuccess;
        state.resultStorePKTableEntity.value = StorePKTableEntity.fromJson(shopAchievementDetailCopy.toJson());
      });
    }

    return null;
  }

  /// 自定义筛选条件，小于1的条件
  List<List<TargetManageConfigFilterInfoAchievementFilterRule>> getCustomFilterRules(
      TargetManageConfigFilterInfo? filterInfo) {
    List<List<TargetManageConfigFilterInfoAchievementFilterRule>> filterRules = [];

    var customJson = {"filterType": "LT", "filterValue": "1"};
    filterRules.add([TargetManageConfigFilterInfoAchievementFilterRule.fromJson(customJson)]);

    return filterRules;
  }

  /// 是否符合条件，逻辑中可能存在且的关系，需要全部符合条件才返回true
  bool isMeetCondition(String? rowValue, List<List<TargetManageConfigFilterInfoAchievementFilterRule>>? rules) {
    if (rules == null || rules.isEmpty || rowValue == null || rowValue.isEmpty) {
      return true;
    }

    double rowValueDouble = double.parse(rowValue);

    bool result = false;
    for (var element in rules) {
      List<bool> innerResultList = [];
      for (var rule in element) {
        bool innerResult = false;

        double valueDouble = double.parse(rule.filterValue ?? '0');

        if (rule.filterType == EntityFilterType.EQ) {
          // =
          if (rowValueDouble == valueDouble) {
            innerResult = true;
          }
        }
        if (rule.filterType == EntityFilterType.NE) {
          // !=
          if (rowValueDouble != valueDouble) {
            innerResult = true;
          }
        }
        if (rule.filterType == EntityFilterType.GT) {
          // >
          if (rowValueDouble > valueDouble) {
            innerResult = true;
          }
        }
        if (rule.filterType == EntityFilterType.GOE) {
          // ≥
          if (rowValueDouble >= valueDouble) {
            innerResult = true;
          }
        }
        if (rule.filterType == EntityFilterType.LT) {
          // <
          if (rowValueDouble < valueDouble) {
            innerResult = true;
          }
        }
        if (rule.filterType == EntityFilterType.LOE) {
          // ≤
          if (rowValueDouble <= valueDouble) {
            innerResult = true;
          }
        }

        innerResultList.add(innerResult);
      }

      // 逻辑中可能存在且的关系，需要全部符合条件才返回true
      if (innerResultList.every((element) => element == true)) {
        result = true;
      }
    }

    return result;
  }

  /// 获取右侧标题
  String getRightTitle(TargetManageConfigFilterInfo? filterInfo) {
    if (filterInfo?.achievementFilter?.isEmpty ?? true) {
      return '';
    }

    // 获取选中的key
    var keys = filterInfo?.achievementFilter?.where((element) => element.isSelected).map((e) => e.name).toList() ?? [];
    if (keys.isEmpty) {
      return '';
    }

    // 如果选中的key数量等于总数量，则返回全部
    if (keys.length == filterInfo?.achievementFilter?.length) {
      return S.current.rs_all;
    }

    return keys.join(',');
  }

  /// 获取数据网格子视图高度
  double getDataGridSubviewHeight(int count, {StorePKTableEntity? entity}) {
    StorePKTableEntity? customEntity = entity ?? state.resultStorePKTableEntity.value;

    int rowsCount = min(customEntity.table?.rows?.length ?? 0, state.showMaxLength);

    var rowHeight = getSingleRowHeight(count) * rowsCount + 36; // 头部高度
    return rowHeight;
  }

  double getSingleRowHeight(int count) {
    switch (count) {
      case 0:
        return 65.0;
      case 1:
        return 65.0;
      case 2:
        return 85.0;
      case 3:
        return 95.0;
      case 4:
        return 110.0;
      default:
        return 110.0;
    }
  }
}
