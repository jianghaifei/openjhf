import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../config/rs_color.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../router/app_routes.dart';
import '../../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../../widget/rs_app_bar.dart';
import '../../../../../../widget/steps_widget/rs_steps_widget.dart';
import 'analytics_add_metric_card_step1_logic.dart';

class AnalyticsAddMetricCardStep1Page extends StatefulWidget {
  const AnalyticsAddMetricCardStep1Page({super.key});

  @override
  State<AnalyticsAddMetricCardStep1Page> createState() => _AnalyticsAddMetricCardStep1PageState();
}

class _AnalyticsAddMetricCardStep1PageState extends State<AnalyticsAddMetricCardStep1Page> {
  final logic = Get.put(AnalyticsAddMetricCardStep1Logic());
  final state = Get.find<AnalyticsAddMetricCardStep1Logic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddMetricCardStep1Logic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    state.tabName = Get.arguments["tabName"];
    state.metricsCardEntity = Get.arguments["metricsCardEntity"];
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
            child: RSStepsWidget().buildThreeStepOperationWidget(1),
          ),
          _createMiddleContent(),
          _createBottomWidget(),
        ],
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
        Obx(() {
          return Container(
            color: RSColor.color_0xFFFFFFFF,
            padding: EdgeInsets.only(
                top: 16,
                bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
                left: 16,
                right: 16),
            alignment: Alignment.center,
            child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_next_step, (title) {
              Get.toNamed(AppRoutes.analyticsAddMetricCardStep2Page,
                  arguments: logic.getAnalyticsAddMetricCardStep2Arguments());
            }, height: 40, editable: state.selectedIndex.value != -1),
          );
        }),
      ],
    );
  }

  Widget _createMiddleContent() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Obx(() {
            return _createItemWidget(index);
          });
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 0.5,
            height: 0,
            indent: 16,
          );
        },
      ),
    );
  }

  Widget _createItemWidget(int index) {
    String assetName = Assets.imageAddMetricsCardOne;
    switch (index) {
      case 0:
        assetName = Assets.imageAddMetricsCardOne;
        break;
      case 1:
        assetName = Assets.imageAddMetricsCardTwo;
        break;
      case 2:
        assetName = Assets.imageAddMetricsCardThree;
        break;
      default:
        assetName = Assets.imageAddMetricsCardOne;
        break;
    }

    return InkWell(
      onTap: () {
        state.selectedIndex.value = index;
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Image(
              image:
                  AssetImage(state.selectedIndex.value == index ? Assets.imageCheckCircleSel : Assets.imageCheckCircle),
              gaplessPlayback: true,
              color: state.selectedIndex.value == index ? RSColor.color_0xFF5C57E6 : RSColor.color_0x26000000,
            ),
            const Spacer(),
            Image(
              image: AssetImage(assetName),
            )
          ],
        ),
      ),
    );
  }
}
