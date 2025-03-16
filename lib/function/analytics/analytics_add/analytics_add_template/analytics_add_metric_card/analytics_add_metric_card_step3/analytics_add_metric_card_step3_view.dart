import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../config/rs_color.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../../widget/rs_app_bar.dart';
import '../../../../../../widget/steps_widget/rs_steps_widget.dart';
import 'analytics_add_metric_card_step3_logic.dart';

class AnalyticsAddMetricCardStep3Page extends StatefulWidget {
  const AnalyticsAddMetricCardStep3Page({super.key});

  @override
  State<AnalyticsAddMetricCardStep3Page> createState() => _AnalyticsAddMetricCardStep3PageState();
}

class _AnalyticsAddMetricCardStep3PageState extends State<AnalyticsAddMetricCardStep3Page> {
  final logic = Get.put(AnalyticsAddMetricCardStep3Logic());
  final state = Get.find<AnalyticsAddMetricCardStep3Logic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddMetricCardStep3Logic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    state.metricsCardEntity = Get.arguments["metricsCardEntity"];
    if (state.metricsCardEntity?.metrics == null || state.metricsCardEntity!.metrics!.isEmpty) {
      Get.back();
    }
    state.layoutType = Get.arguments["layoutType"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: "${S.current.rs_add}-${S.current.rs_metric_card}",
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: RSColor.color_0xFFFFFFFF,
            child: RSStepsWidget().buildThreeStepOperationWidget(3),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: AutoSizeText(
              S.current.rs_long_press_and_drag_to_adjust_the_order,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: RSColor.color_0x40000000,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _createMiddleContent(),
          _createBottomWidget(),
        ],
      ),
    );
  }

  Widget _createMiddleContent() {
    double childAspectRatio = 1.6;

    switch (state.layoutType) {
      case 1:
        childAspectRatio = 4.8;
        break;
      case 2:
        childAspectRatio = 2.5;
        break;
      case 3:
        childAspectRatio = 1.6;
        break;
      default:
        childAspectRatio = 1.6;
        break;
    }

    return Expanded(
      child: AnimatedReorderableGridView(
        physics: const ClampingScrollPhysics(),
        items: state.metricsCardEntity!.metrics!.map((e) => e.metricName ?? "").toList(),
        itemBuilder: (BuildContext context, int index) {
          return _createGridItemWidget(index, showChartImage: state.layoutType == 1);
        },
        sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: state.layoutType,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: childAspectRatio,
        ),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            state.metricsCardEntity!.metrics!.insert(newIndex, state.metricsCardEntity!.metrics!.removeAt(oldIndex));
          });
        },
        isSameItem: (String a, String b) {
          return a == b;
        },
      ),
    );
  }

  Widget _createBottomWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          alignment: Alignment.center,
          child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
            logic.backEditingPage();
          }, height: 40),
        ),
      ],
    );
  }

  Widget _createGridItemWidget(int index, {bool showChartImage = false}) {
    var metricsName = state.metricsCardEntity!.metrics![index].metricName ?? "*";
    return Container(
      key: Key("$metricsName $index"),
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: RSColor.color_0xFFFFFFFF,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metricsName,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '——',
                  style: TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          if (showChartImage) const Spacer(),
          if (showChartImage)
            const Image(
              image: AssetImage(Assets.imageAddMetricsCardChart),
            ),
        ],
      ),
    );
  }
}
