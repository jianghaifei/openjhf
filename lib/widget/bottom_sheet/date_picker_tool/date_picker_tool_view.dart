import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_report_project/widget/custom_date_picker/custom_date_picker_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../utils/date_util.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import 'date_picker_tool_logic.dart';

typedef SelectedTimeRangeCallBack = Function(List<String> timeRange, int? selectIndex);

class DatePickerToolPage extends StatefulWidget {
  const DatePickerToolPage({
    super.key,
    this.selectedQuickDateIndex,
    required this.rangeDateString,
    required this.selectedTimeRangeCallBack,
    this.homeDateToolType,
    this.enableMaxDate = true,
  });

  final int? selectedQuickDateIndex;
  final List<String> rangeDateString;
  final SelectedTimeRangeCallBack selectedTimeRangeCallBack;

  final CustomDateToolEnum? homeDateToolType;

  // 是否启用最大日期
  final bool enableMaxDate;

  @override
  State<DatePickerToolPage> createState() => _DatePickerToolPageState();
}

class _DatePickerToolPageState extends State<DatePickerToolPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(DatePickerToolLogic());
  final state = Get.find<DatePickerToolLogic>().state;

  @override
  void dispose() {
    // state.tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("rangeDateString : ${widget.rangeDateString}");
    // int tabIndex = 0;
    // if (widget.selectedQuickDateIndex == null) {
    //   tabIndex = 1;
    // }

    // state.tabController = TabController(length: state.tabs.length, vsync: this, initialIndex: tabIndex);

    logic.loadUIData(widget.selectedQuickDateIndex, widget.rangeDateString);
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(
      title: S.current.rs_choose_date,
      maxHeight: widget.homeDateToolType == CustomDateToolEnum.DAY ? 0.7 : 0.5,
      children: [
        _buildCustomDateWidget(),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : 0),
          child: _createFooterWidget(),
        ),
      ],
    );
  }

  // Widget _createTabControllerWidget() {
  // return _buildCustomDateWidget();
  // return RSTabControllerWidgetPage(
  //     tabController: state.tabController,
  //     isScrollable: false,
  //     tabs: state.tabs,
  //     tabBarViews: [
  //       _createQuickWidget(),
  //       _buildCustomDateWidget(),
  //     ]);
  // }

  Widget _buildCustomDateWidget() {
    if (widget.homeDateToolType == CustomDateToolEnum.MONTH) {
      return _createCustomYearMonthWidget();
    } else if (widget.homeDateToolType == CustomDateToolEnum.WEEK) {
      return _createCustomWeekWidget();
    } else {
      return _createCalendarWidget();
    }
  }

  Widget _createCustomWeekWidget() {
    return CustomDatePickerPage(
      type: CustomDatePickerViewType.weekType,
      initialDateTime: state.rangeDatePickerDefaultValue.first,
      dateTimeValueChanged: (List<DateTime> value) {
        if (value.length == 2) {
          state.rangeDatePickerDefaultValue = value;

          debugPrint("startTime:${value.first}\nendTime:${value.last}");
        } else {
          EasyLoading.showInfo("Please select date range");
        }
      },
    );
  }

  Widget _createCustomYearMonthWidget() {
    var rangeDateTime = DateTime.tryParse(widget.rangeDateString.first);

    return CustomDatePickerPage(
        type: CustomDatePickerViewType.monthType,
        enableMaxDate: widget.enableMaxDate,
        initialDateTime: rangeDateTime,
        dateTimeValueChanged: (List<DateTime> value) {
          state.rangeDatePickerDefaultValue = value;
        });
  }

  // Widget _createQuickWidget() {
  //   return ListView.separated(
  //       padding: EdgeInsets.only(top: 12.h),
  //       itemBuilder: (BuildContext context, int index) {
  //         return Obx(() {
  //           return returnItemWidget(index);
  //         });
  //       },
  //       separatorBuilder: (BuildContext context, int index) {
  //         return SizedBox(height: 12.h);
  //       },
  //       itemCount: state.quickListData.length);
  // }

  // Widget returnItemWidget(int index) {
  //   return InkWell(
  //     onTap: () {
  //       state.selectedQuickDateIndex.value = index;
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 16.w),
  //       padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
  //       alignment: Alignment.centerLeft,
  //       decoration: BoxDecoration(
  //         color: state.selectedQuickDateIndex.value == index
  //             ? RSColor.color_0xFF5C57E6.withOpacity(0.1)
  //             : RSColor.color_0xFFF3F3F3,
  //         borderRadius: BorderRadius.all(Radius.circular(9.r)),
  //       ),
  //       child: Text(
  //         state.quickListData[index],
  //         style: TextStyle(
  //           color: state.selectedQuickDateIndex.value == index ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
  //           fontSize: 14.sp,
  //           fontWeight: state.selectedQuickDateIndex.value == index ? FontWeight.w600 : FontWeight.w400,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _createCalendarWidget() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      // calendarViewMode: CalendarDatePicker2Mode.scroll,
      scrollViewConstraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      selectedDayHighlightColor: RSColor.color_0xFF5C57E6,
      selectedRangeHighlightColor: RSColor.color_0xFF5C57E6.withOpacity(0.1),
      centerAlignModePicker: true,
      rangeBidirectional: true,
      hideMonthPickerDividers: true,
      hideYearPickerDividers: true,
      lastDate: DateTime.now().add(const Duration(days: 1)),
      // dayBorderRadius: BorderRadius.all(Radius.circular(6.r)),
      // dayMaxWidth: 48,
      dayTextStyle: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      selectedDayTextStyle: TextStyle(
        color: RSColor.color_0xFFFFFFFF,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      weekdayLabelTextStyle: TextStyle(
        color: RSColor.color_0x60000000,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      controlsTextStyle: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );

    return Flexible(
      child: SingleChildScrollView(
        child: CalendarDatePicker2(
          config: config,
          value: state.rangeDatePickerDefaultValue,
          onValueChanged: (dates) {
            state.rangeDatePickerDefaultValue = dates;
            debugPrint("onValueChanged: $dates");
          },
        ),
      ),
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () => clickAction("applyAction"),
          child: Container(
            width: 1.sw - 32,
            height: 40,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: RSColor.color_0xFF5C57E6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
            ),
            child: Text(
              S.current.rs_confirm,
              style: TextStyle(
                color: RSColor.color_0xFFFFFFFF,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void clickAction(String action) {
    if (action == "applyAction") {
      // if (state.tabController.index == 0) {
      //   var strings = logic.getDateTimeFromType(state.quickDateTypeFromIndex(state.selectedQuickDateIndex.value));
      //   widget.selectedTimeRangeCallBack.call(strings, state.selectedQuickDateIndex.value);
      // } else {
      if (state.rangeDatePickerDefaultValue.isEmpty) {
        EasyLoading.showInfo("Please select date range");
        return;
      }
      List<String> dates = [];
      for (var element in state.rangeDatePickerDefaultValue) {
        if (element != null) {
          dates.add(RSDateUtil.timeToString(element));
        }
      }

      if (dates.length == 1) {
        dates.add(dates.first);
      }

      widget.selectedTimeRangeCallBack.call(dates, null);
      // }
      Get.back();
    } else {
      EasyLoading.showError("Not Found Method");
    }
  }
}
