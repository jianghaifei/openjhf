import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../widget/analytics/analytics_add_metrics_widget/analytics_add_metrics_widget_view.dart';
import '../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../widget/rs_app_bar.dart';
import '../../../../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'analytics_add_model_logic.dart';

class AnalyticsAddModelPage extends StatefulWidget {
  const AnalyticsAddModelPage({super.key});

  @override
  State<AnalyticsAddModelPage> createState() => _AnalyticsAddModelPageState();
}

class _AnalyticsAddModelPageState extends State<AnalyticsAddModelPage> {
  final logic = Get.put(AnalyticsAddModelLogic());
  final state = Get.find<AnalyticsAddModelLogic>().state;

  @override
  void initState() {
    super.initState();

    state.navId = Get.arguments["navId"];
    state.tabName = Get.arguments["tabName"];
    state.tabId = Get.arguments["sourceTabId"];
    state.tabsData = Get.arguments["tabsData"];
    state.customCardTemplate = Get.arguments["customCardTemplate"];

    state.tabs = [state.tabName ?? ''];
  }

  @override
  void dispose() {
    Get.delete<AnalyticsAddModelLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: "${S.current.rs_add}-${S.current.rs_analysis_model}",
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: Column(
        children: [
          RSTabControllerWidgetPage(tabs: state.tabs, tabBarViews: [
            AnalyticsAddMetricsWidgetPage(
              list: state.customCardTemplate?.map((e) => e.templateName ?? '').toList(),
              selectedIndexList: state.selectIndexList,
              ifDefaultIndex: logic.findAddedTemplate(),
              checkType: AnalyticsAddMetricsCheckType.multiple,
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
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          alignment: Alignment.center,
          child: Obx(() {
            return Row(
              children: [
                RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
                  if (state.selectIndexList.isNotEmpty) {
                    logic.backEditingPage();
                  }
                }, editable: state.selectIndexList.isNotEmpty),
              ],
            );
          }),
        ),
      ],
    );
  }
}
