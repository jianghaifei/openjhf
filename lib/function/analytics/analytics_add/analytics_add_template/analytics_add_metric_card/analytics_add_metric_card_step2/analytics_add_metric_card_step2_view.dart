import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/router/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../config/rs_color.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../widget/analytics/analytics_add_metrics_widget/analytics_add_metrics_widget_view.dart';
import '../../../../../../widget/rs_app_bar.dart';
import '../../../../../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import '../../../../../../widget/steps_widget/rs_steps_widget.dart';
import 'analytics_add_metric_card_step2_logic.dart';

class AnalyticsAddMetricCardStep2Page extends StatefulWidget {
  const AnalyticsAddMetricCardStep2Page({super.key});

  @override
  State<AnalyticsAddMetricCardStep2Page> createState() => _AnalyticsAddMetricCardStep2PageState();
}

class _AnalyticsAddMetricCardStep2PageState extends State<AnalyticsAddMetricCardStep2Page> {
  final logic = Get.put(AnalyticsAddMetricCardStep2Logic());
  final state = Get.find<AnalyticsAddMetricCardStep2Logic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddMetricCardStep2Logic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    state.tabName = Get.arguments["tabName"];
    state.metricsCardEntity = Get.arguments["metricsCardEntity"];
    state.layoutType = Get.arguments["layoutType"];

    state.tabs = [state.tabName ?? ''];
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
            child: RSStepsWidget().buildThreeStepOperationWidget(2),
          ),
          SizedBox(height: 8),
          RSTabControllerWidgetPage(tabs: state.tabs, tabBarViews: [
            AnalyticsAddMetricsWidgetPage(
              list: state.metricsCardEntity?.metrics?.map((e) => e.metricName ?? '').toList(),
              selectedIndexList: state.selectIndexList,
              checkType: AnalyticsAddMetricsCheckType.multiple,
              ifDefaultIndex: logic.findIfDefaultIndex(),
            ),
          ]),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${state.selectIndexList.length} ${S.current.rs_select}',
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (state.selectIndexList.isNotEmpty && state.selectIndexList.length % state.layoutType == 0) {
                        Get.toNamed(AppRoutes.analyticsAddMetricCardStep3Page,
                            arguments: logic.getAnalyticsAddMetricCardStep3Arguments());
                      } else {
                        if (state.layoutType == 1) {
                          EasyLoading.showToast(S.current.rs_please_select_at_least_one_metric);
                        } else {
                          EasyLoading.showToast(
                              "${S.current.rs_please_select} ${state.layoutType}*n ${S.current.rs_select_metric_tip_suffix}");
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: RSColor.color_0xFF5C57E6.withOpacity(
                            (state.selectIndexList.isNotEmpty && state.selectIndexList.length % state.layoutType == 0)
                                ? 1
                                : 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: Text(
                        S.current.rs_next_step,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
