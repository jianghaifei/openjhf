import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_chart/target_analysis_chart_state.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../config/rs_color.dart';
import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../model/chart_data/rs_chart_data.dart';
import '../../../../model/target_manage/target_manage_config_entity.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../chart_tooltips/chart_tooltips.dart';
import '../../../metric_card_general_widget.dart';
import '../../../popup_widget/rs_bubble_popup.dart';
import 'target_analysis_chart_logic.dart';

/// 目标达成趋势
class TargetAnalysisChartPage extends StatefulWidget {
  const TargetAnalysisChartPage({super.key, required this.selectedMetric, this.cumulativeTrend, this.dailyTrend});

  // 选中的指标
  final TargetManageConfigMetrics selectedMetric;

  // 达成趋势-累计
  final TargetManageOverviewCumulativeTrend? cumulativeTrend;

  // 达成趋势-分时
  final TargetManageOverviewDailyTrend? dailyTrend;

  @override
  State<TargetAnalysisChartPage> createState() => _TargetAnalysisChartPageState();
}

class _TargetAnalysisChartPageState extends State<TargetAnalysisChartPage> {
  final logic = Get.put(TargetAnalysisChartLogic());
  final state = Get.find<TargetAnalysisChartLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetAnalysisChartLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.setChartData(widget.cumulativeTrend, widget.dailyTrend);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MetricCardGeneralWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createHeadWidget(),
            _createChartWidget(),
          ],
        ),
      );
    });
  }

  Widget _createHeadWidget() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.cumulativeTrend?.title ?? '*',
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _createPopupWidget(),
      ],
    );
  }

  /// 弹出视图
  Widget _createPopupWidget() {
    return RSBubblePopup(
      barrierColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPopupItemWidget(TargetAnalysisChartType.cumulative),
          _createPopupItemWidget(TargetAnalysisChartType.daily),
        ],
      ),
      child: Row(
        children: [
          Text(
            state.chartType.value == TargetAnalysisChartType.cumulative
                ? S.current.rs_cumulative
                : S.current.rs_time_based,
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Image(
              image: AssetImage(Assets.imageArrowDropDown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPopupItemWidget(TargetAnalysisChartType chartType) {
    String title = chartType == TargetAnalysisChartType.cumulative ? S.current.rs_cumulative : S.current.rs_time_based;

    return InkWell(
      onTap: () {
        state.chartType.value = chartType;
        // 关闭弹窗
        Get.back();
        if (mounted) {
          logic.setChartData(widget.cumulativeTrend, widget.dailyTrend);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: state.chartType.value == chartType ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _createChartWidget() {
    var chartData = logic.returnChartData(widget.cumulativeTrend, widget.dailyTrend, state.chartType.value);

    var maxTargetValue = max(
        double.tryParse(chartData?.first.axisCompY?.first.metricValue ?? "0") ?? 0, logic.getMaxMetricValue(chartData));

    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 310,
      child: SfCartesianChart(
          margin: EdgeInsets.zero,
          enableAxisAnimation: true,
          legend: Legend(
            isVisible: state.chartType.value == TargetAnalysisChartType.daily ||
                (widget.cumulativeTrend?.chart != null &&
                    widget.cumulativeTrend!.chart!.isNotEmpty &&
                    widget.cumulativeTrend!.chart!.length == 1),
            overflowMode: LegendItemOverflowMode.wrap,
            padding: 4,
            itemPadding: 8,
            position: LegendPosition.bottom,
          ),
          trackballBehavior: TrackballBehavior(
              enable: true,
              hideDelay: 3000,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              markerSettings: const TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.visible,
              ),
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(enable: true, arrowLength: 0, arrowWidth: 0),
              lineColor: RSColor.color_0xFF5C57E6.withOpacity(0.6),
              builder: (BuildContext context, TrackballDetails trackballDetails) {
                if (mounted) {
                  var info = trackballDetails.groupingModeInfo;
                  int index = info?.currentPointIndices.first ?? 0;

                  var chart = logic.returnChartData(widget.cumulativeTrend, widget.dailyTrend, state.chartType.value);

                  var yMetric = chart?[index].axisY?.first;
                  if (yMetric == null) {
                    return Container();
                  }

                  if (state.allChartCompData.isNotEmpty) {
                    var yCompareDayMetric = chart?[index].axisCompY?.first;
                    return ChartTooltips().createChartGroupTooltipWidget(
                        ModuleMetricsCardChartAxisY.fromJson(yMetric.toJson()),
                        yCompareDayMetric: ModuleMetricsCardChartAxisY.fromJson(yCompareDayMetric!.toJson()),
                        yCompareWeekMetric: null,
                        yCompareMonthMetric: null,
                        yCompareYearMetric: null);
                  } else {
                    return ChartTooltips()
                        .createChartTooltipWidget(ModuleMetricsCardChartAxisY.fromJson(yMetric.toJson()));
                  }
                }
                return Container();
              }),
          primaryXAxis: const CategoryAxis(
            maximumLabels: 4,
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(width: 1, color: RSColor.color_0xFFF3F3F3),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            autoScrollingMode: AutoScrollingMode.start,
            axisLine: const AxisLine(width: 0),
            maximum: maxTargetValue,
            majorTickLines: const MajorTickLines(width: 0),
            majorGridLines: const MajorGridLines(width: 1, color: RSColor.color_0xFFF3F3F3),
            numberFormat: widget.selectedMetric.dataType == MetricOrDimDataType.CURRENCY
                ? NumberFormat.compactCurrency(
                    symbol: RSAccountManager().getCurrency()?.symbol,
                    decimalDigits: 1,
                  )
                : null,
            plotBands: state.chartType.value == TargetAnalysisChartType.cumulative &&
                    widget.cumulativeTrend?.chart != null &&
                    widget.cumulativeTrend!.chart!.isNotEmpty &&
                    widget.cumulativeTrend!.chart!.length > 1
                ? [
                    PlotBand(
                      text:
                          "${widget.cumulativeTrend?.chart?.first.axisCompY?.first.metricName}${widget.cumulativeTrend?.chart?.first.axisCompY?.first.metricDisplayValue}",
                      textAngle: 0,
                      start:
                          double.tryParse(widget.cumulativeTrend?.chart?.first.axisCompY?.first.metricValue ?? "0") ??
                              0,
                      end: double.tryParse(widget.cumulativeTrend?.chart?.first.axisCompY?.first.metricValue ?? "0") ??
                          0,
                      textStyle: const TextStyle(
                        color: RSColor.color_0x26000000,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      borderColor: RSColor.getChartColor(1),
                      borderWidth: 1,
                    ),
                  ]
                : [],
          ),
          plotAreaBorderColor: Colors.transparent,
          series: _buildChartTypeSeries(state.chartType.value == TargetAnalysisChartType.cumulative
              ? (widget.cumulativeTrend?.chart != null &&
                      widget.cumulativeTrend!.chart!.isNotEmpty &&
                      widget.cumulativeTrend!.chart!.length > 1
                  ? AddMetricsChartType.LINE
                  : AddMetricsChartType.BAR)
              : AddMetricsChartType.BAR)),
    );
  }

  List<CartesianSeries> _buildChartTypeSeries(AddMetricsChartType? chartType) {
    if (chartType == AddMetricsChartType.LINE) {
      return _buildStackedLineSeries();
    } else {
      return _buildStackedBarSeries();
    }
  }

  List<CartesianSeries> _buildStackedBarSeries() {
    return [
      if (state.allChartCompData.isNotEmpty)
        ColumnSeries<RSChartData, String>(
          name: state.allChartCompData.first.name,
          dataSource: state.allChartCompData,
          legendIconType: LegendIconType.circle,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
          color: RSColor.getChartColor(1),
          width: getBarWidth(),
          // onCreateRenderer: (series) {
          //   return CustomColumnSeriesRenderer(color: RSColor.getChartColor(1));
          // },
        ),
      ColumnSeries<RSChartData, String>(
        name: state.allChartData.first.name,
        onRendererCreated: (ChartSeriesController controller) {
          state.chartSeriesController = controller;
        },
        dataSource: state.allChartData,
        legendIconType: LegendIconType.circle,
        xValueMapper: (RSChartData data, _) => data.x,
        yValueMapper: (RSChartData data, _) => data.y,
        color: RSColor.getChartColor(0),
        width: getBarWidth(),

        // onCreateRenderer: (series) {
        //   return CustomColumnSeriesRenderer(color: RSColor.getChartColor(0));
        // },
      ),
    ];
  }

  List<CartesianSeries> _buildStackedLineSeries() {
    return [
      SplineAreaSeries<RSChartData, String>(
        name: state.allChartData.first.name,
        onRendererCreated: (ChartSeriesController controller) {
          state.chartSeriesController = controller;
        },
        dataSource: state.allChartData,
        xValueMapper: (RSChartData data, _) => data.x,
        yValueMapper: (RSChartData data, _) => data.y,
        borderColor: RSColor.getChartColor(0),
        gradient: state.gradientColors,
      ),
    ];
  }

  double getBarWidth() {
    if (state.allChartData.length < 5) {
      return 0.1;
    } else {
      return 0.7;
    }
  }
}

// class CustomColumnSeriesRenderer extends ColumnSeriesRenderer<RSChartData, String> {
//   CustomColumnSeriesRenderer({required this.color}) : super();
//
//   @override
//   final Color color;
//
//   @override
//   ColumnSegment<RSChartData, String> createSegment() {
//     return CustomColumnSegment(color: color);
//   }
// }
//
// class CustomColumnSegment extends ColumnSegment<RSChartData, String> {
//   CustomColumnSegment({required this.color}) : super();
//
//   final Color color;
//   final double width = 5; // Custom fixed width for columns
//   final double cornerRadius = 5; // Radius for top-left and top-right corners
//
//   @override
//   void onPaint(Canvas canvas) {
//     final double centerX = segmentRect!.center.dx;
//     final double left = centerX - (width / 2);
//     final double right = centerX + (width / 2);
//     final Paint paint = Paint();
//
//     paint
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     final RRect roundedRect = RRect.fromRectAndCorners(
//       Rect.fromLTRB(left, segmentRect!.top, right, segmentRect!.bottom),
//       topLeft: Radius.circular(cornerRadius),
//       topRight: Radius.circular(cornerRadius),
//     );
//
//     canvas.drawRRect(roundedRect, paint);
//   }
// }
