import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes.dart';
import '../../../widget/rs_app_bar.dart';
import 'analytics_add_logic.dart';

class AnalyticsAddPage extends StatefulWidget {
  const AnalyticsAddPage({super.key});

  @override
  State<AnalyticsAddPage> createState() => _AnalyticsAddPageState();
}

class _AnalyticsAddPageState extends State<AnalyticsAddPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(AnalyticsAddLogic());
  final state = Get.find<AnalyticsAddLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_add,
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: ListView.builder(
        itemCount: state.sections.length,
        itemBuilder: (context, sectionIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  state.sections[sectionIndex],
                  style: TextStyle(
                    color: RSColor.color_0x40000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Column(
                children: state.items[state.sections[sectionIndex]]!.map((item) {
                  return _createItemWidget(item);
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _createItemWidget(String title) {
    return Stack(
      children: [
        InkWell(
          onTap: () => _clickAction(title),
          child: Container(
            color: RSColor.color_0xFFFFFFFF,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 24,
                  color: RSColor.color_0x40000000,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 0,
            indent: 16,
          ),
        ),
      ],
    );
  }

  void _clickAction(String action) {
    if (action == S.current.rs_metric_card) {
      Get.toNamed(AppRoutes.analyticsAddMetricCardStep1Page, arguments: logic.getAnalyticsAddMetricsPageArguments());
    } else if (action == S.current.rs_analysis_chart) {
      Get.toNamed(AppRoutes.analyticsAddChartPage, arguments: logic.getAnalyticsChartPageArguments());
    } else if (action == S.current.rs_analysis_model) {
      Get.toNamed(AppRoutes.analyticsAddModelPage, arguments: logic.getAnalyticsAddAnalysisModelPageArguments());
    } else if (action == S.current.rs_template) {
      Get.toNamed(AppRoutes.analyticsAddTemplatePage, arguments: logic.getAnalyticsAddTemplatePageArguments());
    }
  }
}
