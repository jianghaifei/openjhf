import 'package:flustars/flustars.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:get/get.dart';

import '../../../config/rs_locale.dart';
import '../../../generated/l10n.dart';
import '../../../utils/date_util.dart';
import 'custom_date_tool_widget_state.dart';

enum CustomDateToolEnum {
  // 日
  DAY,
  // 周
  WEEK,
  // 月
  MONTH,
}

class CustomDateToolWidgetLogic extends GetxController {
  final CustomDateToolWidgetState state = CustomDateToolWidgetState();

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

  String getCurrentDateRangeTitle() {
    if (state.currentDateToolEnumType.value == CustomDateToolEnum.MONTH) {
      return RSDateUtil.dateRangeToString([state.startDate.value, state.endDate.value], dateFormat: DateFormats.y_mo);
    } else {
      return RSDateUtil.dateRangeToString([state.startDate.value, state.endDate.value]);
    }
  }

  void updateTimeRange(List<String> timeRange) {
    state.startDate.value = DateTime.tryParse(timeRange.first) ?? state.startDate.value;
    state.endDate.value = DateTime.tryParse(timeRange.last) ?? state.endDate.value;

    if (state.currentDateToolEnumType.value == CustomDateToolEnum.MONTH) {
      getDateRangeIsLast(DateTime(state.endDate.value.year, state.endDate.value.month),
          DateTime(DateTime.now().year, DateTime.now().month));
    } else {
      getDateRangeIsLast(state.endDate.value, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }
    getCurrentDateRangeTitle();
  }

  /// 前进
  List<DateTime> forwardFindDate(List<DateTime> dateRange) {
    DateTime startDate = dateRange.first;
    DateTime endDate = dateRange.last;

    /// 当前时间
    var currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (state.currentDateToolEnumType.value == CustomDateToolEnum.DAY) {
      startDate = startDate.add(const Duration(days: 1));
      endDate = endDate.add(const Duration(days: 1));
    } else if (state.currentDateToolEnumType.value == CustomDateToolEnum.WEEK) {
      startDate = startDate.add(const Duration(days: 7));
      endDate = endDate.add(const Duration(days: 7));
    } else {
      currentDateTime = DateTime(DateTime.now().year, DateTime.now().month);
      startDate = DateTime(startDate.year, startDate.month + 1, 1);
      endDate = DateTime(endDate.year, endDate.month + 2, 0);
      // 前进至当月时，取当月的最新一天即可，不需要取未来
      if (DateTime(endDate.year, endDate.month) == currentDateTime) {
        endDate = DateTime(endDate.year, currentDateTime.month, DateTime.now().day);
      }
    }

    getDateRangeIsLast(endDate, currentDateTime);

    state.startDate.value = startDate;
    state.endDate.value = endDate;

    return [startDate, endDate];
  }

  /// 后退
  List<DateTime> backwardFindDate(List<DateTime> dateRange) {
    DateTime startDate = dateRange.first;
    DateTime endDate = dateRange.last;

    /// 当前时间
    var currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (state.currentDateToolEnumType.value == CustomDateToolEnum.DAY) {
      startDate = startDate.subtract(const Duration(days: 1));
      endDate = endDate.subtract(const Duration(days: 1));
    } else if (state.currentDateToolEnumType.value == CustomDateToolEnum.WEEK) {
      startDate = startDate.subtract(const Duration(days: 7));
      endDate = endDate.subtract(const Duration(days: 7));
    } else {
      currentDateTime = DateTime(DateTime.now().year, DateTime.now().month);

      startDate = DateTime(startDate.year, startDate.month - 1, 1);
      endDate = DateTime(endDate.year, endDate.month, 0);
    }

    getDateRangeIsLast(endDate, currentDateTime);

    state.startDate.value = startDate;
    state.endDate.value = endDate;

    return [startDate, endDate];
  }

  /// 是否是最新一天
  void getDateRangeIsLast(DateTime currentDate, DateTime comparisonDate) {
    if (!state.enableMaxDate) {
      state.isLast.value = false;
      return;
    }
    if (state.currentDateToolEnumType.value == CustomDateToolEnum.DAY) {
      comparisonDate = comparisonDate.add(const Duration(days: 1));
    }
    // 时间相等或之后，返回 true
    var tmp = currentDate.isAtSameMomentAs(comparisonDate) || currentDate.isAfter(comparisonDate);
    state.isLast.value = tmp;
  }

  void getCompareDateRangeTitle(
      List<CompareDateRangeType>? types,
      Function(
        List<CompareDateRangeType>? compareDateRangeTypes,
        List<List<DateTime>>? compareDateTimeRanges,
        List<DateTime> displayTime,
        CustomDateToolEnum customDateToolEnum,
      ) callback) {
    // 是否已经回调
    bool isCallback = false;

    if (types != null && types.isNotEmpty) {
      var commonElements = findIntersectingElements(types);

      List<List<DateTime>> compareDateTimeList = [];
      for (var element in commonElements) {
        compareDateTimeList
            .add(RSDateUtil().getCompareDateTimeList([state.startDate.value, state.endDate.value], element));
      }

      callback.call(commonElements, compareDateTimeList, [state.startDate.value, state.endDate.value],
          state.currentDateToolEnumType.value);
      isCallback = true;
    }
    if (!isCallback) {
      callback.call(null, null, [state.startDate.value, state.endDate.value], state.currentDateToolEnumType.value);
    }
  }

  // 查找有交集的元素
  List<CompareDateRangeType> findIntersectingElements(List<CompareDateRangeType> types) {
    if (types.isNotEmpty) {
      var currentDateTime = [state.startDate.value, state.endDate.value];
      var compareToDateRangeTypes = RSDateUtil.getCompareToDateRangeTypes(currentDateTime);

      var set1 = types.toSet();
      var set2 = compareToDateRangeTypes.toSet();
      // 计算交集并转换回列表
      var commonElements = set1.intersection(set2).toList();

      return commonElements;
    } else {
      return [];
    }
  }

  bool getCurrentCompareDateTypesIsEmpty(List<CompareDateRangeType>? types) {
    if (types == null || types.isEmpty) {
      return true;
    }

    var commonElements = findIntersectingElements(types);

    if (commonElements.isEmpty) {
      return true;
    } else {
      List<String> titles = [];
      for (var element in commonElements) {
        titles.add(returnCompareDateRangeTypeTranslateString(element));
      }

      if (titles.isNotEmpty) {
        var tmp = "${S.current.rs_compared}: ${titles.join('/')}";
        if (tmp != state.compareDateRangeTypesTitle.value) {
          state.compareDateRangeTypesTitle.value = tmp;
        }
      }

      return false;
    }
  }

  String returnCompareDateRangeTypeTranslateString(CompareDateRangeType type) {
    bool ifCn = RSLocale().locale?.languageCode == 'zh';

    String title = "";

    switch (type) {
      case CompareDateRangeType.yesterday:
        title = ifCn ? S.current.rs_date_tool_yesterday : "DoD";
      case CompareDateRangeType.lastWeek:
        title = ifCn ? S.current.rs_date_tool_last_week : "WoW";
      case CompareDateRangeType.lastMonth:
        title = ifCn ? S.current.rs_date_tool_last_month : "MoM";
      case CompareDateRangeType.lastYear:
        title = ifCn ? S.current.rs_date_tool_last_year : "YoY";
    }
    return title;
  }
}
