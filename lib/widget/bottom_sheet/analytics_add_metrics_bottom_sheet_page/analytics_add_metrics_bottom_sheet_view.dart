import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_button_widget/rs_bottom_button_widget.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_report_project/widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../analytics/analytics_add_metrics_widget/analytics_add_metrics_widget_view.dart';
import 'analytics_add_metrics_bottom_sheet_logic.dart';

enum AnalyticsAddMetricsOrDimsType {
  metrics,
  dims,
}

class AnalyticsAddMetricsBottomSheetPage extends StatefulWidget {
  const AnalyticsAddMetricsBottomSheetPage({
    super.key,
    required this.title,
    this.tabName,
    this.custom,
    this.lastSelectedMetrics,
    this.lastSelectedDims,
    required this.checkType,
    required this.selectIndexList,
    this.selectedSingleCallback,
    this.selectedMultipleIndexCallback,
    this.pageType = AnalyticsAddMetricsOrDimsType.metrics,
  });

  final String title;
  final String? tabName;
  final List<int> selectIndexList;
  final MetricsEditInfoMetricsCard? custom;
  final AnalyticsAddMetricsOrDimsType pageType;
  final List<MetricsEditInfoMetrics?>? lastSelectedMetrics;
  final List<MetricsEditInfoDims?>? lastSelectedDims;
  final AnalyticsAddMetricsCheckType checkType;
  final Function(int selectedMetricIndex)? selectedSingleCallback;
  final Function(List<int> selectedMetricsIndex)? selectedMultipleIndexCallback;

  @override
  State<AnalyticsAddMetricsBottomSheetPage> createState() => _AnalyticsAddMetricsBottomSheetPageState();
}

class _AnalyticsAddMetricsBottomSheetPageState extends State<AnalyticsAddMetricsBottomSheetPage> {
  final logic = Get.put(AnalyticsAddMetricsBottomSheetPageLogic());
  final state = Get.find<AnalyticsAddMetricsBottomSheetPageLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddMetricsBottomSheetPageLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectIndexList.isNotEmpty) {
      state.selectIndex.value = widget.selectIndexList;
    }

    state.tabs = [widget.tabName ?? ''];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<String>? tmpList;
      if (widget.pageType == AnalyticsAddMetricsOrDimsType.metrics) {
        tmpList = widget.custom?.metrics?.map((e) => e.metricName ?? '').toList();
      } else {
        tmpList = widget.custom?.dims?.map((e) => e.dimName ?? '').toList();
      }

      return RSBottomSheetWidget(
        title: widget.title,
        children: [
          RSTabControllerWidgetPage(tabs: state.tabs, tabBarViews: [
            AnalyticsAddMetricsWidgetPage(
              list: tmpList,
              selectedIndexList: state.selectIndex,
              checkType: widget.checkType,
              ifDefaultIndex: logic.findIfDefaultIndex(
                  widget.custom, widget.pageType, widget.lastSelectedMetrics, widget.lastSelectedDims),
            ),
          ]),
          RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_sure, (title) {
            if (widget.checkType == AnalyticsAddMetricsCheckType.single) {
              widget.selectedSingleCallback?.call(state.selectIndex.first);
            } else {
              widget.selectedMultipleIndexCallback?.call(state.selectIndex.map((e) => e).toList());
            }
            Get.back();
          },
              editable: widget.checkType == AnalyticsAddMetricsCheckType.single
                  ? state.selectIndex.isNotEmpty
                  : (state.selectIndex.isNotEmpty || state.selectIndex.isEmpty)),
        ],
      );
    });
  }
}
