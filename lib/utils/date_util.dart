import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';

import '../function/login/account_manager/account_manager.dart';

class RSDateUtil {
  /*
  * 时间转字符串
  * dateFormat: 时间字符串格式
  * replaceFormat：需要替换的样式
  * */
  static String timeToString(DateTime dateTime, {String? dateFormat}) {
    var date = DateUtil.formatDate(dateTime, format: dateFormat ?? DateFormats.y_mo_d);

    return date;
  }

  /// 时间范围（字符串格式）
  static String formatTimesString(List<String> range) {
    var startTime = range.first.replaceAll('-', '/');
    var endTime = range.last.replaceAll('-', '/');

    if (startTime == endTime) {
      return startTime;
    } else {
      return "$startTime-$endTime";
    }
  }

  /// 时间范围（字符串格式）
  static String dateRangeToString(List<DateTime> dateRange, {String? dateFormat}) {
    var startTime = timeToString(dateRange.first, dateFormat: dateFormat).replaceAll('-', '/');
    var endTime = timeToString(dateRange.last, dateFormat: dateFormat).replaceAll('-', '/');

    if (startTime == endTime) {
      return startTime;
    } else {
      return "$startTime-$endTime";
    }
  }

  /// 时间范围转字符串
  static List<String> dateRangeToListString(List<DateTime> dateRange) {
    var startTime = timeToString(dateRange.first);
    var endTime = timeToString(dateRange.last);

    return [startTime, endTime];
  }

  static List<DateTime> listStringToDateRange(List<String> timeRange) {
    return timeRange.map((dateString) => DateTime.parse(dateString)).toList();
  }

  /// -------------- 时间对比业务相关 --------------
  static List<CompareDateRangeType> getCompareToDateRangeTypes(List<DateTime> dateTime) {
    DateTime startDateTime = dateTime.first;
    DateTime endDateTime = dateTime.last;
    debugPrint("startDateTime:$startDateTime---endDateTime:$endDateTime");

    // 以天为单位计算差值
    int dayDiff = endDateTime.difference(startDateTime).inDays + 1; // +1 包括结束日期

    List<CompareDateRangeType> types = [];
    if (dayDiff == 1) {
      types = [
        CompareDateRangeType.yesterday,
        CompareDateRangeType.lastWeek,
        CompareDateRangeType.lastMonth,
        CompareDateRangeType.lastYear,
      ];
    } else if (dayDiff > 1 && dayDiff <= 7) {
      types = [
        CompareDateRangeType.lastWeek,
        CompareDateRangeType.lastMonth,
        CompareDateRangeType.lastYear,
      ];
    } else if (dayDiff > 7 && dayDiff <= 31) {
      types = [
        CompareDateRangeType.lastMonth,
        CompareDateRangeType.lastYear,
      ];
    } else if (dayDiff >= 31) {
      types = [
        CompareDateRangeType.lastYear,
      ];
    }

    return types;
  }

  List<DateTime> getCompareDateTimeList(List<DateTime> dateTime, CompareDateRangeType compareType) {
    DateTime startDateTime = dateTime.first;
    DateTime endDateTime = dateTime.last;

    switch (compareType) {
      case CompareDateRangeType.yesterday:
        // 获取指定日期的前一天
        DateTime startPreviousDay = startDateTime.subtract(const Duration(days: 1));
        DateTime endPreviousDay = endDateTime.subtract(const Duration(days: 1));
        return [startPreviousDay, endPreviousDay];
      case CompareDateRangeType.lastWeek:
        // 获取指定日期的前7天
        DateTime startPreviousDay = startDateTime.subtract(const Duration(days: 7));
        DateTime endPreviousDay = endDateTime.subtract(const Duration(days: 7));
        return [startPreviousDay, endPreviousDay];
      case CompareDateRangeType.lastMonth:
        // 检查所选范围是否为整月
        if (startDateTime.day == 1 && endDateTime.day == DateTime(endDateTime.year, endDateTime.month + 1, 0).day) {
          // 返回整个上个月
          DateTime prevMonthStart = DateTime(startDateTime.year, startDateTime.month - 1, 1);
          DateTime prevMonthEnd = DateTime(prevMonthStart.year, prevMonthStart.month + 1, 0);
          return [prevMonthStart, prevMonthEnd];
        } else {
          // 获取指定日期的前一月
          DateTime startPreviousDay = getValidDate(startDateTime.year, startDateTime.month - 1, startDateTime.day);
          DateTime endPreviousDay = getValidDate(endDateTime.year, endDateTime.month - 1, endDateTime.day);

          // 以天为单位计算差值
          int resultDayDiff = endPreviousDay.difference(startPreviousDay).inDays + 1; // +1 包括结束日期
          int dayDiff = endDateTime.difference(startDateTime).inDays + 1; // +1 包括结束日期

          // 多退少补天数的差值
          int difference = dayDiff - resultDayDiff;
          if (difference < 0) {
            startPreviousDay = startPreviousDay.add(Duration(days: difference));
          } else if (difference > 0) {
            startPreviousDay = startPreviousDay.subtract(Duration(days: difference));
          }

          return [startPreviousDay, endPreviousDay];
        }

      case CompareDateRangeType.lastYear:
        // 检查所选范围是否为整年
        if ((startDateTime.month == 1 && startDateTime.day == 1) &&
            (endDateTime.month == 12 && endDateTime.day == DateTime(endDateTime.year, endDateTime.month + 1, 0).day)) {
          // 返回上一整年
          DateTime prevMonthStart = DateTime(startDateTime.year - 1, 1, 1);
          DateTime prevMonthEnd = DateTime(prevMonthStart.year - 1, 12 + 1, 0);
          return [prevMonthStart, prevMonthEnd];
        } else if (startDateTime.day == 1 &&
            endDateTime.day == DateTime(endDateTime.year, endDateTime.month + 1, 0).day) {
          // 检查所选范围是否为整年
          // 返回整个去年
          DateTime prevMonthStart = DateTime(startDateTime.year - 1, startDateTime.month, 1);
          DateTime prevMonthEnd = DateTime(endDateTime.year - 1, endDateTime.month + 1, 0);
          return [prevMonthStart, prevMonthEnd];
        } else {
          // 返回去年
          DateTime startPreviousDay = DateTime(startDateTime.year - 1, startDateTime.month, startDateTime.day);
          DateTime endPreviousDay = DateTime(endDateTime.year - 1, endDateTime.month, endDateTime.day);

          // 以天为单位计算差值
          int resultDayDiff = endPreviousDay.difference(startPreviousDay).inDays + 1; // +1 包括结束日期
          int dayDiff = endDateTime.difference(startDateTime).inDays + 1; // +1 包括结束日期

          // 多退少补天数的差值
          int difference = dayDiff - resultDayDiff;
          if (difference < 0) {
            startPreviousDay = startPreviousDay.add(Duration(days: difference));
          } else if (difference > 0) {
            startPreviousDay = startPreviousDay.subtract(Duration(days: difference));
          }

          return [startPreviousDay, endPreviousDay];
        }
    }
  }

  /// 返回最近有效日期
  DateTime getValidDate(int year, int month, int day) {
    DateTime inputDate = DateTime(year, month, day);

    // 使用 Dart 内置的 DateTime 来获取当月的最后一天
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    // 如果输入日期大于当月的最后一天，则向前推到最后一天
    if (day > lastDayOfMonth.day) {
      return lastDayOfMonth; // 返回当月最后一天
    }

    // 如果是有效日期，直接返回
    return inputDate;
  }
}
