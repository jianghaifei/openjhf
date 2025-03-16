import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_data_grid/target_analysis_data_grid_bottom_sheet/target_analysis_data_grid_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_data_grid/target_analysis_data_grid_filter_page/target_analysis_data_grid_filter_page_view.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../../model/target_manage/target_manage_config_entity.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../card_load_state_layout.dart';
import '../../../metric_card_general_widget.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_source.dart';
import 'target_analysis_data_grid_logic.dart';

/// 门店目标达成情况
class TargetAnalysisDataGridPage extends StatefulWidget {
  const TargetAnalysisDataGridPage(
      {super.key, this.shopAchievementDetail, this.filterInfo, required this.onTapCallback});

  final TargetManageOverviewShopAchievementDetail? shopAchievementDetail;

  final TargetManageConfigFilterInfo? filterInfo;

  final Function(VoidCallback onTap) onTapCallback;

  @override
  State<TargetAnalysisDataGridPage> createState() => _TargetAnalysisDataGridPageState();
}

class _TargetAnalysisDataGridPageState extends State<TargetAnalysisDataGridPage> {
  final logic = Get.put(TargetAnalysisDataGridLogic());
  final state = Get.find<TargetAnalysisDataGridLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetAnalysisDataGridLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.setGridData(widget.shopAchievementDetail);

    widget.onTapCallback(() {
      popupShopAchievementDetail(widget.shopAchievementDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MetricCardGeneralWidget(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createHeadWidget(),
            (state.resultStorePKTableEntity.value.table?.rows == null ||
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
                : _createBodyWidget(),
          ],
        ),
      );
    });
  }

  Widget _createHeadWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.shopAchievementDetail?.title ?? '*',
              style: const TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: ExpandableTextButtonPage(
                  textWidget: Flexible(
                    child: Text(
                      logic.getRightTitle(widget.filterInfo),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  iconWidget: const Image(
                    image: AssetImage(Assets.imageArrowDropDown),
                  ),
                  onPressed: () async {
                    await Get.bottomSheet(
                      TargetAnalysisDataGridFilterPage(
                          filterInfo: widget.filterInfo,
                          targetAnalysisDataGridFilterCallBack: (List<int> selectedFilterList) {
                            // 根据filterList数组下标，获取筛选后的filterInfo数据
                            var filterRules = logic.getFilterRules(widget.filterInfo, selectedFilterList);

                            logic.filterData(
                                filterRules, widget.filterInfo?.filterCode ?? '', widget.shopAchievementDetail);
                          }),
                      isScrollControlled: true,
                      isDismissible: false,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBodyWidget() {
    return CardLoadStateLayout(
      state: state.loadState.value,
      successWidget: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              _createDataGridWidget(),
              if (state.resultStorePKTableEntity.value.table?.rows != null &&
                  state.resultStorePKTableEntity.value.table!.rows!.isNotEmpty &&
                  state.resultStorePKTableEntity.value.table!.rows!.length > state.showMaxLength)
                _createDataGridFooterWidget(),
            ],
          )),
      reloadCallback: () {},
      errorCode: state.errorCode,
      errorMessage: state.errorMessage,
    );
  }

  Widget _createDataGridWidget({StorePKTableEntity? storePKTableEntity, bool isScroll = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: StoresDataGridSubviewPage(
            physics: isScroll ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
            compareTypesLength: 0,
            storePKTableEntity: storePKTableEntity ?? state.resultStorePKTableEntity.value,
            refreshCallback: () {},
            ifDisplayTableSummary: false,
            ifUseBottomSpacing: false,
            allowPullToRefresh: false,
            ifCardStyle: true,
            dataGridStyle: DataGridStyle.storeTargetType,
            // 实时桌台没有对比
            maxHeight: logic.getDataGridSubviewHeight(0, entity: storePKTableEntity),
            jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
              return null;
            },
          ),
        ),
        const Divider(
          color: RSColor.color_0xFFF3F3F3,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }

  Widget _createDataGridFooterWidget() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          TargetAnalysisDataGridBottomSheetPage(
              title: widget.shopAchievementDetail?.title ?? '*',
              bodyWidget: Expanded(
                child: _createDataGridWidget(isScroll: true),
              )),
          isScrollControlled: true,
        );
      },
      child: Container(
        width: 1.sw - 32,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          S.current.rs_all,
          style: const TextStyle(
            color: RSColor.color_0xFF5C57E6,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void popupShopAchievementDetail(TargetManageOverviewShopAchievementDetail? shopAchievementDetail,
      {StorePKTableEntity? storePKTableEntity}) {
    Get.bottomSheet(
      TargetAnalysisDataGridBottomSheetPage(
          title: shopAchievementDetail?.title ?? '*',
          bodyWidget: Flexible(
            child: _createDataGridWidget(
                storePKTableEntity: logic.filterData(logic.getCustomFilterRules(widget.filterInfo),
                    widget.filterInfo?.filterCode ?? '', widget.shopAchievementDetail,
                    isReturn: true),
                isScroll: true),
          )),
      isScrollControlled: true,
    );
  }
}
