import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'package:get/get.dart';

import 'analytics_add_metrics_widget_logic.dart';

enum AnalyticsAddMetricsCheckType {
  single,
  multiple,
}

class AnalyticsAddMetricsWidgetPage extends StatefulWidget {
  const AnalyticsAddMetricsWidgetPage({
    super.key,
    required this.list,
    required this.selectedIndexList,
    this.ifDefaultIndex,
    this.checkType = AnalyticsAddMetricsCheckType.multiple,
  });

  final List<String>? list;
  final List<int> selectedIndexList;
  final List<int>? ifDefaultIndex;
  final AnalyticsAddMetricsCheckType checkType;

  @override
  State<AnalyticsAddMetricsWidgetPage> createState() => _AnalyticsAddMetricsWidgetPageState();
}

class _AnalyticsAddMetricsWidgetPageState extends State<AnalyticsAddMetricsWidgetPage> {
  final logic = Get.put(AnalyticsAddMetricsWidgetLogic());
  final state = Get.find<AnalyticsAddMetricsWidgetLogic>().state;

  @override
  Widget build(BuildContext context) {
    return _createTabBarView(widget.list);
  }

  @override
  void dispose() {
    Get.delete<AnalyticsAddMetricsWidgetLogic>();
    super.dispose();
  }

  Widget _createTabBarView(List<String>? list) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return RSFormCommonTypeWidget.buildRadioFormWidget(list?[index] ?? '', widget.selectedIndexList.contains(index),
            (check) {
          if (widget.checkType == AnalyticsAddMetricsCheckType.single) {
            widget.selectedIndexList.clear();
            widget.selectedIndexList.add(index);
          } else {
            if (widget.selectedIndexList.contains(index)) {
              widget.selectedIndexList.remove(index);
            } else {
              widget.selectedIndexList.add(index);
            }
          }

          setState(() {});
        },
            ifDefault: logic.setIfDefault(index, widget.ifDefaultIndex),
            ifMultipleSelect: widget.checkType == AnalyticsAddMetricsCheckType.multiple);
      },
    );
  }
}
