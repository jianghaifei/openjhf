import 'package:get/get.dart';

import 'custom_date_picker_state.dart';

class CustomDatePickerLogic extends GetxController {
  final CustomDatePickerState state = CustomDatePickerState();

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

  /// 将周范围转换为日期列表
  List<DateTime> convertWeekRangeToDateList() {
    int year = state.years[state.selectedYearIndex.value];
    String weekRange = state.weeks[state.selectedWeekIndex.value];

    List<DateTime> dateList = [];
    List<String> range = weekRange.split('-');
    List<String> startParts = range[0].split('/');
    List<String> endParts = range[1].split('/');

    int startMonth = int.parse(startParts[0]);
    int startDay = int.parse(startParts[1]);
    int endMonth = int.parse(endParts[0]);
    int endDay = int.parse(endParts[1]);

    DateTime startDate = DateTime(year, startMonth, startDay);
    DateTime endDate = DateTime(year, endMonth, endDay);

    if (startDate.isAfter(endDate)) {
      endDate = DateTime(year + 1, endMonth, endDay);
    }

    dateList.add(startDate);
    dateList.add(endDate);

    return dateList;
  }

  /// 生成每周日期范围
  List<String> generateWeeklyDateRanges(int year, {int startWeekday = DateTime.monday}) {
    List<String> weekRanges = [];
    DateTime currentDate = DateTime(year, 1, 1);

    while (currentDate.year == year) {
      int weekday = currentDate.weekday;
      if (weekday == startWeekday) {
        DateTime startDate = currentDate;
        DateTime endDate = startDate.add(Duration(days: 6));

        String range = "${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')} - " +
            "${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}";

        weekRanges.add(range);
      }

      currentDate = currentDate.add(Duration(days: 1));
    }

    return weekRanges;
  }

  int getIndexForCurrentYear(List<int> years, DateTime? initialDateTime) {
    DateTime now = initialDateTime ?? DateTime.now();

    int index = years.indexWhere((year) => year == now.year);
    if (index != -1) {
      return index;
    } else {
      return 0;
    }
  }

  /// 获取当前周的索引
  int getIndexForCurrentWeek(List<String> weekRanges, DateTime? initialDateTime) {
    DateTime now = initialDateTime ?? DateTime.now();
    DateTime currentWeekStart = DateTime(now.year, now.month, now.day);
    for (int i = 0; i < weekRanges.length; i++) {
      List<String> range = weekRanges[i].split('-');
      List<String> startParts = range[0].split('/');
      List<String> endParts = range[1].split('/');
      DateTime rangeStart = DateTime(now.year, int.parse(startParts[0]), int.parse(startParts[1]));
      DateTime rangeEnd = DateTime(now.year, int.parse(endParts[0]), int.parse(endParts[1]));
      if (currentWeekStart.isAfter(rangeStart) && currentWeekStart.isBefore(rangeEnd)) {
        return i;
      }
    }

    // 如果当前日期不在任何周范围内，查找最接近的周范围
    DateTime closestWeekStart = weekRanges
        .map((weekRange) => weekRange.split('-')[0].split('/'))
        .map((startParts) => DateTime(now.year, int.parse(startParts[0]), int.parse(startParts[1])))
        .reduce((a, b) => now.difference(a).inDays.abs() < now.difference(b).inDays.abs() ? a : b);

    for (int i = 0; i < weekRanges.length; i++) {
      List<String> range = weekRanges[i].split('-');
      List<String> startParts = range[0].split('/');
      DateTime rangeStart = DateTime(now.year, int.parse(startParts[0]), int.parse(startParts[1]));
      if (rangeStart.isAtSameMomentAs(closestWeekStart)) {
        return i;
      }
    }

    return 0;
  }
}
