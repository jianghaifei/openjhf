import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../config/rs_locale.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import '../rs_bottom_sheet_widget.dart';
import 'compare_to_setting_logic.dart';

typedef CompareToSettingCallBack = Function(
  List<CompareDateRangeType>? compareToDateRangeTypes,
);

class CompareToSettingPage extends StatefulWidget {
  const CompareToSettingPage({
    super.key,
    required this.currentDateTimeRange,
    required this.compareToDateRangeTypes,
    required this.compareToSettingCallBack,
  });

  /// 当前选择的时间范围
  final List<DateTime> currentDateTimeRange;

  /// 对比类型
  final List<CompareDateRangeType>? compareToDateRangeTypes;

  /// 对比类型回调
  final CompareToSettingCallBack compareToSettingCallBack;

  @override
  State<CompareToSettingPage> createState() => _CompareToSettingPageState();
}

class _CompareToSettingPageState extends State<CompareToSettingPage> {
  final logic = Get.put(CompareToSettingLogic());
  final state = Get.find<CompareToSettingLogic>().state;

  @override
  void dispose() {
    Get.delete<CompareToSettingLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    logic.buildPageData(widget.compareToDateRangeTypes, widget.currentDateTimeRange);
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_compare_to, maxHeight: 0.63, children: [
      Expanded(child: _buildComparisonOptions()),
      _createFooterWidget(),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _buildComparisonOptions() {
    var titles = [
      S.current.rs_date_tool_yesterday,
      S.current.rs_date_tool_last_week,
      S.current.rs_date_tool_last_month,
      S.current.rs_date_tool_last_year,
    ];

    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return RSFormCommonTypeWidget.buildMultipleCheckAndSubtitle(
            titles[index],
            RSLocale().locale?.languageCode != 'zh'
                ? [
                    "DoD",
                    "WoW",
                    "MoM",
                    "YoY",
                  ][index]
                : null,
            state.selectedIndexList.contains(index),
            (check) {
              setState(() {
                if (state.selectedIndexList.contains(index)) {
                  state.selectedIndexList.remove(index);
                } else {
                  state.selectedIndexList.add(index);
                }
              });
            },
            ifMultipleSelect: true,
            ifEdit: state.intersectingElements.contains(index),
          );
        });
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
          onTap: () async {
            logic.clickConfirmAction();

            if (state.selectedIndexList.isNotEmpty) {
              widget.compareToSettingCallBack.call(state.compareToDateRangeTypes);
            } else {
              widget.compareToSettingCallBack.call(null);
            }
            Get.back();
          },
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
}
