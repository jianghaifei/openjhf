import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../utils/analytics_tools.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../metric_card_general_widget.dart';
import '../../popup_widget/rs_alert/rs_alert_view.dart';
import '../../progress_widget.dart';
import 'analytics_sales_card_logic.dart';
import 'analytics_sales_card_state.dart';

enum AnalyticsSalesCardViewType {
  normal,
  two,
  three,
}

typedef ClickCallBack = Function(TopicTemplateTemplatesNavsTabsCardsCardMetadata cardMetadata);

class AnalyticsSalesCardPage extends StatefulWidget {
  const AnalyticsSalesCardPage({
    super.key,
    required this.cardViewType,
    this.tabId,
    this.tabName,
    this.pageEditing = false,
    this.deleteWidgetCallback,
    required this.cardIndex,
    this.cardTemplateData,
    this.shopIds,
    this.displayTime,
    this.compareDateRangeTypes,
    this.compareDateTimeRanges,
    this.customDateToolEnum = CustomDateToolEnum.DAY,
  });

  final AnalyticsSalesCardViewType cardViewType;
  final String? tabId;
  final String? tabName;
  final TopicTemplateTemplatesNavsTabsCards? cardTemplateData;
  final bool pageEditing;
  final int cardIndex;
  final Function(int cardIndex)? deleteWidgetCallback;

  // 外部传入自定义的时间——影响范围：当前页面
  final List<String>? shopIds;
  final List<DateTime>? displayTime;
  final List<CompareDateRangeType>? compareDateRangeTypes;
  final List<List<DateTime>>? compareDateTimeRanges;
  final CustomDateToolEnum customDateToolEnum;

  @override
  State<AnalyticsSalesCardPage> createState() => _AnalyticsSalesCardPageState();
}

class _AnalyticsSalesCardPageState extends State<AnalyticsSalesCardPage> with AutomaticKeepAliveClientMixin {
  String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsSalesCardLogic logic;
  late AnalyticsSalesCardState state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsSalesCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsSalesCardLogic(), tag: tag);

    logic = Get.find<AnalyticsSalesCardLogic>(tag: tag);
    state = Get.find<AnalyticsSalesCardLogic>(tag: tag).state;
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.shopIds = widget.shopIds;
      state.displayTime = widget.displayTime;
      state.compareDateRangeTypes = widget.compareDateRangeTypes;
      state.compareDateTimeRanges = widget.compareDateTimeRanges;
      state.customDateToolEnum = widget.customDateToolEnum;

      if (widget.cardTemplateData?.cardMetadata != null) {
        logic.loadData(widget.cardTemplateData);
      } else {
        state.loadState.value = CardLoadState.stateError;
      }
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

    return MetricCardGeneralWidget(
      enableEditing: widget.pageEditing,
      deleteWidgetCallback: () {
        widget.deleteWidgetCallback?.call(widget.cardIndex);
      },
      child: Obx(() {
        return CardLoadStateLayout(
          state: state.loadState.value,
          successWidget: _buildBody(),
          reloadCallback: () {
            logic.loadData(widget.cardTemplateData);
          },
          errorCode: state.errorCode,
          errorMessage: state.errorMessage,
        );
      }),
    );
  }

  Widget _buildBody() {
    if (widget.cardViewType == AnalyticsSalesCardViewType.normal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardWidget(0, isShowDivider: false),
          _buildRightWidget(),
        ],
      );
    } else if (widget.cardViewType == AnalyticsSalesCardViewType.two) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardWidget(0),
          _buildDashboardWidget(1, isShowDivider: false),
        ],
      );
    } else if (widget.cardViewType == AnalyticsSalesCardViewType.three) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardWidget(0),
          _buildDashboardWidget(1),
          _buildDashboardWidget(2, isShowDivider: false),
        ],
      );
    }
    return Container();
  }

  Widget _buildDashboardWidget(int index, {bool isShowDivider = true}) {
    if (state.cardTemplateData.value.cardMetadata?.metrics != null &&
        index < state.cardTemplateData.value.cardMetadata!.metrics!.length) {
      String? metricName = state.cardTemplateData.value.cardMetadata!.metrics?[index].metricName;

      String? displayValue, abbrDisplayValue, abbrDisplayUnit, filterMetricCode;

      ModuleMetricsCardCompValue? compValue;
      ModuleMetricsCardDrillDownInfo? drillDownInfo;
      ModuleMetricsCardCompValueAchievement? achievement;

      state.resultMetricsCardEntity.value.metrics?.forEach((resultMetric) {
        filterMetricCode = state.cardTemplateData.value.cardMetadata!.metrics?[index].metricCode;
        if (filterMetricCode == resultMetric.code) {
          displayValue = resultMetric.displayValue;
          abbrDisplayValue = resultMetric.abbrDisplayValue;
          abbrDisplayUnit = resultMetric.abbrDisplayUnit;
          compValue = resultMetric.compValue;
          drillDownInfo = resultMetric.drillDownInfo;
          achievement = resultMetric.achievement;
          return;
        }
      });

      logic.getCompareLineCount(compValue);

      List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation =
          state.cardTemplateData.value.cardMetadata?.metrics?[index].metricExplanation;

      return _createDashboardWidget(metricName, displayValue, abbrDisplayValue, abbrDisplayUnit, compValue, achievement,
          () {
        if (!widget.pageEditing) {
          logic.jumpEntityListPage(drillDownInfo, filterMetricCode);
        }
      }, () {
        // 目标达成概览页
        if (!widget.pageEditing) {
          logic.jumpTargetAnalysisPage(state.cardTemplateData.value.cardMetadata!.metrics?[index].metricCode);
        }
      }, metricExplanation: metricExplanation, isShowDivider: isShowDivider);
    }

    return Container();
  }

  /*
  * metricName: Net Sales
  * displayValue: $22,223,566.00
  * abbrDisplayValue: $22.22
  * abbrDisplayUnit: 亿、千万、百万
  * ModuleMetricsCardCompValue: 对比数据项实体
  * ModuleMetricsCardCompValueAchievement: 目标达成数据实体
  * metricExplanation: tip
  * flex: 默认权重5
  * isShowDivider: 是否显示分割线
  * */
  Widget _createDashboardWidget(
      String? metricName,
      String? displayValue,
      String? abbrDisplayValue,
      String? abbrDisplayUnit,
      ModuleMetricsCardCompValue? compValueEntity,
      ModuleMetricsCardCompValueAchievement? achievement,
      VoidCallback jumpEntityListPageCallback,
      VoidCallback jumpTargetAnalysisPageCallback,
      {List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation,
      int flex = 5,
      bool isShowDivider = true}) {
    double metricNameFontSize = 14;
    double displayValueFontSize = 24;

    switch (widget.cardViewType) {
      case AnalyticsSalesCardViewType.normal:
        metricNameFontSize = 14;
        displayValueFontSize = 24;
        break;
      case AnalyticsSalesCardViewType.two:
        metricNameFontSize = 14;
        displayValueFontSize = 22;
        break;
      case AnalyticsSalesCardViewType.three:
        metricNameFontSize = 12;
        displayValueFontSize = 20;
        break;
    }

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: jumpEntityListPageCallback,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (metricExplanation != null) {
                        Get.dialog(RSAlertPopup(
                          title: metricName,
                          customContentWidget: _buildMetricExplanationWidget(metricExplanation),
                          alertPopupType: RSAlertPopupType.notHaveButton,
                          contentBodyAlignment: Alignment.centerLeft,
                        ));
                      }
                    },
                    child: Row(
                      children: [
                        if (metricExplanation != null)
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Image(
                              image: AssetImage(widget.cardViewType == AnalyticsSalesCardViewType.three
                                  ? Assets.imageInfoCircle12
                                  : Assets.imageInfoCircle14),
                              fit: BoxFit.fill,
                              gaplessPlayback: true,
                              width: 14,
                              height: 14,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            metricName ?? '*',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: RSColor.color_0x40000000,
                              fontSize: metricNameFontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: AnalyticsTools.buildAmountWidget(displayValue, abbrDisplayValue, abbrDisplayUnit,
                        abbrDisplayValueFontSize: displayValueFontSize),
                  ),
                  if (state.showTarget.value)
                    Visibility(
                      visible: achievement != null,
                      maintainSize: state.showTarget.value,
                      maintainAnimation: true,
                      maintainState: true,
                      child: InkWell(
                        onTap: jumpTargetAnalysisPageCallback,
                        child: Row(
                          children: [
                            HorizontalGradientProgressIndicator(progress: achievement?.achievementRate ?? 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                achievement?.displayAchievementRate ?? '0.00%',
                                style: TextStyle(
                                  color: RSColor.color_0x40000000,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (compValueEntity != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: widget.pageEditing ? const Text('-') : AnalyticsTools.buildCompareWidget(compValueEntity),
                    ),
                ],
              ),
            ),
            if (isShowDivider) _createDivider(),
          ],
        ),
      ),
    );
  }

  Widget? _buildMetricExplanationWidget(
      List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetricExplanation>? metricExplanation) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: metricExplanation!
            .map((message) => Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${message.title}: ',
                        style: TextStyle(color: RSColor.color_0x90000000, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: message.msg,
                      ),
                    ],
                  ),
                  style: TextStyle(color: RSColor.color_0x60000000, fontSize: 14, fontWeight: FontWeight.w400),
                ))
            .toList());
  }

  Widget _buildRightWidget() {
    return Expanded(flex: 4, child: Container(color: Colors.transparent, height: 80, child: _createChartWidget()));
  }

  Widget _createChartWidget() {
    return SfCartesianChart(
        margin: EdgeInsets.zero,
        enableAxisAnimation: true,
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          isVisible: false,
        ),
        primaryYAxis: const NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          minorGridLines: MinorGridLines(width: 0),
          isVisible: false,
        ),
        plotAreaBorderColor: Colors.transparent,
        series: _buildStackedLineSeries());
  }

  List<CartesianSeries> _buildStackedLineSeries() {
    return [
      SplineAreaSeries<RSChartData, String>(
        splineType: SplineType.monotonic,
        dataSource: state.allChartData,
        borderColor: RSColor.getChartColor(0),
        xValueMapper: (RSChartData data, _) => data.x,
        yValueMapper: (RSChartData data, _) => data.y,
        gradient: state.gradientColors,
      )
    ];
  }

  Widget _createDivider() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      color: RSColor.color_0xFFF3F3F3,
      width: 1,
      height: state.lineHeight,
    );
  }
}
