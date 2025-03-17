import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../function/analytics/analytics_entity_list_page/analytics_entity_list_drawer/analytics_entity_list_drawer_view.dart';
import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../../utils/analytics_tools.dart';
import '../../../../utils/logger/logger_helper.dart';
import '../../../card_load_state_layout.dart';
import '../../../expandable_text_button/expandable_text_button_view.dart';
import '../../../popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import '../../../popup_widget/drop_down_popup/rs_entity_list_filter_drop_down_view.dart';
import '../../../popup_widget/drop_down_popup/rs_popup.dart';
import '../../../popup_widget/general_drop_down_view/general_drop_down_view.dart';
import '../../../rs_app_bar.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import '../../stores_pk/stores_data_grid_subview/stores_data_source.dart';
import 'dining_table_list_logic.dart';

/// 桌台列表页
class DiningTableListPage extends StatefulWidget {
  const DiningTableListPage({super.key});

  @override
  State<DiningTableListPage> createState() => _DiningTableListPageState();
}

class _DiningTableListPageState extends State<DiningTableListPage> {
  final logic = Get.put(DiningTableListLogic());
  final state = Get.find<DiningTableListLogic>().state;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  @override
  void dispose() {
    Get.delete<DiningTableListLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    logic.loadDiningTableListTemplate();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        key: _scaffoldKey,
        appBar: RSAppBar(
          title: state.shopId.isNotEmpty ? RSAccountManager().findShopName(state.shopId.first) : '-',
          actions: [Container()],
        ),
        onEndDrawerChanged: (isOpened) {
          logger.d("onEndDrawerChanged: $isOpened", StackTrace.current);
        },
        endDrawer: Drawer(
          width: 1.sw * 0.9,
          child: AnalyticsEntityListDrawerPage(
            metricsTitle: (state.filterComponentEntity.value.filters != null &&
                    state.filterComponentEntity.value.filters!.isNotEmpty)
                ? (state.filterComponentEntity.value.filters
                        ?.firstWhereOrNull((element) => element.componentType == EntityComponentType.NUM_FILTER)
                        ?.displayName ??
                    "")
                : "",
            filters: state.filterComponentEntity.value.filters,
            filterMinAndMax: state.filterMinAndMax,
            filterTypeString: state.filterNumericalValueTypeString,
            applyCallback: (List<double?> limitNumbers, String filterTypeString,
                List<AnalyticsEntityFilterComponentFilters>? filters) {
              // 设置filter最大最小值
              logic.setMinAndMaxNumbers(limitNumbers, [filterTypeString]);
              state.filterComponentEntity.value.filters = filters;

              // 检查是否拥有过滤条件
              logic.checkIsHaveFilterConditions();

              // 桌台-获取桌台列表
              logic.loadDiningTableList();
            },
          ),
        ),
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
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createCurrentTimeWidget(),
          _buildMetricsSwitchWidget(),
          if (state.selectedFilters.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: 1.sw,
                height: 25,
                child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => _createConditionFilterWidget(index),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 4,
                      );
                    },
                    //state.selectedFilters.length
                    itemCount: state.selectedFilters.length),
              ),
            ),
        ],
      ),
    );
  }

  /// 当前时间视图 + 筛选按钮视图
  Widget _createCurrentTimeWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.currentTimeTitle.value,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              logic.loadDiningTableList();
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
          const Spacer(),
          Container(
            width: 1,
            height: 12,
            decoration: const BoxDecoration(color: RSColor.color_0xFFDCDCDC),
          ),
          InkWell(
            onTap: () {
              debugPrint("打开侧边栏");
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: Container(
              padding: EdgeInsets.only(left: 12),
              alignment: Alignment.centerRight,
              child: Image.asset(
                Assets.imageEntityListFilter,
                color: state.isHaveFilterConditions.value ? RSColor.color_0xFF5C57E6 : RSColor.color_0x60000000,
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 指标选择视图
  Widget _buildMetricsSwitchWidget() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(right: 4),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              padding: EdgeInsets.only(left: 4),
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
                                await logic.loadDiningTableList();
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
              // state.selectedMetrics.length
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
                        await logic.loadDiningTableList();
                      }),
                ),
                offsetLT: Offset(0, offset.dy + rect.height),
                cancelable: false);
          }
        },
      ),
    );
  }

  Widget _createConditionFilterWidget(int index) {
    String? itemTitle;

    var currentFilter = state.selectedFilters[index];
    if (currentFilter.componentType == EntityComponentType.NUM_FILTER) {
      var optionValue = currentFilter.options?.first.value;
      var filterTypeString = AnalyticsTools().returnFilterTypeString(currentFilter.filterType ?? EntityFilterType.EQ);
      if (optionValue != null && optionValue.length > 1) {
        itemTitle = optionValue.map((e) => double.tryParse(e)?.toStringAsFixed(2)).join(filterTypeString);
      } else {
        itemTitle = "$filterTypeString${optionValue?.map((e) => double.tryParse(e)?.toStringAsFixed(2)).join('')}";
      }
    } else {
      itemTitle = currentFilter.options?.map((option) => option.displayName).join(',');
    }

    return Container(
      padding: EdgeInsets.only(left: 8, right: 4),
      constraints: BoxConstraints(
        maxWidth: 100,
      ),
      decoration: ShapeDecoration(
        color: RSColor.color_0xFFF3F3F3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      child: ExpandableTextButtonPage(
          textWidget: Flexible(
            child: Text(
              itemTitle ?? '*',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          iconWidget: Image(
            image: logic.findSelectedFiltersIndex(index) == -1
                ? const AssetImage(Assets.imageCloseSmall)
                : const AssetImage(Assets.imageArrowDropDown),
            width: 16,
            height: 20,
            gaplessPlayback: true,
          ),
          onPressed: () async {
            if (logic.findSelectedFiltersIndex(index) == -1) {
              state.selectedFilters.removeAt(index);
              logic.loadDiningTableList();
            } else {
              await clickConditionAction(index);
            }
          }),
    );
  }

  Future<void> clickConditionAction(int index) async {
    if (globalKeyHeadWidget.currentContext != null) {
      // widget在屏幕上的坐标。
      Offset offset = flustars.WidgetUtil.getWidgetLocalToGlobal(globalKeyHeadWidget.currentContext!);

      // widget宽高。
      Rect rect = flustars.WidgetUtil.getWidgetBounds(globalKeyHeadWidget.currentContext!);

      var tmpFilters = state.filterComponentEntity.value.filters?[logic.findSelectedFiltersIndex(index)];

      return await RSPopup.show(
          Get.context!,
          RSCustomDropDownPage(
            paddingTop: offset.dy + rect.height,
            maxHeight: 1.sh * 0.5,
            customWidget: RSEntityListFilterDropDownView(
              filters: tmpFilters,
              applyCallback: () {
                logic.checkIsHaveFilterConditions();

                logic.loadDiningTableList();
              },
              limitNumbersApplyCallback: (limitNumbers, filterTypeString) {
                logic.setMinAndMaxNumbers(limitNumbers, [filterTypeString]);
              },
            ),
          ),
          offsetLT: Offset(0, offset.dy + rect.height),
          cancelable: false);
    }
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
            logic.loadDiningTableList();
          },
          jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
            AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, {"filterMetricCode": filterMetricCode});
          },
        ),
      ),
      reloadCallback: () async {
        // 重新加载所有数据
        await logic.loadDiningTableListTemplate();
      },
      errorCode: state.errorCode,
      errorMessage: state.errorMessage,
    ));
  }
}
