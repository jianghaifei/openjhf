import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../utils/date_util.dart';
import 'compare_to_setting_state.dart';

class CompareToSettingLogic extends GetxController {
  final CompareToSettingState state = CompareToSettingState();

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

  void buildPageData(List<CompareDateRangeType>? compareToDateRangeTypes, List<DateTime> dateTimeRange) {
    state.dateTimeRange = dateTimeRange;

    var currentDateTime = [state.dateTimeRange.first, state.dateTimeRange.last];
    var tmp = RSDateUtil.getCompareToDateRangeTypes(currentDateTime);
    // 查找有交集的元素
    state.intersectingElements.clear();
    for (var element in tmp) {
      switch (element) {
        case CompareDateRangeType.yesterday:
          state.intersectingElements.add(0);
        case CompareDateRangeType.lastWeek:
          state.intersectingElements.add(1);
        case CompareDateRangeType.lastMonth:
          state.intersectingElements.add(2);
        case CompareDateRangeType.lastYear:
          state.intersectingElements.add(3);
      }
    }

    state.selectedIndexList.clear();
    compareToDateRangeTypes?.forEach((element) {
      switch (element) {
        case CompareDateRangeType.yesterday:
          state.selectedIndexList.add(0);
        case CompareDateRangeType.lastWeek:
          state.selectedIndexList.add(1);
        case CompareDateRangeType.lastMonth:
          state.selectedIndexList.add(2);
        case CompareDateRangeType.lastYear:
          state.selectedIndexList.add(3);
      }
    });
  }

  void clickConfirmAction() {
    state.compareToDateRangeTypes.clear();

    state.selectedIndexList.sort();

    for (var element in state.selectedIndexList) {
      switch (element) {
        case 0:
          state.compareToDateRangeTypes.add(CompareDateRangeType.yesterday);
        case 1:
          state.compareToDateRangeTypes.add(CompareDateRangeType.lastWeek);
        case 2:
          state.compareToDateRangeTypes.add(CompareDateRangeType.lastMonth);
        case 3:
          state.compareToDateRangeTypes.add(CompareDateRangeType.lastYear);
        default:
          state.compareToDateRangeTypes.add(CompareDateRangeType.yesterday);
      }
    }
  }
}
