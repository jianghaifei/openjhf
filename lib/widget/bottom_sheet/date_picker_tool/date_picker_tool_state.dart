import 'package:flutter/material.dart';

// enum QuickDateType {
//   today,
//   yesterday,
//   lastWeek,
//   thisWeek,
//   lastMonth,
//   thisMonth,
// }

class DatePickerToolState {
  // late TabController tabController;

  // final List<String> tabs = [S.current.rs_date_tool_quick, S.current.rs_date_tool_custom];

  // var selectedQuickDateIndex = 0.obs;

  List<DateTime?> rangeDatePickerDefaultValue = [];

  // var quickListData = [
  //   S.current.rs_date_tool_today,
  //   S.current.rs_date_tool_yesterday,
  //   S.current.rs_date_tool_last_week,
  //   S.current.rs_date_tool_this_week,
  //   S.current.rs_date_tool_last_month,
  //   S.current.rs_date_tool_this_month,
  // ];

  // QuickDateType quickDateTypeFromIndex(int index) {
  //   switch (index) {
  //     case 0:
  //       return QuickDateType.today;
  //     case 1:
  //       return QuickDateType.yesterday;
  //     case 2:
  //       return QuickDateType.lastWeek;
  //     case 3:
  //       return QuickDateType.thisWeek;
  //     case 4:
  //       return QuickDateType.lastMonth;
  //     case 5:
  //       return QuickDateType.thisMonth;
  //     default:
  //       return QuickDateType.today;
  //   }
  // }

  DatePickerToolState() {
    ///Initialize variables
    debugPrint("DatePickerToolState Initialize variables");

    rangeDatePickerDefaultValue = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    ];
  }
}
