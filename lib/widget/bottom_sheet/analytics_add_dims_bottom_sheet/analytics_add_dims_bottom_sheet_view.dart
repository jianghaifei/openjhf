import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_sub_views_metric/analytics_add_chart_sub_views_metric_view.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import 'analytics_add_dims_bottom_sheet_logic.dart';

class AnalyticsAddDimsOrMetricsBottomSheetPage extends StatefulWidget {
  const AnalyticsAddDimsOrMetricsBottomSheetPage(
      {super.key,
      required this.pageType,
      required this.dimOrMetricType,
      this.analysisChartEntity,
      required this.selectedIndex,
      required this.selectedCallback});

  final SubViewsMetricPageType pageType;
  final PageDimOrMetricType dimOrMetricType;

  final int selectedIndex;
  final MetricsEditInfoMetricsCard? analysisChartEntity;
  final VoidCallback selectedCallback;

  @override
  State<AnalyticsAddDimsOrMetricsBottomSheetPage> createState() => _AnalyticsAddDimsOrMetricsBottomSheetPageState();
}

class _AnalyticsAddDimsOrMetricsBottomSheetPageState extends State<AnalyticsAddDimsOrMetricsBottomSheetPage> {
  final logic = Get.put(AnalyticsAddDimsOrMetricsBottomSheetLogic());
  final state = Get.find<AnalyticsAddDimsOrMetricsBottomSheetLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddDimsOrMetricsBottomSheetLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    state.dimOrMetricType.value = widget.dimOrMetricType;

    if (state.dimOrMetricType.value == PageDimOrMetricType.metric) {
      logic.getDims(widget.selectedIndex, widget.analysisChartEntity);
    } else {
      logic.getMetrics(widget.selectedIndex, widget.analysisChartEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RSBottomSheetWidget(
          title: state.dimOrMetricType.value == PageDimOrMetricType.metric
              ? widget.pageType == SubViewsMetricPageType.single
                  ? S.current.rs_dim
                  : S.current.rs_dims_options
              : widget.pageType == SubViewsMetricPageType.single
                  ? S.current.rs_metric
                  : S.current.rs_metrics_options,
          children: [
            _createBodyWidget(),
            _createFooterWidget(),
          ]);
    });
  }

  Widget _createBodyWidget() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.dimOrMetricType.value == PageDimOrMetricType.metric
              ? state.bindingDimsList.length
              : state.bindingMetricsList.length,
          itemBuilder: (context, index) {
            return Obx(() {
              return _createItemWidget(index);
            });
          }),
    );
  }

  Widget _createItemWidget(int index) {
    if (state.dimOrMetricType.value == PageDimOrMetricType.dim) {
      List<MetricsEditInfoMetrics> metrics = state.bindingMetricsList;

      bool ifSelected = state.selectedIndex.contains(index);
      return RSFormCommonTypeWidget.buildMultipleChoiceAndSetDefault(
          metrics[index].metricName ?? '*', ifSelected, ifSelected, (check) {
        if (state.selectedIndex.contains(index)) {
          if (widget.pageType == SubViewsMetricPageType.multiple) {
            state.selectedIndex.remove(index);
          }
        } else {
          if (widget.pageType == SubViewsMetricPageType.single) {
            state.selectedIndex.clear();
          }
          state.selectedIndex.add(index);
          if (state.setDefaultIndex.value == -1) {
            state.setDefaultIndex.value = index;
          }
        }
      }, () {
        state.setDefaultIndex.value = index;
      }, ifSetDefault: state.setDefaultIndex.value == index);
    } else {
      List<MetricsEditInfoDims> dims = state.bindingDimsList;

      bool ifSelected = state.selectedIndex.contains(index);
      return RSFormCommonTypeWidget.buildMultipleChoiceAndSetDefault(dims[index].dimName ?? '*', ifSelected, ifSelected,
          (check) {
        if (state.selectedIndex.contains(index)) {
          if (widget.pageType == SubViewsMetricPageType.multiple) {
            state.selectedIndex.remove(index);
          }
        } else {
          if (widget.pageType == SubViewsMetricPageType.single) {
            state.selectedIndex.clear();
          }
          state.selectedIndex.add(index);
          if (state.setDefaultIndex.value == -1) {
            state.setDefaultIndex.value = index;
          }
        }
      }, () {
        state.setDefaultIndex.value = index;
      }, ifSetDefault: state.setDefaultIndex.value == index);
    }
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.pageType == SubViewsMetricPageType.multiple)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${state.selectedIndex.length}",
                        style: TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: S.current.rs_location_selected,
                        style: TextStyle(
                          color: RSColor.color_0x40000000,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.pageType == SubViewsMetricPageType.multiple) SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (state.selectedIndex.isNotEmpty) {
                      logic.bindingData(widget.selectedIndex, widget.analysisChartEntity);
                      widget.selectedCallback();
                      Get.back();
                    } else {
                      EasyLoading.showToast(state.dimOrMetricType.value == PageDimOrMetricType.dim
                          ? S.current.rs_add_metric_tip
                          : S.current.rs_add_dim_least_one_tip);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFF5C57E6,
                      // .withOpacity((state.selectedShopsNew.isEmpty && !state.isAllSelected.value) ? 0.6 : 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      S.current.rs_confirm,
                      textAlign: TextAlign.center,
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
          ),
        ),
      ],
    );
  }
}
