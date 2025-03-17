import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/analytics/analytics_dining_table_card/analytics_dining_table_card_state.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_data_grid_subview/stores_data_source.dart';
import 'package:flutter_report_project/widget/metric_card_general_widget.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../utils/analytics_tools.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import 'analytics_dining_table_card_logic.dart';

/// 桌台卡片
class AnalyticsDiningTableCardPage extends StatefulWidget {
  const AnalyticsDiningTableCardPage(
      {super.key,
      required this.pageEditing,
      required this.cardIndex,
      this.cardTemplateData,
      this.deleteWidgetCallback,
      this.shopIds,
      this.displayTime,
      this.compareDateRangeTypes,
      this.compareDateTimeRanges,
      required this.customDateToolEnum,
      //zlj 添加
      this.alwaysLoadData = true,
      this.padding,
      this.margin,
      this.borderRadius,
      this.from});

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
  State<AnalyticsDiningTableCardPage> createState() => _AnalyticsDiningTableCardPageState();
}

class _AnalyticsDiningTableCardPageState extends State<AnalyticsDiningTableCardPage>
    with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsDiningTableCardLogic logic;
  late AnalyticsDiningTableCardState state;
  // zlj添加
  bool _hasLoadedData = false;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsDiningTableCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsDiningTableCardLogic(), tag: tag);

    logic = Get.find<AnalyticsDiningTableCardLogic>(tag: tag);
    state = Get.find<AnalyticsDiningTableCardLogic>(tag: tag).state;
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.shopIds = widget.shopIds;
      state.displayTime = widget.displayTime;
      state.compareDateRangeTypes = widget.compareDateRangeTypes;
      state.compareDateTimeRanges = widget.compareDateTimeRanges;
      state.customDateToolEnum = widget.customDateToolEnum;

      if (widget.cardTemplateData?.cardMetadata != null) {
        state.cardIndex = widget.cardIndex;
      }
      logic.loadData(widget.cardTemplateData);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 刷新时机
    if (widget.pageEditing) {
      logic.getTestData(widget.cardTemplateData, widget.cardIndex);
    } else if (widget.alwaysLoadData || !_hasLoadedData) {
      initData();
      _hasLoadedData = true;
    }

    super.build(context);
    return Obx(() {
      return Visibility(
        visible: (widget.pageEditing ||
            !(state.resultStorePKTableEntity.value.table?.rows == null ||
                state.resultStorePKTableEntity.value.table!.rows!.isEmpty)),
        child: MetricCardGeneralWidget(
          enableEditing: false,
          deleteWidgetCallback: () {
            widget.deleteWidgetCallback?.call(widget.cardIndex);
          },
          padding: widget.padding ?? const EdgeInsets.only(top: 16),
          margin: widget.margin,
          borderRadius: widget.borderRadius,
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
      successWidget: (state.resultStorePKTableEntity.value.table?.rows == null ||
              state.resultStorePKTableEntity.value.table!.rows!.isEmpty)
          ? Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 140,
              child: Text(
                S.current.rs_no_data,
                style: const TextStyle(
                  color: RSColor.color_0x40000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: StoresDataGridSubviewPage(
                physics: const NeverScrollableScrollPhysics(),
                compareTypesLength: 0,
                storePKTableEntity: state.resultStorePKTableEntity.value,
                refreshCallback: () {
                  logic.loadData(widget.cardTemplateData);
                },
                ifDisplayTableSummary: false,
                ifUseBottomSpacing: false,
                allowPullToRefresh: false,
                ifCardStyle: true,
                dataGridStyle: DataGridStyle.diningTableType,
                // 实时桌台没有对比
                maxHeight: logic.getDataGridSubviewHeight(0),
                jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
                  AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, {"filterMetricCode": filterMetricCode});
                },
              ),
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
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              widget.cardTemplateData?.cardName ?? '*',
              maxLines: 2,
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
                    logic.jumpDiningTableListPage();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: ShapeDecoration(
                    color: RSColor.color_0xFF5C57E6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(67),
                    ),
                  ),
                  child: Text(
                    S.current.rs_analysis,
                    style: TextStyle(
                      color: RSColor.color_0xFFFFFFFF,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
