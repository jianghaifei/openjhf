import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/generated/assets.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:flutter_report_project/widget/bottom_sheet/reorderable_list_view/analytics_entity_list_setting_bottom_sheet/analytics_entity_list_setting_bottom_sheet.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../utils/date_util.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../../widget/popup_widget/drop_down_popup/rs_entity_list_filter_drop_down_view.dart';
import '../../../widget/popup_widget/drop_down_popup/rs_entity_list_sort_drop_down_view.dart';
import '../../../widget/popup_widget/drop_down_popup/rs_popup.dart';
import '../../../widget/rs_custom_text_field.dart';
import '../../login/account_manager/account_manager.dart';
import 'analytics_comment_details/analytics_comment_details_view.dart';
import 'analytics_entity_list_drawer/analytics_entity_list_drawer_view.dart';
import 'analytics_entity_list_item/analytics_entity_list_item_view.dart';
import 'analytics_entity_list_logic.dart';
import 'analytics_entity_list_state.dart';

class AnalyticsEntityListPage extends StatefulWidget {
  const AnalyticsEntityListPage({super.key});

  @override
  State<AnalyticsEntityListPage> createState() => _AnalyticsEntityListPageState();
}

class _AnalyticsEntityListPageState extends State<AnalyticsEntityListPage> {
  final String tag = '${DateTime.now().millisecondsSinceEpoch}';

  AnalyticsEntityListLogic get logic => Get.find<AnalyticsEntityListLogic>(tag: tag);

  AnalyticsEntityListState get state => Get.find<AnalyticsEntityListLogic>(tag: tag).state;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  bool isKeyboardOpen = false;

  @override
  void dispose() {
    Get.delete<AnalyticsEntityListLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 查询指标筛选组件数据
      logic.requestFilterComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AnalyticsEntityListLogic(), tag: tag);

    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Obx(() {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: RSAppBar(
            title: state.entityTitle.value,
            actions: state.entity != state.EVALUATION
                ? [
                    IconButton(
                        onPressed: () {
                          logic.loadEntitySettingOptions((entity) {
                            Get.bottomSheet(
                              AnalyticsEntityListSettingBottomSheet(
                                  entity: entity,
                                  applyCallback: (settingOptionsEntity) async {
                                    await logic.editOrderDetailBaseOptions(settingOptionsEntity);
                                    logic.requestFilterComponent();
                                  }),
                              isScrollControlled: true,
                            );
                          });
                        },
                        icon: Image.asset(
                          Assets.imageOrderDetailSetting,
                          width: 24,
                          height: 24,
                        ))
                  ]
                : [Container()],
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
                logic.setMinAndMaxNumbers(limitNumbers, [filterTypeString]);
                state.filterComponentEntity.value.filters = filters;

                logic.checkIsHaveFilterConditions();

                logic.refreshData(showLoading: true);
              },
            ),
          ),
          body: Column(
            children: [
              _createHeadWidget(),
              if (logic.getListIsEmpty()) _notDataView(),
              if (!logic.getListIsEmpty()) _buildCommentDetailsWidget(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommentDetailsWidget() {
    return Expanded(
      child: Container(
        width: 1.sw,
        color: RSColor.color_0xFFF3F3F3,
        child: EasyRefresh(
          controller: state.refreshController,
          header: const CupertinoHeader(),
          footer: CupertinoFooter(emptyWidget: _createFooterEmptyWidget()),
          onRefresh: logic.refreshData,
          onLoad: logic.loadMoreData,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 12, bottom: ScreenUtil().bottomBarHeight),
            itemCount: state.entity == state.EVALUATION
                ? (state.evaluateListEntity.value.list?.length ?? 0)
                : (state.listEntity.value.list?.length ?? 0),
            itemBuilder: (context, index) {
              if (state.entity == state.EVALUATION) {
                // 评论页
                return AnalyticsCommentDetailsPage(
                  itemIndex: index,
                  entity: state.evaluateListEntity.value.list?[index],
                );
              } else {
                // 普通列表页
                return AnalyticsEntityListItemPage(
                  entity: state.listEntity.value.list![index],
                  clickCallBack: () {
                    logic.jumpOrderDetailOrListPage(state.listEntity.value.list?[index]);
                  },
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _createFooterEmptyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 68),
        Expanded(
          child: Container(
            height: 0.5,
            color: RSColor.color_0x26000000,
          ),
        ),
        SizedBox(width: 16),
        Image.asset(
          Assets.imageLogoSmallGrey,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            'RS Insight',
            style: TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 0.5,
            color: RSColor.color_0x26000000,
          ),
        ),
        SizedBox(width: 68),
      ],
    );
  }

  Widget _createHeadWidget() {
    return Container(
      key: globalKeyHeadWidget,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 4, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ExpandableTextButtonPage(
                //   textWidget: Text(
                //     state.timeRange.isNotEmpty ? RSDateUtil.formatTimesString(state.timeRange) : "",
                //     style: TextStyle(
                //       color: RSColor.color_0x90000000,
                //       fontSize: 14.sp,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                //   iconWidget: Image(
                //     image: const AssetImage(Assets.imageArrowDropDown),
                //     width: 9,
                //     fit: BoxFit.fitWidth,
                //   ),
                //   onPressed: () async {
                //     await Get.bottomSheet(
                //         DatePickerToolPage(
                //             selectedQuickDateIndex: state.selectedQuickDateIndex,
                //             rangeDateString: state.timeRange,
                //             selectedTimeRangeCallBack: (timeRange, selectIndex) {
                //               logger.d("clickDateAction - $timeRange($selectIndex)", StackTrace.current);
                //
                //               debugPrint("选择时间范围：$timeRange");
                //               // 时间范围 [2023-12-17, 2023-12-17]
                //               state.timeRange.value = timeRange;
                //               state.selectedQuickDateIndex = selectIndex;
                //               logic.refreshData();
                //             }),
                //         isScrollControlled: true);
                //   },
                // ),
                CustomDateToolWidgetPage(
                  isShowCompareWidget: false,
                  displayTime:
                      state.currentCustomDateTime.isEmpty ? RSAccountManager().timeRange : state.currentCustomDateTime,
                  customDateToolEnum: state.customDateToolEnum,
                  compareDateRangeTypes: const [],
                  dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                      List<List<DateTime>>? compareDateTimeRanges,
                      List<DateTime> displayTime,
                      CustomDateToolEnum customDateToolEnum) {
                    if (state.currentCustomDateTime.isNotEmpty &&
                        (state.currentCustomDateTime.first != displayTime.first ||
                            state.currentCustomDateTime.last != displayTime.last)) {
                      state.currentCustomDateTime = displayTime;

                      state.timeRange.value = RSDateUtil.dateRangeToListString(displayTime);

                      logic.refreshData(showLoading: true);
                    } else {
                      state.currentCustomDateTime = displayTime;
                      state.timeRange.value = RSDateUtil.dateRangeToListString(displayTime);
                    }

                    state.customDateToolEnum = customDateToolEnum;

                    // logic.refreshData();
                  },
                ),
                _createSearchWidget(),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      _createSortConditionWidget(),
                      InkWell(
                        onTap: () {
                          state.isAscSort.value = !state.isAscSort.value;
                          // 重置数据
                          logic.refreshData(showLoading: true);
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Image.asset(
                            state.isAscSort.value
                                ? Assets.imageAnalyticsEntityListSort
                                : Assets.imageAnalyticsEntityListSortReverse,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _createFilterWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                    itemCount: state.selectedFilters.length), //state.filterConditions.length
              ),
            ),
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  bool areListsEqualUsingSet(List a, List b) {
    return Set.from(a).difference(Set.from(b)).isEmpty && Set.from(b).difference(Set.from(a)).isEmpty;
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

                logic.refreshData(showLoading: true);
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
              state.filters = null;
              state.selectedFilters.removeAt(index);
              logic.refreshData(showLoading: true);
            } else {
              await clickConditionAction(index);
            }
          }),
    );
  }

  Widget _createSearchWidget() {
    return Offstage(
      offstage: state.searchFilterEntity.value.componentType != EntityComponentType.INPUT,
      child: Padding(
        padding: EdgeInsets.only(top: 12),
        child: RSCustomTextField(
          textFieldController: state.searchTextFieldController.value,
          hintText: state.searchFilterEntity.value.displayName ?? '',
          onSubmitted: (valueString) {
            logic.refreshData();
          },
        ),
      ),
    );
  }

  Widget _createSortConditionWidget() {
    return Container(
      width: 150,
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: ExpandableTextButtonPage(
          textWidget: Expanded(
            child: AutoSizeText(
              "${state.selectedOrderByIndex >= 0 ? (state.filterComponentEntity.value.orderBy?[state.selectedOrderByIndex.value].displayName) : S.current.rs_select}",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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

              await RSPopup.show(
                  Get.context!,
                  RSCustomDropDownPage(
                    paddingTop: offset.dy + rect.height,
                    customWidget: RSEntityListSortDropDownView(
                      orderByList: state.filterComponentEntity.value.orderBy ?? [],
                      defaultIndex: state.selectedOrderByIndex.value,
                      applyCallback: (int selectedIndex) {
                        state.selectedOrderByIndex.value = selectedIndex;
                        logic.refreshData();
                      },
                    ),
                  ),
                  offsetLT: Offset(0, offset.dy + rect.height),
                  cancelable: false);
            }
          }),
    );
  }

  Widget _createFilterWidget() {
    return Row(
      children: [
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
    );
  }

  Widget _notDataView() {
    return Expanded(
      child: Container(
        width: 1.sw,
        height: double.infinity,
        color: RSColor.color_0xFFF3F3F3,
        alignment: Alignment.center,
        child: Text(
          S.current.rs_no_data,
          style: TextStyle(
            color: RSColor.color_0x40000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
