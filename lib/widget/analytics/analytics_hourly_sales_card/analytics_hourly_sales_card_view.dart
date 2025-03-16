import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/widget/analytics/analytics_hourly_sales_card/analytics_hourly_sales_card_state.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:flutter_report_project/widget/chart_tooltips/chart_tooltips.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../utils/color_util.dart';
import '../../../widget/metric_card_general_widget.dart';
import '../../bottom_sheet/hourly_and_group_bottom_sheet/period_and_group_bottom_sheet_view.dart';
import '../../bottom_sheet/picker_tool_bottom_sheet/picker_tool_bottom_sheet_view.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import 'analytics_hourly_sales_card_logic.dart';

class AnalyticsHourlySalesCardPage extends StatefulWidget {
  const AnalyticsHourlySalesCardPage({
    super.key,
    this.tabId,
    this.tabName,
    this.pageEditing = false,
    this.cardTemplateData,
    this.deleteWidgetCallback,
    required this.cardIndex,
    this.shopIds,
    this.displayTime,
    this.compareDateRangeTypes,
    this.compareDateTimeRanges,
    this.customDateToolEnum = CustomDateToolEnum.DAY,
  });

  final String? tabId;
  final String? tabName;
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

  @override
  State<AnalyticsHourlySalesCardPage> createState() => _AnalyticsHourlySalesCardPageState();
}

class _AnalyticsHourlySalesCardPageState extends State<AnalyticsHourlySalesCardPage>
    with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsHourlySalesCardLogic logic;
  late AnalyticsHourlySalesCardState state;

  final conditionWidgetWidth = (1.sw - 24 * 2 - 30) / 2;

  @override
  void dispose() {
    Get.delete<AnalyticsHourlySalesCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsHourlySalesCardLogic(), tag: tag);

    logic = Get.find<AnalyticsHourlySalesCardLogic>(tag: tag);
    state = Get.find<AnalyticsHourlySalesCardLogic>(tag: tag).state;
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.shopIds = widget.shopIds;
      state.displayTime = widget.displayTime;
      state.compareDateRangeTypes = widget.compareDateRangeTypes;
      state.compareDateTimeRanges = widget.compareDateTimeRanges;
      state.customDateToolEnum = widget.customDateToolEnum;

      // 指标下标
      state.selectedMetricsIndex.value = 0;
      // 维度下标
      state.selectedDimsIndex.value = 0;
      // 选择器
      state.chartTypeStatus.value = 0;

      if (widget.cardTemplateData?.cardMetadata != null) {
        state.cardIndex = widget.cardIndex;
      }
      logic.loadData(widget.cardTemplateData);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 刷新时机
    if (widget.pageEditing) {
      logic.getTestData(widget.tabId, widget.tabName, widget.cardTemplateData, widget.cardIndex);
    } else {
      initData();
    }

    return Obx(() {
      return MetricCardGeneralWidget(
        enableEditing: widget.pageEditing,
        deleteWidgetCallback: () {
          widget.deleteWidgetCallback?.call(widget.cardIndex);
        },
        padding: EdgeInsets.only(top: 16, bottom: widget.pageEditing ? 16 : 8),
        child: InkWell(
          onTap: () {
            if (widget.pageEditing) {
              logic.jumpEditPage();
            }
          },
          child: Column(
            children: [
              _createHeadWidget(),
              _createBody(),
            ],
          ),
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
      if (state.metadata.value.chartType?.first.code == AddMetricsChartType.LIST) {
        tmpWidget = _createListWidget();
      } else {
        tmpWidget = _createChartWidget(310, state.metadata.value.chartType?.first.code);
      }
    } else {
      if (state.metadata.value.chartType?.last.code == AddMetricsChartType.LIST) {
        tmpWidget = _createListWidget();
      } else {
        tmpWidget = _createChartWidget(310, state.metadata.value.chartType?.last.code);
      }
    }
    return tmpWidget;
  }

  Widget _createHeadWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: AutoSizeText(
                widget.cardTemplateData?.cardName ?? '*',
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: InkWell(
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
                        state.metadata.value.chartType?.first.code, Assets.imageAnalyticsChartLine),
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
            if (logic.getAnalyticsChartTypeIfMultiple())
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
                          state.metadata.value.chartType?.last.code, Assets.imageAnalyticsChartList),
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: _createMetricsByDimsWidget(),
        ),
      ]),
    );
  }

  Widget _createMetricsByDimsWidget() {
    return Text.rich(
      TextSpan(children: [
        WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: ExpandableTextButtonPage(
                textWidget: Flexible(
                  child: Text(
                      logic.getMetricsList().isEmpty
                          ? '***'
                          : logic.getMetricsList()[state.selectedMetricsIndex.value].metricName ?? '',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                iconWidget: logic.getMetricsList().isEmpty
                    ? null
                    : const Image(
                        image: AssetImage(Assets.imageArrowDropDown),
                      ),
                onPressed: () async {
                  if (logic.getMetricsList().isNotEmpty) {
                    await Get.bottomSheet(PickerToolBottomSheetPage(
                        defaultIndex: state.selectedMetricsIndex.value,
                        listTitle: logic.getMetricsList().map((e) => e.metricName ?? '').toList(),
                        selectedItemIndexCallback: (int index) {
                          state.selectedMetricsIndex.value = index;
                          state.selectedMetric.value = logic.getMetricsList()[index];
                          // 重置dim选中下标
                          state.selectedDimsIndex.value = 0;

                          logic.loadData(widget.cardTemplateData);
                        }));
                  }
                })),
        WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.rs_by,
                  style: TextStyle(
                    color: RSColor.color_0x40000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
            )),
        WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: ExpandableTextButtonPage(
                textWidget: Flexible(
                  child: Text(
                    logic.getDimsList(state.selectedMetric.value).isEmpty
                        ? '***'
                        : logic.getDimsList(state.selectedMetric.value)[state.selectedDimsIndex.value].dimName ?? '',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                iconWidget: logic.getDimsList(state.selectedMetric.value).isEmpty
                    ? null
                    : const Image(
                        image: AssetImage(Assets.imageArrowDropDown),
                      ),
                onPressed: () async {
                  if (logic.getDimsList(state.selectedMetric.value).isNotEmpty) {
                    await Get.bottomSheet(PickerToolBottomSheetPage(
                        defaultIndex: state.selectedDimsIndex.value,
                        listTitle: logic.getDimsList(state.selectedMetric.value).map((e) => e.dimName ?? '').toList(),
                        selectedItemIndexCallback: (int index) {
                          state.selectedDimsIndex.value = index;
                          logic.loadData(widget.cardTemplateData);
                        }));
                  }
                })),
      ]),
    );
  }

  Widget _createListWidget() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: _createTitleWidget(),
      ),
      Column(
        children: _createItemsWidget(),
      ),
      if (state.resultMetricsCardEntity.value.table != null &&
          state.resultMetricsCardEntity.value.table!.rows != null &&
          state.resultMetricsCardEntity.value.table!.rows!.length > state.showMaxLength)
        InkWell(
          onTap: () async {
            Get.bottomSheet(
                isScrollControlled: true,
                PeriodAndGroupBottomSheetPage(
                  title: widget.cardTemplateData?.cardName ?? '*',
                  listTitleWidget: _createTitleWidget(),
                  listItemWidget: _createItemsWidget(isBottomSheet: true),
                ));
          },
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              S.current.rs_show_all,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
    ]);
  }

  List<Widget> _createItemsWidget({bool isBottomSheet = false}) {
    List<Widget> widgets = [];

    if (state.resultMetricsCardEntity.value.table != null) {
      int showMaxLength = state.showMaxLength;

      int entityTableRowsLength = state.resultMetricsCardEntity.value.table?.rows?.length ?? 0;
      if (isBottomSheet) {
        showMaxLength = entityTableRowsLength;
      } else {
        if (entityTableRowsLength < showMaxLength) {
          showMaxLength = entityTableRowsLength;
        }
      }

      int rowsLoopIndex = 0;

      state.resultMetricsCardEntity.value.table?.rows?.forEach((rowsElement) {
        List<Widget> rowWidgets = [];
        int headerLoopIndex = 1;

        if (rowsLoopIndex >= showMaxLength) {
          return;
        }

        state.resultMetricsCardEntity.value.table?.header?.forEach((headerElement) {
          if (rowsElement.containsKey(headerElement.code) && rowsElement[headerElement.code] != null) {
            ModuleMetricsCardTableRowsSubElement rowsSubElement =
                ModuleMetricsCardTableRowsSubElement.fromJson(rowsElement[headerElement.code]);

            rowWidgets.add(Expanded(
                child: InkWell(
                    onTap: () {
                      if (!widget.pageEditing) {
                        logic.jumpEntityListPage(
                            rowsSubElement.drillDownInfo, rowsSubElement.value ?? '-', rowsSubElement.code);
                      }
                    },
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
    }

    return widgets;
  }

  Widget _createChartWidget(double height, AddMetricsChartType? chartType) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 8, right: 8),
      height: height,
      child: SfCartesianChart(
          enableAxisAnimation: true,
          legend: Legend(
            isVisible: logic.getIsShowCompareLine(),
            // toggleSeriesVisibility: true,
            // overflowMode: LegendItemOverflowMode.none,
            overflowMode: LegendItemOverflowMode.wrap,
            padding: 4,
            itemPadding: 8,

            // legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
            //   return Row(
            //     mainAxisSize: MainAxisSize.min,
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
          // tooltipBehavior: TooltipBehavior(
          //     enable: true,
          //     color: Colors.white,
          //     builder: (data, point, series, int pointIndex, int seriesIndex) {
          //       return ChartTooltips().createChartTooltipWidget(
          //           point.x,
          //           point.y.toString(),
          //           state.allChartData.first.dataType,
          //           logic.getMetricsList()[state.selectedMetricsIndex.value].metricName ?? '');
          //     }),
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
            majorTickLines: const MajorTickLines(width: 0),
            majorGridLines: const MajorGridLines(width: 1, color: RSColor.color_0xFFF3F3F3),
            numberFormat:
                state.metadata.value.metrics?[state.selectedMetricsIndex.value].dataType == MetricOrDimDataType.CURRENCY
                    ? NumberFormat.compactCurrency(
                        symbol: RSAccountManager().getCurrency()?.symbol,
                        decimalDigits: 1,
                      )
                    : null,
          ),
          palette: RSColor.chartColors,
          plotAreaBorderColor: Colors.transparent,
          series: _buildChartTypeSeries(chartType)),
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
    if (!logic.getIsShowCompareLine()) {
      return [
        ColumnSeries<RSChartData, String>(
          dataSource: state.allChartData,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
        )
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
        ),
        if (state.allChartDayCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_yesterday,
            dataSource: state.allChartDayCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartWeekCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_week,
            dataSource: state.allChartWeekCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartMonthCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_month,
            dataSource: state.allChartMonthCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartYearCompData.isNotEmpty)
          ColumnSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_year,
            dataSource: state.allChartYearCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
      ];
    }
  }

  List<CartesianSeries> _buildStackedLineSeries() {
    if (!logic.getIsShowCompareLine()) {
      return [
        SplineAreaSeries<RSChartData, String>(
          splineType: SplineType.monotonic,
          dataSource: state.allChartData,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
          borderColor: RSColor.getChartColor(0),
          gradient: state.gradientColors,
        )
      ];
    } else {
      return [
        SplineSeries<RSChartData, String>(
          name: S.current.rs_current,
          splineType: SplineType.monotonic,
          onRendererCreated: (ChartSeriesController controller) {
            state.chartSeriesController = controller;
          },
          dataSource: state.allChartData,
          legendIconType: LegendIconType.circle,
          xValueMapper: (RSChartData data, _) => data.x,
          yValueMapper: (RSChartData data, _) => data.y,
        ),
        if (state.allChartDayCompData.isNotEmpty)
          SplineSeries<RSChartData, String>(
            name: S.current.rs_date_tool_yesterday,
            splineType: SplineType.monotonic,
            dataSource: state.allChartDayCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartWeekCompData.isNotEmpty)
          SplineSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_week,
            splineType: SplineType.monotonic,
            dataSource: state.allChartWeekCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartMonthCompData.isNotEmpty)
          SplineSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_month,
            splineType: SplineType.monotonic,
            dataSource: state.allChartMonthCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
        if (state.allChartYearCompData.isNotEmpty)
          SplineSeries<RSChartData, String>(
            name: S.current.rs_date_tool_last_year,
            splineType: SplineType.monotonic,
            dataSource: state.allChartYearCompData,
            legendIconType: LegendIconType.circle,
            xValueMapper: (RSChartData data, _) => data.x,
            yValueMapper: (RSChartData data, _) => data.y,
          ),
      ];
    }
  }

  // Widget _createTitleWidget() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 16),
  //     height: 48.h,
  //     color: RSColor.color_0xFFF9F9F9,
  //     child: Row(
  //       children: [
  //         Flexible(
  //           flex: 4,
  //           fit: FlexFit.tight,
  //           child: _createTitleTextWidget(
  //               logic.getDimsList(state.selectedMetric.value).isEmpty
  //                   ? ''
  //                   : logic.getDimsList(state.selectedMetric.value)[state.selectedDimsIndex.value].dimName ?? '',
  //               null),
  //         ),
  //         Flexible(
  //           flex: 4,
  //           fit: FlexFit.tight,
  //           child: _createTitleTextWidget(
  //               logic.getMetricsList().isEmpty
  //                   ? ''
  //                   : logic.getMetricsList()[state.selectedMetricsIndex.value].metricName ?? '',
  //               TextAlign.right),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  Widget _createTitleTextWidget(String title, {TextAlign? textAlign = TextAlign.left}) {
    return Text(
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
      mainAxisAlignment: MainAxisAlignment.center,
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
          widget.pageEditing ? const Text('-') : AnalyticsTools.buildCompareWidget(compValueEntity),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
