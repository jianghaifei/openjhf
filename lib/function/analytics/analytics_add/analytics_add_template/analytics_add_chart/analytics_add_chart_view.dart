import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../widget/rs_app_bar.dart';
import 'analytics_add_chart_logic.dart';
import 'analytics_add_chart_subviews/analytics_add_chart_subviews_view.dart';

class AnalyticsAddChartPage extends StatefulWidget {
  const AnalyticsAddChartPage({super.key});

  @override
  State<AnalyticsAddChartPage> createState() => _AnalyticsAddChartPageState();
}

class _AnalyticsAddChartPageState extends State<AnalyticsAddChartPage> {
  final logic = Get.put(AnalyticsAddChartLogic());
  final state = Get.find<AnalyticsAddChartLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddChartLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      state.tabName = args["tabName"];
      state.analysisChartEntity = args["analysisChartEntity"];

      if (args.containsKey("cardTemplateData")) {
        state.cardTemplateData = args["cardTemplateData"];
        if (args.containsKey("cardIndex") && args["cardIndex"] != -1) {
          state.cardIndex = args["cardIndex"];
        } else {
          EasyLoading.showError("cardIndex 出错！");
        }
      }
    }

    state.tabs = logic.getCustomTabTitles() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: "${S.current.rs_add}-${S.current.rs_analysis_chart}",
          appBarColor: RSColor.color_0xFFFFFFFF,
        ),
        body: _createTabControllerWidget(),
      ),
    );
  }

  Widget _createTabControllerWidget() {
    return Column(
      children: [
        RSTabControllerWidgetPage(
            tabs: state.tabs,
            isScrollable: state.cardTemplateData == null ? false : true,
            tabBarViews: List.generate(state.tabs.length, (index) {
              return AnalyticsAddChartSubviewsPage(
                cardIndex: state.cardIndex,
                chartEntity: state.analysisChartEntity?[index],
                tabName: state.tabName ?? '*',
                cardTemplateData: state.cardTemplateData,
              );
            })),
      ],
    );
  }
}
