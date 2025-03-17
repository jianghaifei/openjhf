import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_button_widget/rs_bottom_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/analytics/analytics_add_metrics_widget/analytics_add_metrics_widget_view.dart';
import '../../../../widget/popup_widget/rs_alert/rs_alert_view.dart';
import '../../../../widget/rs_app_bar.dart';
import '../../../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'analytics_add_template_logic.dart';

class AnalyticsAddTemplatePage extends StatefulWidget {
  const AnalyticsAddTemplatePage({super.key});

  @override
  State<AnalyticsAddTemplatePage> createState() => _AnalyticsAddTemplatePageState();
}

class _AnalyticsAddTemplatePageState extends State<AnalyticsAddTemplatePage> {
  final logic = Get.put(AnalyticsAddTemplateLogic());
  final state = Get.find<AnalyticsAddTemplateLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddTemplateLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    state.navId = Get.arguments["navId"];
    state.tabName = Get.arguments["tabName"];
    state.tabId = Get.arguments["sourceTabId"];
    state.tabTemplate = Get.arguments["templateList"];

    state.tabs = [state.tabName ?? ''];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: "${S.current.rs_add}-${S.current.rs_template}",
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: Column(
        children: [
          RSTabControllerWidgetPage(tabs: state.tabs, tabBarViews: [
            AnalyticsAddMetricsWidgetPage(
              list: state.tabTemplate?.map((e) => e.templateName ?? '').toList(),
              selectedIndexList: state.selectIndexList,
              checkType: AnalyticsAddMetricsCheckType.single,
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
                  Get.dialog(RSAlertPopup(
                    title: S.current.rs_edit_page_reset_template_tip,
                    alertPopupType: RSAlertPopupType.normal,
                    doneCallback: () {
                      logic.updateTabTemplate();
                    },
                  ));
                }, editable: state.selectIndexList.isNotEmpty),
              ],
            );
          }),
        ),
      ],
    );
  }
}
