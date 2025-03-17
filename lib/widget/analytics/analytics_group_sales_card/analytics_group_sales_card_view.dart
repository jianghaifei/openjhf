import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/model/chart_data/rs_chart_data.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/widget/analytics/analytics_group_sales_card/analytics_group_sales_card_state.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../widget/metric_card_general_widget.dart';
import '../../bottom_sheet/hourly_and_group_bottom_sheet/period_and_group_bottom_sheet_view.dart';
import '../../bottom_sheet/picker_tool_bottom_sheet/picker_tool_bottom_sheet_view.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../expandable_text_button/expandable_text_button_view.dart';
import '../../popup_widget/rs_bubble_popup.dart';
import 'analytics_group_sales_card_logic.dart';

class AnalyticsGroupSalesCardPage extends StatefulWidget {
  const AnalyticsGroupSalesCardPage({
    super.key,
    this.pageEditing = false,
    required this.cardIndex,
    this.deleteWidgetCallback,
    this.tabId,
    this.tabName,
    this.cardTemplateData,
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
    this.from,
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
  final bool alwaysLoadData;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final String? from;

  @override
  State<AnalyticsGroupSalesCardPage> createState() => _AnalyticsGroupSalesCardPageState();
}

class _AnalyticsGroupSalesCardPageState extends State<AnalyticsGroupSalesCardPage> with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsGroupSalesCardLogic logic;
  late AnalyticsGroupSalesCardState state;

  // zlj 添加
  bool _hasLoadedData = false;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsGroupSalesCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsGroupSalesCardLogic(), tag: tag);

    logic = Get.find<AnalyticsGroupSalesCardLogic>(tag: tag);
    state = Get.find<AnalyticsGroupSalesCardLogic>(tag: tag).state;
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

      if (widget.alwaysLoadData || !_hasLoadedData) {
        logic.loadData(widget.cardTemplateData);
        _hasLoadedData = true;
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

    return Obx(() {
      double spacing =
          state.metadata.value.chartType?[state.chartTypeStatus.value].code == AddMetricsChartType.LIST ? 0 : 16;

      return MetricCardGeneralWidget(
        enableEditing: widget.pageEditing,
        deleteWidgetCallback: () {
          widget.deleteWidgetCallback?.call(widget.cardIndex);
        },
        padding: widget.padding ?? EdgeInsets.only(top: 16, bottom: spacing),
        margin: widget.margin,
        borderRadius: widget.borderRadius,
        child: InkWell(
          onTap: () {
            if (widget.pageEditing) {
              logic.jumpEditPage();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.chartTypeStatus.value == 0) _createPieChartWidget(),
          if (state.chartTypeStatus.value != 0) _createListWidget(),
        ],
      ),
      reloadCallback: () {
        logic.loadData(widget.cardTemplateData);
      },
      errorCode: state.errorCode,
      errorMessage: state.errorMessage,
    );
  }

  Widget _createHeadWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
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
              InkWell(
                onTap: () {
                  if (!widget.pageEditing) {
                    logic.chartTypeStatusChanged(0, widget.cardTemplateData);
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
                        state.metadata.value.chartType?.first.code, Assets.imageAnalyticsChartPie),
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              if (logic.getAnalyticsChartTypeIfMultiple())
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: InkWell(
                    onTap: () {
                      if (!widget.pageEditing) {
                        logic.chartTypeStatusChanged(1, widget.cardTemplateData);
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
                        Assets.imageAnalyticsChartList,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(child: _createMetricsByDimsWidget()),
                if (state.metadata.value.filterInfo != null) _createFilterTipPopupWidget(),
              ],
            ),
          ),
        ],
      ),
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

  Widget _createPieChartCenterWidget() {
    var metric = state.resultModuleGroupMetricsEntity.value.metrics?.first;
    return Container(
      width: 110,
      height: 110,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnalyticsTools.buildAmountWidget(metric?.displayValue, metric?.abbrDisplayValue, metric?.abbrDisplayUnit,
              abbrDisplayValueFontSize: 20,
              abbrDisplayValueFontWeight: FontWeight.w600,
              mainAxisAlignment: MainAxisAlignment.center),
          Text(
            logic.getMetricsList().isEmpty
                ? ''
                : logic.getMetricsList()[state.selectedMetricsIndex.value].metricName ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPieChartWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (!widget.pageEditing) {
                logic.jumpEntityListPage(state.resultModuleGroupMetricsEntity.value.metrics?.first.drillDownInfo,
                    state.resultModuleGroupMetricsEntity.value.metrics?.first.code);
              }
            },
            child: SizedBox(
                height: 160,
                child: SfCircularChart(
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: _createPieChartCenterWidget(),
                    )
                  ],
                  series: [
                    DoughnutSeries<RSChartData, String>(
                        onRendererCreated: (CircularSeriesController controller) {
                          state.chartSeriesController = controller;
                        },
                        dataSource: state.allChartData,
                        radius: '100%',
                        innerRadius: '80%',
                        animationDuration: 800,
                        strokeColor: Colors.white,
                        strokeWidth: 1,
                        pointColorMapper: (RSChartData data, _) => data.color,
                        xValueMapper: (RSChartData data, _) => data.x,
                        yValueMapper: (RSChartData data, _) => data.y)
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(constraints: BoxConstraints(maxHeight: 300), child: _createWrapWidget()),
          ),
        ],
      ),
    );
  }

  Widget _createWrapWidget() {
    List<Widget> widgets = [];

    if (state.resultModuleGroupMetricsEntity.value.reportData != null &&
        state.resultModuleGroupMetricsEntity.value.reportData?.rows != null) {
      for (int i = 0; i < state.resultModuleGroupMetricsEntity.value.reportData!.rows!.length; i++) {
        var rows = state.resultModuleGroupMetricsEntity.value.reportData!.rows?[i];

        // 维度
        String title = rows?.dims?.first.displayValue ?? '';
        // 同环比
        num percent = rows?.metrics?.first.proportion ?? 0.0;
        // 展示金额
        String displayValue = rows?.metrics?.first.displayValue ?? '';
        // 缩写展示金额
        String abbrDisplayValue = rows?.metrics?.first.abbrDisplayValue ?? '';
        // 缩写展示单位
        String abbrDisplayUnit = rows?.metrics?.first.abbrDisplayUnit ?? '';
        // 是否可下转
        ModuleMetricsCardDrillDownInfo? drillDownInfo = rows?.metrics?.first.drillDownInfo;
        // filterMetricCode
        String? filterMetricCode = rows?.metrics?.first.code;

        widgets.add(
          InkWell(
            onTap: () {
              if (drillDownInfo != null) {
                logic.jumpEntityListPage(drillDownInfo, filterMetricCode);
              }
            },
            child: _createWrapItemWidget(
                title, percent, displayValue, abbrDisplayValue, abbrDisplayUnit, RSColor.getChartColor(i)),
          ),
        );
      }
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeRight: true,
      removeLeft: true,
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 16,
              runSpacing: 16,
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createWrapItemWidget(
      String title, num percent, String displayValue, String abbrDisplayValue, String abbrDisplayUnit, Color color) {
    return SizedBox(
      width: (1.sw - 16 * 5) / 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 12,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                AnalyticsTools.buildAmountWidget(displayValue, abbrDisplayValue, abbrDisplayUnit,
                    abbrDisplayValueFontSize: 14,
                    abbrDisplayValueFontWeight: FontWeight.w600,
                    abbrDisplayUnitFontWeight: FontWeight.w600),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '$percent%',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RSColor.color_0x40000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListWidget() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _createTitleWidget(),
      ),
      Column(
        children: _createItemsWidget(),
      ),
      if (state.resultModuleGroupMetricsEntity.value.reportData?.rows != null &&
          state.resultModuleGroupMetricsEntity.value.reportData!.rows!.length > state.showMaxLength)
        InkWell(
          onTap: () async {
            await logic.loadData(widget.cardTemplateData, loadAllData: true);

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
              style: const TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
    ]);
  }

  Widget _createTitleWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      color: RSColor.color_0xFFF9F9F9,
      child: Row(
        children: [
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: _createTitleTextWidget(
                logic.getDimsList(state.selectedMetric.value).isEmpty
                    ? ''
                    : logic.getDimsList(state.selectedMetric.value)[state.selectedDimsIndex.value].dimName ?? '',
                null),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: _createTitleTextWidget(
                logic.getMetricsList().isEmpty
                    ? ''
                    : logic.getMetricsList()[state.selectedMetricsIndex.value].metricName ?? '',
                null),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _createTitleTextWidget("${S.current.rs_rate}%", TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _createTitleTextWidget(String title, TextAlign? textAlign) {
    return Text(
      title,
      textAlign: textAlign,
      style: const TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<Widget> _createItemsWidget({bool isBottomSheet = false}) {
    List<Widget> widgets = [];

    var rows = state.resultModuleGroupMetricsEntity.value.reportData?.rows;

    if (rows != null) {
      int showMaxLength = state.showMaxLength;

      if (isBottomSheet) {
        showMaxLength = rows.length;
      } else {
        if (rows.length < showMaxLength) {
          showMaxLength = rows.length;
        }
      }

      for (int i = 0; i < showMaxLength; i++) {
        String title = rows[i].dims?.first.displayValue ?? '-';
        double percent = rows[i].metrics?.first.proportion ?? 0.0;
        String abbrDisplayValue = rows[i].metrics?.first.abbrDisplayValue ?? '*';
        String abbrDisplayUnit = rows[i].metrics?.first.abbrDisplayUnit ?? '*';
        String displayValue = rows[i].metrics?.first.displayValue ?? '*';
        ModuleMetricsCardDrillDownInfo? drillDownInfo = rows[i].metrics?.first.drillDownInfo;
        String filterMetricCode = rows[i].metrics?.first.code ?? '';

        widgets.add(InkWell(
          onTap: () => logic.jumpEntityListPage(drillDownInfo, filterMetricCode),
          child: Container(
            height: 48,
            color: i % 2 == 1 ? RSColor.color_0xFFF9F9F9 : RSColor.color_0xFFFFFFFF,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: _createItemTextWidget(title, null, titleColor: RSColor.color_0x60000000),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: AnalyticsTools.buildAmountWidget(
                        displayValue,
                        abbrDisplayValue,
                        abbrDisplayUnit,
                        abbrDisplayValueFontSize: 14,
                        abbrDisplayValueFontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _createItemTextWidget("$percent%", TextAlign.right),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        ));
      }
    }
    return widgets;
  }

  Widget _createItemTextWidget(String title, TextAlign? textAlign, {Color titleColor = RSColor.color_0x90000000}) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        color: titleColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// 查看弹出视图
  Widget _createFilterTipPopupWidget() {
    var filtersMsg = state.metadata.value.filterInfo?.filtersMsg;

    return RSBubblePopup(
      barrierColor: Colors.transparent,
      content: Text(
        filtersMsg != null ? filtersMsg.join('\n') : '*',
        style: const TextStyle(
          color: RSColor.color_0x90000000,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
            borderRadius: BorderRadius.circular(4),
          )),
          child: Image.asset(
            Assets.imageEntityListFilter,
            color: RSColor.color_0xFF5C57E6,
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }
}
