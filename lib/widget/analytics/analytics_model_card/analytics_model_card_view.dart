import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/utils/color_util.dart';
import 'package:flutter_report_project/widget/analytics/analytics_model_card/analytics_model_card_state.dart';
import 'package:flutter_report_project/widget/bottom_sheet/reorderable_list_view/analytics_model_config_bottom_sheet/analytics_model_config_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/metric_card_general_widget.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../utils/analytics_tools.dart';
import '../../card_load_state_layout.dart';
import '../../chart_tooltips/chart_tooltips.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import 'analytics_model_card_logic.dart';

class AnalyticsModelCardPage extends StatefulWidget {
  const AnalyticsModelCardPage({
    super.key,
    required this.pageEditing,
    required this.cardIndex,
    this.cardTemplateData,
    this.deleteWidgetCallback,
    this.shopIds,
    this.displayTime,
    this.compareDateRangeTypes,
    this.compareDateTimeRanges,
    this.customDateToolEnum = CustomDateToolEnum.DAY,
    // zlj 添加
    this.alwaysLoadData = true, 
    this.padding,
    this.margin,
    this.borderRadius,
    this.from
  });

  final bool pageEditing;
  final int cardIndex;
  final TopicTemplateTemplatesNavsTabsCards? cardTemplateData;
  final Function(int cardIndex)? deleteWidgetCallback;

  // 外部传入自定义的时间——影响范围：当前页面
  final List<String>? shopIds;
  final List<DateTime>? displayTime;
  final List<CompareDateRangeType>? compareDateRangeTypes;
  final List<List<DateTime>>? compareDateTimeRanges;
  final CustomDateToolEnum customDateToolEnum;
  final bool alwaysLoadData;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final String? from;

  @override
  State<AnalyticsModelCardPage> createState() => _AnalyticsModelCardPageState();
}

class _AnalyticsModelCardPageState extends State<AnalyticsModelCardPage> with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsModelCardLogic logic;
  late AnalyticsModelCardState state;
  // zlj 添加
   bool _hasLoadedData = false; 

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsModelCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsModelCardLogic(), tag: tag);

    logic = Get.find<AnalyticsModelCardLogic>(tag: tag);
    state = Get.find<AnalyticsModelCardLogic>(tag: tag).state;
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.shopIds = widget.shopIds;
      state.displayTime = widget.displayTime;
      state.compareDateRangeTypes = widget.compareDateRangeTypes;
      state.compareDateTimeRanges = widget.compareDateTimeRanges;
      state.customDateToolEnum = widget.customDateToolEnum;

      // 选择器
      state.chartTypeStatus.value = 0;

      if (widget.cardTemplateData?.cardMetadata != null) {
        state.cardIndex = widget.cardIndex;
      }
      if (widget.pageEditing) {
        state.pageEditing = widget.pageEditing;
        logic.getTestData(widget.cardTemplateData);
      } else {
        logic.loadData(widget.cardTemplateData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 刷新时机
    if (widget.alwaysLoadData || !_hasLoadedData) {
      initData();
      _hasLoadedData = true;
    }

    return Obx(() {
      return MetricCardGeneralWidget(
        enableEditing: widget.pageEditing,
        deleteWidgetCallback: () {
          widget.deleteWidgetCallback?.call(widget.cardIndex);
        },
        padding: widget.padding ?? EdgeInsets.only(top: 16, bottom: state.chartTypeStatus.value == 0 ? 8 : 0),
        margin: widget.margin,
        borderRadius: widget.borderRadius,
        child: Column(
          children: [
            _createHeadWidget(),
            _createBody(),
          ],
        ),
      );
    });
  }

  Widget _createBody() {
    return CardLoadStateLayout(
      state: state.loadState.value,
      successWidget: Column(
        children: [
          if (state.allChartData.isEmpty) Container(),
          _buildBodySubWidget(),
        ],
      ),
      reloadCallback: () {
        logic.loadData(widget.cardTemplateData);
      },
      errorCode: state.errorCode,
      errorMessage: state.errorMessage,
    );
  }

  Widget _buildBodySubWidget() {
    Widget tmpWidget;
    if (state.chartTypeStatus.value == 0) {
      tmpWidget = _createChartWidget(265);
    } else {
      tmpWidget = _createListWidget();
    }

    return tmpWidget;
  }

  Widget _createHeadWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.cardTemplateData?.cardName ?? '*',
                    style: const TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (state.cardTemplateData.value.cardMetadata?.groupCode != null)
                  InkWell(
                    onTap: () {
                      logic.jumpStoresPKPage();
                    },
                    child: Text.rich(TextSpan(children: [
                      const WidgetSpan(
                          child: SizedBox(
                        width: 8,
                      )),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            S.current.rs_analysis,
                            style: const TextStyle(
                              color: RSColor.color_0xFF5C57E6,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: RSColor.color_0xFF5C57E6,
                            size: 18,
                          )),
                    ])),
                  ),
                if (widget.pageEditing)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        if (state.cardTemplateData.value.cardMetadata != null) {
                          Get.bottomSheet(
                            AnalyticsModelConfigBottomSheetPage(
                                metadataInfo: TopicTemplateTemplatesNavsTabsCardsCardMetadata.fromJson(
                                    state.cardTemplateData.value.cardMetadata!.toJson()),
                                applyCallback: (metadataInfo) {
                                  state.cardTemplateData.value.cardMetadata = metadataInfo;
                                  logic.editMetricsSequence();
                                }),
                            isScrollControlled: true,
                          );
                        }
                      },
                      child: Image.asset(
                        Assets.imageLaunchSetting,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (!widget.pageEditing) {
                logic.chartTypeStatusChanged(0);
              }
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: state.chartTypeStatus.value == 0 ? RSColor.color_0xFFF3F3F3 : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
              child: Image.asset(
                AnalyticsTools().getAnalyticsChartImageName(
                    state.cardTemplateData.value.cardMetadata?.chartType?.first.code, Assets.imageAnalyticsChartBar),
                width: 16,
                height: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                if (!widget.pageEditing) {
                  logic.chartTypeStatusChanged(1);
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: ShapeDecoration(
                  color: state.chartTypeStatus.value == 1 ? RSColor.color_0xFFF3F3F3 : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                ),
                child: Image.asset(
                  AnalyticsTools().getAnalyticsChartImageName(
                      state.cardTemplateData.value.cardMetadata?.chartType?.last.code, Assets.imageAnalyticsChartList),
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createListWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: _createTitleWidget(),
        ),
        Column(
          children: _createItemsWidget(),
        )
      ],
    );
  }

  Widget _createTitleWidget() {
    List<Widget> widgets = [];

    int loopIndex = 1;
    state.resultMetricsCardEntity.value.table?.header?.forEach((headerElement) {
      widgets.add(Expanded(child: _createTitleTextWidget(headerElement.name ?? '-')));
      if (loopIndex < state.resultMetricsCardEntity.value.table!.header!.length) {
        widgets.add(SizedBox(width: 4));
      }
      loopIndex++;
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: BoxConstraints(minHeight: 48),
      color: RSColor.color_0xFFF9F9F9,
      child: Row(
        children: widgets,
      ),
    );
  }

  List<Widget> _createItemsWidget() {
    List<Widget> widgets = [];

    int rowsLoopIndex = 0;

    state.resultMetricsCardEntity.value.table?.rows?.forEach((rowsElement) {
      List<Widget> rowWidgets = [];
      int headerLoopIndex = 1;

      state.resultMetricsCardEntity.value.table?.header?.forEach((headerElement) {
        if (rowsElement.containsKey(headerElement.code) && rowsElement[headerElement.code] != null) {
          ModuleMetricsCardTableRowsSubElement rowsSubElement =
              ModuleMetricsCardTableRowsSubElement.fromJson(rowsElement[headerElement.code]);

          rowWidgets.add(Expanded(
              child: InkWell(
                  onTap: () => logic.jumpEntityListPage(rowsSubElement.drillDownInfo, rowsSubElement.code),
                  child: _createItemTextWidget(rowsSubElement.displayValue, rowsSubElement.displayValueColor,
                      compValueEntity: rowsSubElement.compValue))));
          if (headerLoopIndex < state.resultMetricsCardEntity.value.table!.header!.length) {
            rowWidgets.add(SizedBox(width: 4));
          }

          headerLoopIndex++;
        }
      });

      if (rowWidgets.isNotEmpty) {
        widgets.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: BoxConstraints(minHeight: 48),
          color: rowsLoopIndex % 2 == 1 ? RSColor.color_0xFFF9F9F9 : RSColor.color_0xFFFFFFFF,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowWidgets,
          ),
        ));
      }
      rowsLoopIndex++;
    });

    return widgets;
  }

  Widget _createChartWidget(double height) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 8, right: 8),
      height: height,
      child: SfCartesianChart(
        enableAxisAnimation: true,
        legend: Legend(
          isVisible: logic.getIsShowCompareLine(),
          overflowMode: LegendItemOverflowMode.wrap,
          padding: 4,
          itemPadding: 8,
          // toggleSeriesVisibility: false,
          // legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
          //   return Row(
          //     children: [
          //       Container(
          //         width: 8,
          //         height: 10,
          //         decoration: ShapeDecoration(
          //           color: index == 0 ? RSColor.chartOriginalColor : RSColor.chartDayCompareColor,
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          //         ),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 4),
          //         child: Text(
          //           name,
          //           style: TextStyle(
          //             color: RSColor.color_0x60000000,
          //             fontSize: 12,
          //             fontWeight: FontWeight.w400,
          //             height: 0.14,
          //             letterSpacing: 0.10,
          //           ),
          //         ),
          //       ),
          //     ],
          //   );
          // },
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
              var info = trackballDetails.groupingModeInfo;

              var yMetric = logic.getYMetricValue(info?.currentPointIndices.first ?? 0);
              if (logic.getIsShowCompareLine()) {
                int index = info?.currentPointIndices.first ?? 0;
                var yCompareDayMetric = state.resultMetricsCardEntity.value.chart?[index].axisDayCompY?.first;
                var yCompareWeekMetric = state.resultMetricsCardEntity.value.chart?[index].axisWeekCompY?.first;
                var yCompareMonthMetric = state.resultMetricsCardEntity.value.chart?[index].axisMonthCompY?.first;
                var yCompareYearMetric = state.resultMetricsCardEntity.value.chart?[index].axisYearCompY?.first;

                return ChartTooltips().createChartGroupTooltipWidget(yMetric,
                    yCompareDayMetric: yCompareDayMetric,
                    yCompareWeekMetric: yCompareWeekMetric,
                    yCompareMonthMetric: yCompareMonthMetric,
                    yCompareYearMetric: yCompareYearMetric);
              } else {
                return ChartTooltips().createChartTooltipWidget(yMetric);
              }
            }),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 1, color: RSColor.color_0xFFF3F3F3),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelIntersectAction: AxisLabelIntersectAction.trim,
          // labelRotation: 20,
        ),
        primaryYAxis: const NumericAxis(
          autoScrollingMode: AutoScrollingMode.start,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          majorGridLines: MajorGridLines(width: 1, color: RSColor.color_0xFFF3F3F3),
        ),
        palette: RSColor.chartColors,
        plotAreaBorderColor: Colors.transparent,
        series: _buildStackedBarSeries(),
      ),
    );
  }

  List<CartesianSeries> _buildStackedBarSeries() {
    if (!logic.getIsShowCompareLine()) {
      return [
        ColumnSeries<RSChartData, String>(
          onRendererCreated: (ChartSeriesController controller) {
            state.chartSeriesController = controller;
          },
          dataSource: state.allChartData,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
          width: logic.getChartBarWidth(),
        ),
      ];
    } else {
      return [
        ColumnSeries<RSChartData, String>(
          name: S.current.rs_current,
          onRendererCreated: (ChartSeriesController controller) {
            state.chartSeriesController = controller;
          },
          dataSource: state.allChartData,
          legendIconType: LegendIconType.circle,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
          width: logic.getChartBarWidth(),
        ),
        if (state.allChartDayCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_yesterday,
            dataSource: state.allChartDayCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
            width: logic.getChartBarWidth(),
          ),
        if (state.allChartWeekCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_week,
            dataSource: state.allChartWeekCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
            width: logic.getChartBarWidth(),
          ),
        if (state.allChartMonthCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_month,
            dataSource: state.allChartMonthCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
            width: logic.getChartBarWidth(),
          ),
        if (state.allChartYearCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_year,
            dataSource: state.allChartYearCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
            width: logic.getChartBarWidth(),
          ),
      ];
    }
  }

  Widget _createTitleTextWidget(String title, {TextAlign? textAlign = TextAlign.left}) {
    return AutoSizeText(
      title,
      textAlign: textAlign,
      style: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _createItemTextWidget(String? title, String? titleColor,
      {ModuleMetricsCardCompValue? compValueEntity, TextAlign? textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '-',
          textAlign: textAlign,
          style: TextStyle(
            color: titleColor != null ? RSColorUtil.convertStringToColor(titleColor) : RSColor.color_0x90000000,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (compValueEntity != null)
          widget.pageEditing ? const Text('-') : AnalyticsTools.buildCompareWidget(compValueEntity, enableTitle: widget.from != 'ai_chat'),
      ],
    );
  }
}
