import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/pk_dims_bottom_sheet/pk_dims_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_pk_state.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../config/rs_locale.dart';
import '../../../function/analytics/analytics_entity_list_page/analytics_entity_list_drawer/analytics_entity_list_drawer_view.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../utils/analytics_tools.dart';
import '../../../utils/date_util.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import '../../popup_widget/drop_down_popup/rs_entity_list_filter_drop_down_view.dart';
import '../../popup_widget/drop_down_popup/rs_popup.dart';
import '../../popup_widget/general_drop_down_view/general_drop_down_view.dart';
import '../../rs_app_bar.dart';
import 'stores_pk_logic.dart';

/// PK页
class StoresPKPage extends StatefulWidget {
  const StoresPKPage({super.key});

  @override
  State<StoresPKPage> createState() => _StoresPKPageState();
}

class _StoresPKPageState extends State<StoresPKPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  StoresPKLogic get logic => Get.find<StoresPKLogic>(tag: tag);

  StoresPKState get state => Get.find<StoresPKLogic>(tag: tag).state;

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<StoresPKLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => StoresPKLogic(), tag: tag);

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.pageType.value == PKPageType.storePKPage) {
          // 设置tab
          List<String> tmpTabs = [];
          state.resultStorePKEntity.value.cardMetadata?.cardGroup?.forEach((element) {
            if (element.groupCode != null && element.groupName != null) {
              tmpTabs.add(element.groupName!);
            }
          });
          state.tabs.value = tmpTabs;
        } else {
          logic.firstFindMetricsAndDims();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String title = 'PK';
    if (state.pageType.value == PKPageType.storePKPage) {
      title = RSLocale().locale?.languageCode == 'zh' ? '${S.current.rs_store}PK' : '${S.current.rs_store} PK';
    } else {
      if (state.pageType.value == PKPageType.lossMetricsPage) {
        title = state.resultStorePKEntity.value.cardName ?? '*';
      } else {
        title = 'PK';
      }
    }
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Obx(() {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: RSColor.color_0xFFF3F3F3,
          appBar: RSAppBar(
            title: title,
            actions: [Container()],
          ),
          onEndDrawerChanged: (isOpened) {
            debugPrint("onEndDrawerChanged:$isOpened");
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  logic.setMinAndMaxNumbers(limitNumbers, [filterTypeString]);
                  state.filterComponentEntity.value.filters = filters;

                  logic.checkIsHaveFilterConditions();

                  if (state.selectedFilters.isNotEmpty) {
                    // 查询PK数据
                    logic.loadShopPKTableQuery(showLoading: true);
                  }
                });
              },
            ),
          ),
          body: _createBody(),
        );
      }),
    );
  }

  Widget _createBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: RSColor.color_0xFFFFFFFF,
          child: CustomDateToolWidgetPage(
            key: const ObjectKey(StoresPKPage),
            displayTime:
                state.currentCustomDateTime.isEmpty ? RSAccountManager().timeRange : state.currentCustomDateTime,
            customDateToolEnum: state.customDateToolEnum,
            compareDateRangeTypes: state.compareDateRangeTypes,
            dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                List<List<DateTime>>? compareDateTimeRanges,
                List<DateTime> displayTime,
                CustomDateToolEnum customDateToolEnum) async {
              state.currentCustomDateTime = displayTime;

              if (compareDateRangeTypes != null) {
                state.compareDateRangeTypes = compareDateRangeTypes;
              } else {
                state.compareDateRangeTypes.clear();
              }
              if (compareDateTimeRanges != null) {
                state.compareDateTimeRanges = compareDateTimeRanges;
              } else {
                state.compareDateTimeRanges.clear();
              }
              state.customDateToolEnum = customDateToolEnum;

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await logic.requestFilterComponent();
              });
            },
          ),
        ),
        _buildCustomTabWidget(),
        Expanded(
          child: CardLoadStateLayout(
            state: state.loadState.value,
            successWidget: Container(
              padding: const EdgeInsets.only(top: 8),
              color: RSColor.color_0xFFF3F3F3,
              child: StoresDataGridSubviewPage(
                compareTypesLength: state.compareDateRangeTypes.length,
                storePKTableEntity: state.resultStorePKTableEntity.value,
                refreshCallback: () {
                  logic.requestFilterComponent();
                },
                jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
                  if (drillDownInfo == null) {
                    return;
                  }

                  Map<String, dynamic> arguments = {
                    "displayTime": state.currentCustomDateTime,
                    "customDateToolEnum": state.customDateToolEnum,
                    "compareDateRangeTypes": state.compareDateRangeTypes,
                    "filterMetricCode": filterMetricCode,
                  };

                  if (state.currentCustomDateTime.isNotEmpty) {
                    arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.currentCustomDateTime);
                    arguments["customDateToolEnum"] = state.customDateToolEnum;
                  }

                  AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
                },
                compareTypes: state.compareDateRangeTypes,
              ),
            ),
            reloadCallback: () async {
              await logic.requestFilterComponent();
            },
            errorCode: state.errorCode,
            errorMessage: state.errorMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTabWidget() {
    return Container(
      key: globalKeyHeadWidget,
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        children: [
          if (state.pageType.value == PKPageType.storePKPage)
            Container(
              margin: const EdgeInsets.only(top: 2, bottom: 6),
              height: 32,
              width: 1.sw,
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      return InkWell(
                        onTap: () {
                          state.tabIndex.value = index;
                          logic.requestFilterComponent();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: ShapeDecoration(
                            color: state.tabIndex.value == index
                                ? RSColor.color_0xFF5C57E6.withOpacity(0.1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            state.tabs[index],
                            style: TextStyle(
                              color:
                                  state.tabIndex.value == index ? RSColor.color_0xFF5C57E6 : RSColor.color_0x60000000,
                              fontSize: 14,
                              fontWeight: state.tabIndex.value == index ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 4);
                  },
                  itemCount: state.tabs.length),
            ),
          if (state.pageType.value == PKPageType.pkPage || state.pageType.value == PKPageType.lossMetricsPage)
            _buildDimsSwitchWidget(),
          _buildTabSubviewWidget(),
          if (state.filterComponentEntity.value.filters != null) _buildFilterWidget(),
        ],
      ),
    );
  }

  Widget _buildDimsSwitchWidget() {
    return Container(
      width: 1.sw - 32,
      height: 32,
      padding: const EdgeInsets.only(right: 4),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: ExpandableTextButtonPage(
        textWidget: Expanded(
          child: Row(
            children: [
              Container(
                height: 32,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  color: RSColor.color_0xFFF3F3F3,
                  border: Border(
                    right: BorderSide(
                      color: RSColor.color_0xFFDCDCDC,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  S.current.rs_dim,
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                state.selectedDims.map((dim) => dim.dimName).toList().join(""),
                style: const TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        iconWidget: const Icon(
          Icons.keyboard_arrow_down,
        ),
        onPressed: () async {
          await Get.bottomSheet(
            PKDimsBottomSheetPage(
                entity: state.resultStorePKEntity.value,
                cardGroupCode: state.selectedGroupCode.value,
                selectedDim: state.selectedDims.first,
                callback:
                    (StorePKCardMetadataCardGroupMetadataDims selectedDim, String cardGroupCode, int tabIndex) async {
                  state.selectedDims.value = [selectedDim];
                  state.selectedGroupCode.value = cardGroupCode;
                  state.tabIndex.value = tabIndex;

                  logic.getMetricsIfDefaultTrueIndexList();
                  await logic.requestFilterComponent();
                }),
            isScrollControlled: true,
          );
        },
      ),
    );
  }

  Widget _buildTabSubviewWidget() {
    return Container(
        width: 1.sw - 32,
        height: 32,
        padding: const EdgeInsets.only(right: 4),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: ExpandableTextButtonPage(
          textWidget: Expanded(
            child: Row(
              children: [
                Container(
                  height: 32,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    color: RSColor.color_0xFFF3F3F3,
                    border: Border(
                      right: BorderSide(
                        color: RSColor.color_0xFFDCDCDC,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    S.current.rs_metrics,
                    style: const TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                _buildDragSortWidget(),
              ],
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

              var metrics = logic.getCurrentMetrics();

              var metricsTitleList = metrics?.map((metric) => metric.metricName ?? '').toList();

              var trueIndices = await logic.getMetricsIfDefaultTrueIndexList(isChangeMetricsValue: false);

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
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await logic.requestFilterComponent();
                        });
                      }),
                ),
                offsetLT: Offset(0, offset.dy + rect.height),
                cancelable: false,
                outsideTouchCancelable: false,
              );
            }
          },
        ));
  }

  // 构建拖拽排序组件
  Widget _buildDragSortWidget() {
    int widgetCount = state.selectedMetrics.length * 2 - 1;

    return Expanded(
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }

          final itemNewIndex = newIndex ~/ 2;
          final itemOldIndex = oldIndex ~/ 2;

          var item = state.selectedMetrics.removeAt(itemOldIndex);
          state.selectedMetrics.insert(itemNewIndex, item);

          logic.sortTableHead();
        },
        children: List.generate(
          widgetCount < 0 ? 0 : widgetCount,
          (index) {
            if (index.isOdd) {
              // 返回分隔符
              return SizedBox(
                key: ValueKey('Divider $index'),
                width: 4,
              );
            } else {
              final itemIndex = index ~/ 2;
              return Container(
                  key: ValueKey('${state.selectedMetrics[itemIndex].metricCode}$itemIndex'),
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: ShapeDecoration(
                    color: RSColor.color_0xFFF3F3F3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.selectedMetrics[itemIndex].metricName ?? '',
                        style: const TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            if (state.selectedMetrics.length > 1) {
                              await logic.changeMetricsIfDefaultTrueIndex(state.selectedMetrics[itemIndex].metricCode);
                              await logic.requestFilterComponent();
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
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterWidget() {
    Widget customFilterWidget;
    if (state.selectedFilters.isNotEmpty) {
      customFilterWidget = SizedBox(
        width: 1.sw,
        height: 25,
        child: Row(
          children: [
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(right: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => _createConditionFilterWidget(index),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 4,
                    );
                  },
                  itemCount: state.selectedFilters.length),
            ),
            Container(
              width: 1,
              height: 12,
              decoration: const BoxDecoration(color: RSColor.color_0xFFDCDCDC),
            ),
            InkWell(
              onTap: _openEndDrawer,
              child: Container(
                padding: const EdgeInsets.only(left: 12),
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
    } else {
      customFilterWidget = InkWell(
        onTap: _openEndDrawer,
        child: Text(
          '${S.current.rs_add}${S.current.rs_filter_criteria} +',
          style: TextStyle(
            color: RSColor.color_0xFF5C57E6,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      alignment: Alignment.centerLeft,
      child: customFilterWidget,
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
      padding: const EdgeInsets.only(left: 8, right: 4),
      constraints: const BoxConstraints(
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
              style: const TextStyle(
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
              logic.requestFilterComponent();
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  logic.checkIsHaveFilterConditions();

                  if (state.selectedFilters.isNotEmpty) {
                    // 查询PK数据
                    logic.loadShopPKTableQuery(showLoading: true);
                  }
                });
              },
              limitNumbersApplyCallback: (limitNumbers, filterTypeString) {
                logic.setMinAndMaxNumbers(limitNumbers, [filterTypeString]);
              },
            ),
          ),
          offsetLT: Offset(0, offset.dy + rect.height),
          cancelable: false,
          outsideTouchCancelable: false);
    }
  }

  // 打开侧边栏
  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
}
