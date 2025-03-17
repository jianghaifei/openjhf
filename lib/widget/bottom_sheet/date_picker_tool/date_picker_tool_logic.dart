import 'package:get/get.dart';

import 'date_picker_tool_state.dart';

class DatePickerToolLogic extends GetxController {
  final DatePickerToolState state = DatePickerToolState();

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

  void loadUIData(int? index, List<String> range) {
    // if (index != null) {
    //   state.selectedQuickDateIndex.value = index;
    // } else {
    DateTime startTime = DateTime.parse(range.first);
    DateTime endTime = DateTime.parse(range.last);

    state.rangeDatePickerDefaultValue = [startTime, endTime];
    // }
  }

  // List<String> getDateTimeFromType(QuickDateType dateType) {
  //   List<String> dates = [];
  //
  //   DateTime currentDate = DateTime.now();
  //
  //   switch (dateType) {
  //     case QuickDateType.today:
  //       dates = [RSDateUtil.timeToString(currentDate), RSDateUtil.timeToString(currentDate)];
  //
  //       break;
  //     case QuickDateType.yesterday:
  //       var s = currentDate.subtract(const Duration(days: 1));
  //
  //       dates = [RSDateUtil.timeToString(s), RSDateUtil.timeToString(s)];
  //
  //       break;
  //     case QuickDateType.lastWeek:
  //       // 获取当前日期的星期几（1表示星期一，7表示星期日）
  //       int currentWeekday = currentDate.weekday;
  //       // 获取当前日期的上周周一的日期
  //       DateTime lastMonday = currentDate.subtract(Duration(days: currentWeekday - 1 + 7));
  //       // 获取上周周日的日期
  //       DateTime lastSunday = lastMonday.add(const Duration(days: 6));
  //
  //       dates = [RSDateUtil.timeToString(lastMonday), RSDateUtil.timeToString(lastSunday)];
  //
  //       break;
  //     case QuickDateType.thisWeek:
  //       // 获取当前日期的星期几（1表示星期一，7表示星期日）
  //       int currentWeekday = currentDate.weekday;
  //
  //       // 获取本周第一天的日期
  //       DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentWeekday - 1));
  //
  //       dates = [RSDateUtil.timeToString(firstDayOfWeek), RSDateUtil.timeToString(currentDate)];
  //
  //       break;
  //     case QuickDateType.lastMonth:
  //       // 获取上月第一天的日期
  //       DateTime firstDayOfLastMonth = DateTime(currentDate.year, currentDate.month - 1, 1);
  //
  //       // 获取本月第一天的日期
  //       DateTime firstDayOfCurrentMonth = DateTime(currentDate.year, currentDate.month, 1);
  //
  //       // 获取上月最后一天的日期
  //       DateTime lastDayOfLastMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));
  //
  //       dates = [RSDateUtil.timeToString(firstDayOfLastMonth), RSDateUtil.timeToString(lastDayOfLastMonth)];
  //       break;
  //     case QuickDateType.thisMonth:
  //       // 获取本月第一天的日期
  //       DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
  //
  //       dates = [RSDateUtil.timeToString(firstDayOfMonth), RSDateUtil.timeToString(currentDate)];
  //       break;
  //
  //     default:
  //   }
  //
  //   return dates;
  // }
}
