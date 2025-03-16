import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_sheet/analytics_add_dims_bottom_sheet/analytics_add_dims_bottom_sheet_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../config/rs_color.dart';
import '../../../../../../../generated/l10n.dart';
import '../../../../../../../widget/rs_app_bar.dart';
import '../../../../../../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'analytics_add_chart_sub_views_metric_logic.dart';

enum SubViewsMetricPageType {
  single,
  multiple,
}

enum PageDimOrMetricType {
  dim,
  metric,
}

class AnalyticsAddChartSubViewsMetricPage extends StatefulWidget {
  const AnalyticsAddChartSubViewsMetricPage({super.key});

  @override
  State<AnalyticsAddChartSubViewsMetricPage> createState() => _AnalyticsAddChartSubViewsMetricPageState();
}

class _AnalyticsAddChartSubViewsMetricPageState extends State<AnalyticsAddChartSubViewsMetricPage> {
  final logic = Get.put(AnalyticsAddChartSubViewsMetricLogic());
  final state = Get.find<AnalyticsAddChartSubViewsMetricLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddChartSubViewsMetricLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: state.dimOrMetricType.value == PageDimOrMetricType.dim
              ? state.pageType.value == SubViewsMetricPageType.single
                  ? S.current.rs_dim
                  : S.current.rs_dims_options
              : state.pageType.value == SubViewsMetricPageType.single
                  ? S.current.rs_metric
                  : S.current.rs_metrics_options,
          appBarColor: RSColor.color_0xFFFFFFFF,
        ),
        body: _createBody(),
      );
    });
  }

  Widget _createBody() {
    return Column(children: [
      Expanded(child: _createListView()),
      _createFooterWidget(),
    ]);
  }

  Widget _createListView() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: state.dimOrMetricType.value == PageDimOrMetricType.dim
            ? state.analysisChartEntity?.dims?.length ?? 0
            : state.analysisChartEntity?.metrics?.length ?? 0,
        itemBuilder: (context, index) {
          return Obx(() {
            return _createItemWidget(index);
          });
        });
  }

  Widget _createItemWidget(int index) {
    bool ifSelected = state.selectedMetricsIndex.contains(index);

    String subTitle = '';
    String title = '*';

    if (state.dimOrMetricType.value == PageDimOrMetricType.dim) {
      var metricOptions = state.analysisChartEntity?.dims?[index].metricOptions;

      if (metricOptions != null && metricOptions.isNotEmpty) {
        subTitle = metricOptions.length > 1
            ? '${metricOptions.length}'
            : logic.getMetricNameBasedOnMetricCode(metricOptions.first);
      }

      title = state.analysisChartEntity?.dims?[index].dimName ?? '*';
    } else {
      var dimOptions = state.analysisChartEntity?.metrics?[index].dimOptions;

      if (dimOptions != null && dimOptions.isNotEmpty) {
        subTitle = dimOptions.length > 1 ? '${dimOptions.length}' : logic.getDimNameBasedOnDimCode(dimOptions.first);
      }
      title = state.analysisChartEntity?.metrics?[index].metricName ?? '*';
    }

    return RSFormCommonTypeWidget.buildSecondaryOperationFormWidget(
      title,
      ifSelected || state.defaultIndexList.contains(index),
      subTitle,
      ifDefault: state.defaultIndexList.contains(index),
      (check) {
        if (state.selectedMetricsIndex.contains(index)) {
          if (state.pageType.value == SubViewsMetricPageType.multiple) {
            state.selectedMetricsIndex.remove(index);
            if (state.dimOrMetricType.value == PageDimOrMetricType.dim) {
              state.analysisChartEntity?.dims?[index].metricOptions?.clear();
            } else {
              state.analysisChartEntity?.metrics?[index].dimOptions?.clear();
            }
          }
        } else {
          if (state.pageType.value == SubViewsMetricPageType.single) {
            state.selectedMetricsIndex.clear();
            if (state.dimOrMetricType.value == PageDimOrMetricType.dim) {
              state.analysisChartEntity?.dims?.forEach((dim) {
                int index = state.analysisChartEntity?.dims?.indexOf(dim) ?? -1;
                if (index != -1) {
                  if (!state.defaultIndexList.contains(index)) {
                    dim.metricOptions?.clear();
                  }
                }
              });
            } else {
              state.analysisChartEntity?.metrics?.forEach((metric) {
                int index = state.analysisChartEntity?.metrics?.indexOf(metric) ?? -1;
                if (index != -1) {
                  if (!state.defaultIndexList.contains(index)) {
                    metric.dimOptions?.clear();
                  }
                }
              });
            }
          }

          state.selectedMetricsIndex.add(index);
        }
      },
      () {
        Get.bottomSheet(
          AnalyticsAddDimsOrMetricsBottomSheetPage(
            pageType: SubViewsMetricPageType.multiple,
            dimOrMetricType: state.dimOrMetricType.value,
            selectedIndex: index,
            analysisChartEntity: state.analysisChartEntity,
            selectedCallback: () {
              setState(() {});
            },
          ),
          isScrollControlled: true,
          isDismissible: false,
        );
      },
      ifMultipleStyle: state.pageType.value == SubViewsMetricPageType.multiple,
    );
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
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          alignment: Alignment.center,
          // child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {}),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (state.pageType.value == SubViewsMetricPageType.multiple)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${state.selectedMetricsIndex.length - 1}', // 去除base metric选项数量
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
              if (state.pageType.value == SubViewsMetricPageType.multiple) SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (logic.checkOption()) {
                      if (state.dimOrMetricType.value == PageDimOrMetricType.metric) {
                        state.originalAnalysisChartEntity?.metrics = state.analysisChartEntity?.metrics;
                      } else {
                        state.originalAnalysisChartEntity?.dims = state.analysisChartEntity?.dims;
                      }

                      Get.back();
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
