import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_chart/target_analysis_chart_view.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_data_grid/target_analysis_data_grid_view.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_group/target_analysis_group_view.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_summary/target_analysis_summary.dart';
import 'package:flutter_report_project/widget/analytics/target_analysis/target_analysis_total_achievement_rate/target_analysis_total_achievement_rate_view.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/store/store_entity.dart';
import '../../../utils/date_util.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../custom_app_bar/rs_store/store_title_widget.dart';
import '../../expandable_text_button/expandable_text_button_view.dart';
import '../../popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import '../../popup_widget/drop_down_popup/rs_popup.dart';
import '../../popup_widget/general_drop_down_view/general_drop_down_view.dart';
import '../../popup_widget/rs_bubble_popup.dart';
import 'target_analysis_logic.dart';

/// 目标达成分析
class TargetAnalysisPage extends StatefulWidget {
  const TargetAnalysisPage({super.key});

  @override
  State<TargetAnalysisPage> createState() => _TargetAnalysisPageState();
}

class _TargetAnalysisPageState extends State<TargetAnalysisPage> {
  final logic = Get.put(TargetAnalysisLogic());
  final state = Get.find<TargetAnalysisLogic>().state;

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  Function onTap = () {};

  @override
  void dispose() {
    Get.delete<TargetAnalysisLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: state.targetManageConfigEntity.value.titleMsg?.title ?? '',
          actions: [
            _createInfoCheckPopupWidget(),
          ],
        ),
        body: Column(
          children: [
            _buildHeaderWidget(),
            Expanded(
              child: CardLoadStateLayout(
                state: state.loadState.value,
                successWidget:
                    state.targetManageOverviewEntity.value.overall == null ? _createNotDataView() : _buildBodyWidget(),
                reloadCallback: () {
                  logic.getTargetAnalysisConfig();
                },
                errorCode: state.errorCode,
                errorMessage: state.errorMessage,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _createNotDataView() {
    return Container(
      width: 1.sw,
      height: double.infinity,
      color: RSColor.color_0xFFF3F3F3,
      alignment: Alignment.center,
      child: Text(
        S.current.rs_no_data,
        style: const TextStyle(
          color: RSColor.color_0x40000000,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // 总结卡片
          TargetAnalysisSummaryPage(
            summary: state.targetManageOverviewEntity.value.summary,
            // onTap: () {
            //   Get.bottomSheet(
            //     TargetAnalysisDataGridBottomSheetPage(
            //         title: state.targetManageOverviewEntity.value.shopAchievementDetail?.title ?? '*',
            //         bodyWidget: dataGridWidget),
            //     isScrollControlled: true,
            //   );
            // },
            onTap: () {
              onTap.call();
            },
          ),
          // 总体达成率
          TargetAnalysisTotalAchievementRatePage(
            overall: state.targetManageOverviewEntity.value.overall,
          ),
          // 门店达成率
          TargetAnalysisGroupPage(
            shopAchievement: state.targetManageOverviewEntity.value.shopAchievement,
          ),
          // 目标达成趋势
          TargetAnalysisChartPage(
            selectedMetric: state.selectedMetric.value,
            cumulativeTrend: state.targetManageOverviewEntity.value.cumulativeTrend,
            dailyTrend: state.targetManageOverviewEntity.value.dailyTrend,
          ),
          // 门店目标达成情况
          TargetAnalysisDataGridPage(
            shopAchievementDetail: state.targetManageOverviewEntity.value.shopAchievementDetail,
            filterInfo: state.targetManageConfigEntity.value.filterInfo,
            onTapCallback: (Function onTapCallback) {
              onTap = onTapCallback;
            },
          ),
          SizedBox(height: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      key: globalKeyHeadWidget,
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Column(
              children: [
                // 门店名称视图
                Row(
                  children: [
                    StoreTitleWidget(
                      selectedShops: state.selectedShops,
                      storeEntity: state.storeEntity.value,
                      selectedCurrencyValue: state.selectedCurrencyValue.value,
                      applyCallback: (
                        List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
                        List<String> allSelectedBrandIds,
                        String currencyValue,
                        StoreSelectedGroupType groupType,
                      ) async {
                        // 重置所有门店的选中状态
                        RSAccountManager().allSelectedShopsFalse(state.storeEntity.value);

                        List<StoreCurrencyShopsGroupShops>? groupShops;
                        switch (groupType) {
                          case StoreSelectedGroupType.allType:
                            groupShops = state.storeEntity.value.currencyShops
                                ?.firstWhere((element) => element.currency?.value == currencyValue)
                                .allShops;
                          case StoreSelectedGroupType.groupType:
                            groupShops = state.storeEntity.value.currencyShops
                                ?.firstWhere((element) => element.currency?.value == currencyValue)
                                .groupShops;
                        }
                        // 赋值选中的分组类型：全部门店 or 分组门店
                        state.storeEntity.value.selectedGroupType = groupType;

                        // 循环赋值
                        var shopIdsB = allSelectedShops.map((selectedShop) => selectedShop.shopId).toSet();
                        groupShops?.forEach((groupShop) {
                          groupShop.brandShops?.forEach((shop) {
                            shop.isSelected = shopIdsB.contains(shop.shopId);
                          });
                        });

                        // 选中的门店
                        state.selectedShops.value = allSelectedShops;
                        // 选中的货币value
                        state.selectedCurrencyValue.value = currencyValue;
                        // 重新获取数据
                        logic.getTargetAnalysisOverview();
                      },
                    ),
                  ],
                ),
                CustomDateToolWidgetPage(
                  key: const ObjectKey(TargetAnalysisPage),
                  isShowCompareWidget: false,
                  displayTime:
                      state.currentCustomDateTime.isEmpty ? RSAccountManager().timeRange : state.currentCustomDateTime,
                  customDateToolEnum: state.customDateToolEnum,
                  compareDateRangeTypes: const [],
                  dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                      List<List<DateTime>>? compareDateTimeRanges,
                      List<DateTime> displayTime,
                      CustomDateToolEnum customDateToolEnum) {
                    state.customDateToolEnum = customDateToolEnum;

                    // var tmpDisplayTime = displayTime;
                    // if (customDateToolEnum == CustomDateToolEnum.month) {
                    //   // 获取月份的最后一天
                    //   tmpDisplayTime.last = DateTime(tmpDisplayTime.last.year, tmpDisplayTime.last.month + 1, 0);
                    //   state.currentCustomDateTime = tmpDisplayTime;
                    //   state.timeRange.value = RSDateUtil.dateRangeToListString(tmpDisplayTime);
                    // } else {
                    state.currentCustomDateTime = displayTime;
                    state.timeRange.value = RSDateUtil.dateRangeToListString(displayTime);
                    // }

                    if (state.isFirstLoad.value) {
                      state.isFirstLoad.value = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await logic.getTargetAnalysisConfig();
                      });
                      return;
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await logic.getTargetAnalysisOverview();
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildMetricsSwitchWidget(),
                ),
              ],
            ),
          ),
          if (state.showTip.value &&
              state.targetManageOverviewEntity.value.unSetShopInfo?.shopInfos != null &&
              state.targetManageOverviewEntity.value.unSetShopInfo!.shopInfos!.isNotEmpty)
            _buildTipWidget(),
        ],
      ),
    );
  }

  /// 维度切换视图
  Widget _buildMetricsSwitchWidget() {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 8, right: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: ExpandableTextButtonPage(
        textWidget: Expanded(
          child: Text(
            state.selectedMetric.value.name ?? '',
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        iconWidget: const Icon(
          Icons.keyboard_arrow_down,
        ),
        onPressed: () async {
          if (globalKeyHeadWidget.currentContext != null) {
            // widget在屏幕上的坐标。
            Offset offset = flustars.WidgetUtil.getWidgetLocalToGlobal(globalKeyHeadWidget.currentContext!);
            // widget宽高。
            Rect rect = flustars.WidgetUtil.getWidgetBounds(globalKeyHeadWidget.currentContext!);

            var metrics = state.targetManageConfigEntity.value.metrics;

            var metricsTitleList = metrics?.map((metric) => metric.name ?? '').toList();

            var findIndex = metrics?.indexWhere((element) => element.name == state.selectedMetric.value.name) ?? 0;

            if (findIndex == -1) {
              findIndex == 0;
            }

            return await RSPopup.show(
                Get.context!,
                RSCustomDropDownPage(
                  paddingTop: offset.dy + rect.height,
                  maxHeight: 1.sh * 0.4,
                  customWidget: GeneralDropDownView(
                      type: GeneralDropDownType.single,
                      contextText: metricsTitleList ?? [],
                      defaultIndexList: [findIndex],
                      applyCallback: (List<int> selectedIndexList) async {
                        debugPrint("selectedIndexList = $selectedIndexList");

                        if (metrics != null && metrics.length > selectedIndexList.first) {
                          state.selectedMetric.value = metrics[selectedIndexList.first];
                          state.metricCode = metrics[selectedIndexList.first].code ?? '';
                        }

                        logic.getTargetAnalysisOverview();
                      }),
                ),
                offsetLT: Offset(0, offset.dy + rect.height),
                cancelable: false);
          }
        },
      ),
    );
  }

  /// 提示视图
  Widget _buildTipWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: const Color(0xFFFFF1E9),
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Color(0xFFE37318),
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    state.targetManageOverviewEntity.value.unSetShopInfo?.msg ?? '',
                    style: const TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _createTipCheckPopupWidget(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () {
                state.showTip.value = false;
              },
              child: const Image(
                image: AssetImage(Assets.imageCloseSmall),
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 查看弹出视图
  Widget _createTipCheckPopupWidget() {
    return RSBubblePopup(
      barrierColor: Colors.transparent,
      content: _createTipSubviewWidget(),
      child: Text(
        S.current.rs_check,
        style: TextStyle(
          color: RSColor.color_0xFF5C57E6,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// 查看弹出视图子视图
  Widget _createTipSubviewWidget() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeRight: true,
      child: Container(
        constraints: BoxConstraints(
          // 最大高度为十行文本高度
          maxHeight: 10 * 20.0,
          maxWidth: 1.sw - 16 * 2,
        ),
        child: Scrollbar(
          trackVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.targetManageOverviewEntity.value.unSetShopInfo?.shopInfos
                      ?.map((shopInfo) => Text('· ${shopInfo.shopName}'))
                      .toList() ??
                  [],
            ),
          ),
        ),
      ),
    );
  }

  /// 简介弹出视图
  Widget _createInfoCheckPopupWidget() {
    return RSBubblePopup(
      barrierColor: Colors.transparent,
      content: Text(
        state.targetManageConfigEntity.value.titleMsg?.msg ?? '',
        style: TextStyle(
          color: RSColor.color_0x60000000,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: IconButton(
          onPressed: null,
          icon: Image.asset(
            Assets.imageHelpCircle,
            width: 24,
            height: 24,
          )),
    );
  }
}
