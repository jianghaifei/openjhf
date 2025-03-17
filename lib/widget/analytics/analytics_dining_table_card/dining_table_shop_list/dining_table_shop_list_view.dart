import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../../model/store/store_entity.dart';
import '../../../../utils/analytics_tools.dart';
import '../../../../utils/logger/logger_helper.dart';
import '../../../card_load_state_layout.dart';
import '../../../custom_app_bar/rs_store/store_title_widget.dart';
import '../../../expandable_text_button/expandable_text_button_view.dart';
import '../../../popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import '../../../popup_widget/drop_down_popup/rs_popup.dart';
import '../../../popup_widget/general_drop_down_view/general_drop_down_view.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_source.dart';
import 'dining_table_shop_list_logic.dart';

/// 桌台——门店列表页
class DiningTableShopListPage extends StatefulWidget {
  const DiningTableShopListPage({super.key});

  @override
  State<DiningTableShopListPage> createState() => _DiningTableShopListPageState();
}

class _DiningTableShopListPageState extends State<DiningTableShopListPage> {
  final logic = Get.put(DiningTableShopListLogic());
  final state = Get.find<DiningTableShopListLogic>().state;

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  @override
  void dispose() {
    Get.delete<DiningTableShopListLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    logic.loadDiningTableShopsListTemplate();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(title: state.templateEntity.value.cardName),
        body: Column(
          children: [
            _buildHeadWidget(),
            _buildBodyWidget(),
          ],
        ),
      );
    });
  }

  Widget _buildHeadWidget() {
    return Container(
      key: globalKeyHeadWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        children: [
          Row(
            children: [
              // 门店名称视图
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
                  logger.d("RSStorePage-refreshCallBack", StackTrace.current);

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

                  // 桌台-获取门店列表模板
                  await logic.loadDiningTableShopsList();
                },
              ),
              SizedBox(
                width: 16,
              ),
              _createCurrentTimeWidget(),
            ],
          ),
          _buildMetricsSwitchWidget(),
        ],
      ),
    );
  }

  /// 当前时间视图
  Widget _createCurrentTimeWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            logic.loadDiningTableShopsList();
          },
          child: SizedBox(
            width: 16,
            height: 16,
            child: Image.asset(
              Assets.imageRefresh,
              color: RSColor.color_0x60000000,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          state.currentTimeTitle.value,
          style: TextStyle(
            color: RSColor.color_0x90000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// 指标选择视图
  Widget _buildMetricsSwitchWidget() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(right: 4),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: ExpandableTextButtonPage(
        textWidget: Expanded(
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 8),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.only(left: 8, right: 4),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFFF3F3F3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.selectedMetrics[index].metricName ?? '',
                          style: TextStyle(
                            color: RSColor.color_0x90000000,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              if (state.selectedMetrics.length > 1) {
                                await logic.changeMetricsIfDefaultTrueIndex(index);
                                await logic.loadDiningTableShopsList();
                              } else {
                                EasyLoading.showToast(S.current.rs_please_select_at_least_one_metric);
                              }
                            },
                            child: const Image(
                              image: AssetImage(Assets.imageCloseSmall),
                              width: 16,
                              height: 16,
                            )),
                      ],
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 4,
                );
              },
              itemCount: state.selectedMetrics.length),
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

            var metrics = state.templateEntity.value.cardMetadata?.metrics;

            var metricsTitleList = metrics?.map((metric) => metric.metricName ?? '').toList();

            var trueIndices = logic.getMetricsIfDefaultTrueIndexList(isChangeMetricsValue: false);

            return await RSPopup.show(
                Get.context!,
                RSCustomDropDownPage(
                  paddingTop: offset.dy + rect.height,
                  maxHeight: 1.sh * 0.4,
                  customWidget: GeneralDropDownView(
                      contextText: metricsTitleList ?? [],
                      defaultIndexList: trueIndices,
                      applyCallback: (List<int> selectedIndexList) async {
                        debugPrint("selectedIndexList = $selectedIndexList");
                        await logic.changeMetricsIfDefaultTrueIndexList(selectedIndexList);
                        await logic.loadDiningTableShopsList();
                      }),
                ),
                offsetLT: Offset(0, offset.dy + rect.height),
                cancelable: false);
          }
        },
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Expanded(
        child: CardLoadStateLayout(
      state: state.loadState.value,
      successWidget: Container(
        padding: EdgeInsets.only(top: 8),
        color: RSColor.color_0xFFF3F3F3,
        child: StoresDataGridSubviewPage(
          dataGridStyle: DataGridStyle.diningTableType,
          compareTypesLength: 0,
          storePKTableEntity: state.storePKTableEntity.value,
          refreshCallback: () {
            logic.loadDiningTableShopsList();
          },
          jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
            AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, {"filterMetricCode": filterMetricCode});
          },
        ),
      ),
      reloadCallback: () async {
        // 重新加载所有数据
        await logic.loadDiningTableShopsListTemplate();
      },
      errorCode: state.errorCode,
      errorMessage: state.errorMessage,
    ));
  }
}
