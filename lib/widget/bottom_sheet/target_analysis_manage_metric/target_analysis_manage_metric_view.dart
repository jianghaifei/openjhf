import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import 'target_analysis_manage_metric_logic.dart';

class TargetAnalysisManageMetricPage extends StatefulWidget {
  const TargetAnalysisManageMetricPage({super.key});

  @override
  State<TargetAnalysisManageMetricPage> createState() => _TargetAnalysisManageMetricPageState();
}

class _TargetAnalysisManageMetricPageState extends State<TargetAnalysisManageMetricPage> {
  final logic = Get.put(TargetAnalysisManageMetricLogic());
  final state = Get.find<TargetAnalysisManageMetricLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetAnalysisManageMetricLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_metric, maxHeight: 0.7, children: [
      _createBodyWidget(),
      _createFooterWidget(),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createBodyWidget() {
    return Expanded(
      child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return RSFormCommonTypeWidget.buildMultipleCheckAndSubtitle("$index", null, false, (check) {});
          }),
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
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: InkWell(
            onTap: () async {
              // logic.clickConfirmAction();
              //
              // if (state.selectedIndexList.isNotEmpty) {
              //   widget.compareToSettingCallBack.call(state.compareToDateRangeTypes);
              // } else {
              //   widget.compareToSettingCallBack.call(null);
              // }
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
        ),
      ],
    );
  }
}
