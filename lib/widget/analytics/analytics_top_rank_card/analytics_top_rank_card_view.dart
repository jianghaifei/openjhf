import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/analytics/analytics_top_rank_card/analytics_top_rank_card_state.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../widget/metric_card_general_widget.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import 'analytics_top_rank_card_logic.dart';

/// 排行卡片
class AnalyticsTopRankCardPage extends StatefulWidget {
  const AnalyticsTopRankCardPage({
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
  State<AnalyticsTopRankCardPage> createState() => _AnalyticsTopRankCardPageState();
}

class _AnalyticsTopRankCardPageState extends State<AnalyticsTopRankCardPage> with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late AnalyticsTopRankCardLogic logic;
  late AnalyticsTopRankCardState state;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsTopRankCardLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => AnalyticsTopRankCardLogic(), tag: tag);

    logic = Get.find<AnalyticsTopRankCardLogic>(tag: tag);
    state = Get.find<AnalyticsTopRankCardLogic>(tag: tag).state;
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
      padding: const EdgeInsets.only(top: 16),
      child: Obx(() {
        return InkWell(
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
        );
      }),
    );
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
                compareTypesLength: state.compareDateRangeTypes?.length ?? 0,
                storePKTableEntity: state.resultStorePKTableEntity.value,
                refreshCallback: () {
                  logic.loadPKTableQuery();
                },
                ifDisplayTableSummary: false,
                ifUseBottomSpacing: false,
                allowPullToRefresh: false,
                ifCardStyle: true,
                maxHeight: logic.getDataGridSubviewHeight(state.compareDateRangeTypes?.length ?? 0),
                jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
                  logic.jumpEntityListPage(drillDownInfo, filterMetricCode);
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              widget.cardTemplateData?.cardName ?? '*',
              maxLines: 2,
              style: const TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
                onTap: () {
                  if (!widget.pageEditing) {
                    logic.jumpStoresPKPage();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: ShapeDecoration(
                    color: RSColor.color_0xFF5C57E6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(67),
                    ),
                  ),
                  child: const Text(
                    'PK',
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
