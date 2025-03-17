import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/utils/date_util.dart';
import 'package:flutter_report_project/widget/bottom_sheet/date_picker_tool/date_picker_tool_view.dart';
import 'package:flutter_report_project/widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_state.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:get/get.dart';

import '../../../config/rs_locale.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../bottom_sheet/compare_to_setting/compare_to_setting_view.dart';
import 'custom_date_tool_widget_logic.dart';

typedef DateTimeRangesCallback = Function(
  List<CompareDateRangeType>? types,
  List<List<DateTime>>? compareDateTimeRanges,
  List<DateTime> displayTime,
  CustomDateToolEnum customDateToolEnum,
);

class CustomDateToolWidgetPage extends StatefulWidget {
  const CustomDateToolWidgetPage({
    super.key,
    this.compareDateRangeTypes,
    this.customDateToolEnum,
    this.displayTime,
    required this.dateTimeRangesCallback,
    this.isShowCompareWidget = true,
    this.isShowSwitchTimeEnumWidget = true,
    this.enableMaxDate = true,
  });

  // -------时间相关-------
  final List<CompareDateRangeType>? compareDateRangeTypes;
  final List<DateTime>? displayTime;
  final CustomDateToolEnum? customDateToolEnum;
  final DateTimeRangesCallback dateTimeRangesCallback;

  // -------对比相关-------

  /// 启用最大日期
  final bool enableMaxDate;

  /// 是否显示对比视图
  final bool isShowCompareWidget;

  /// 是否显示切换时间枚举视图
  final bool isShowSwitchTimeEnumWidget;

  @override
  State<CustomDateToolWidgetPage> createState() => _CustomDateToolWidgetPageState();
}

class _CustomDateToolWidgetPageState extends State<CustomDateToolWidgetPage> {
  final String tag = '${DateTime.now().millisecondsSinceEpoch}';

  CustomDateToolWidgetLogic get logic => Get.find<CustomDateToolWidgetLogic>(tag: tag);

  CustomDateToolWidgetState get state => Get.find<CustomDateToolWidgetLogic>(tag: tag).state;

  @override
  void dispose() {
    Get.delete<CustomDateToolWidgetLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(CustomDateToolWidgetLogic(), tag: tag);

    state.enableMaxDate = widget.enableMaxDate;

    // 是否有默认对比类型
    if (widget.compareDateRangeTypes != null) {
      state.compareDateRangeTypes.value = widget.compareDateRangeTypes!;
    } else {
      var compareToDateRangeTypes = RSAccountManager().getCompareDateRangeTypeStrings();
      state.compareDateRangeTypes.value = compareToDateRangeTypes;
    }

    // 是否有默认月/日
    if (widget.customDateToolEnum != null) {
      state.currentDateToolEnumType.value = widget.customDateToolEnum!;
    }

    // 是否有默认时间
    if (widget.displayTime != null && widget.displayTime!.isNotEmpty) {
      state.startDate.value = widget.displayTime!.first;
      state.endDate.value = widget.displayTime!.last;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);

      logic.getDateRangeIsLast(
          state.endDate.value, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    });

    debugPrint("initState");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isShowCompareWidget ? 60 : 30,
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _buildLeftDateWidget(),
                if (widget.isShowSwitchTimeEnumWidget) const SizedBox(width: 12),
                if (widget.isShowSwitchTimeEnumWidget) _buildRightDayOrMonthWidget(),
              ],
            ),
            if (widget.isShowCompareWidget) const SizedBox(height: 8),
            if (widget.isShowCompareWidget) _buildCompareWidget(),
            if (widget.isShowCompareWidget) const SizedBox(height: 4),
          ],
        );
      }),
    );
  }

  Widget _buildLeftDateWidget() {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          InkWell(
              onTap: () {
                logic.backwardFindDate([state.startDate.value, state.endDate.value]);

                logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);
              },
              child: const Image(
                image: AssetImage(Assets.imageDateChevronLeftCircle),
              )),
          const SizedBox(width: 4),
          Flexible(
            child: InkWell(
              onTap: () {
                var timeRangeString = RSDateUtil.dateRangeToListString([state.startDate.value, state.endDate.value]);
                Get.bottomSheet(
                    DatePickerToolPage(
                        homeDateToolType: state.currentDateToolEnumType.value,
                        selectedQuickDateIndex: null,
                        rangeDateString: timeRangeString,
                        selectedTimeRangeCallBack: (timeRange, selectIndex) {
                          // 时间范围 [2023-12-17, 2023-12-17]
                          debugPrint("clickTimeAction - $timeRange --- ($selectIndex)");

                          state.timeRange = timeRange;
                          // state.selectedQuickDateIndex = selectIndex;

                          logic.updateTimeRange(timeRange);

                          logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);
                        }),
                    isScrollControlled: true);
              },
              child: Text(
                logic.getCurrentDateRangeTitle(),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
              onTap: () {
                if (!state.isLast.value) {
                  logic.forwardFindDate([state.startDate.value, state.endDate.value]);
                  logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);
                }
              },
              child: Image(
                image: AssetImage(
                    state.isLast.value ? Assets.imageDateChevronRightCircleGray : Assets.imageDateChevronRightCircle),
                gaplessPlayback: true,
              )),
        ],
      ),
    );
  }

  Widget _buildRightDayOrMonthWidget() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildTypeTextWidget(RSLocale().locale?.languageCode == 'zh' ? '日' : 'D', CustomDateToolEnum.DAY),
          const SizedBox(width: 12),
          _buildTypeTextWidget(RSLocale().locale?.languageCode == 'zh' ? '周' : 'W', CustomDateToolEnum.WEEK),
          const SizedBox(width: 12),
          _buildTypeTextWidget(RSLocale().locale?.languageCode == 'zh' ? '月' : 'M', CustomDateToolEnum.MONTH),
        ],
      ),
    );
  }

  Widget _buildCompareWidget() {
    bool isEmpty = logic.getCurrentCompareDateTypesIsEmpty(state.compareDateRangeTypes);

    Widget compareWidget;
    if (isEmpty) {
      compareWidget = Text(
        '${S.current.rs_compare} +',
        style: TextStyle(
          color: RSColor.color_0xFF5C57E6,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      compareWidget = Flexible(
        child: Text(
          state.compareDateRangeTypesTitle.value,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: RSColor.color_0x90000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ExpandableTextButtonPage(
        textWidget: compareWidget,
        iconWidget: !isEmpty
            ? const Image(
                image: AssetImage(Assets.imageArrowDropDown),
              )
            : null,
        onPressed: () async {
          await Get.bottomSheet(
            CompareToSettingPage(
              currentDateTimeRange: [state.startDate.value, state.endDate.value],
              compareToDateRangeTypes: state.compareDateRangeTypes,
              compareToSettingCallBack: (
                List<CompareDateRangeType>? compareToDateRangeTypes,
              ) {
                debugPrint("compareToDateRangeTypes = $compareToDateRangeTypes");
                if (compareToDateRangeTypes != null) {
                  if (compareToDateRangeTypes != state.compareDateRangeTypes) {
                    state.compareDateRangeTypes.value = compareToDateRangeTypes;
                  }
                } else {
                  state.compareDateRangeTypes.clear();
                }

                logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);
              },
            ),
            isScrollControlled: true,
          );
        });
  }

  Widget _buildTypeTextWidget(String title, CustomDateToolEnum type) {
    return Flexible(
      child: InkWell(
        onTap: () {
          if (state.currentDateToolEnumType.value != type) {
            state.currentDateToolEnumType.value = type;

            var currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

            if (type == CustomDateToolEnum.DAY) {
              state.startDate.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              state.endDate.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            } else if (type == CustomDateToolEnum.WEEK) {
              DateTime currentDate = DateTime.now();
              int currentWeekday = currentDate.weekday;

              state.startDate.value = currentDate.subtract(Duration(days: currentWeekday - 1));
              state.endDate.value = currentDate.add(Duration(days: 7 - currentWeekday));
            } else {
              currentDateTime = DateTime(DateTime.now().year, DateTime.now().month);

              state.startDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
              state.endDate.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            }

            logic.getCompareDateRangeTitle(state.compareDateRangeTypes, widget.dateTimeRangesCallback);

            logic.getDateRangeIsLast(state.endDate.value, currentDateTime);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),

          // decoration: state.currentDateToolEnumType.value == type
          //     ? ShapeDecoration(
          //         color: RSColor.color_0xFFF3F3F3,
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          //       )
          //     : null,
          decoration: state.currentDateToolEnumType.value == type
              ? ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
              : null,
          child: AutoSizeText(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxFontSize: 14,
            minFontSize: 12,
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
