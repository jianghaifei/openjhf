import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_target_manage/target_manage_setting/target_manage_setting_state.dart';
import 'package:flutter_report_project/widget/bottom_sheet/general_radio_form_bottom_sheet/general_radio_form_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../../model/store/store_entity.dart';
import '../../../../../utils/date_util.dart';
import '../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../widget/bottom_sheet/date_picker_tool/date_picker_tool_view.dart';
import '../../../../../widget/bottom_sheet/picker_tool_bottom_sheet/picker_tool_bottom_sheet_view.dart';
import '../../../../../widget/custom_app_bar/rs_store/rs_store_view.dart';
import '../../../../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'target_manage_setting_logic.dart';

/// 目标设置
class TargetManageSettingPage extends StatefulWidget {
  const TargetManageSettingPage({super.key});

  @override
  State<TargetManageSettingPage> createState() => _TargetManageSettingPageState();
}

class _TargetManageSettingPageState extends State<TargetManageSettingPage> {
  final logic = Get.put(TargetManageSettingLogic());
  final state = Get.find<TargetManageSettingLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetManageSettingLogic>();

    // 释放控制器
    for (var controller in state.textEditingControllerList) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    state.titles.value = [
      [S.current.rs_month, S.current.rs_metric],
      [S.current.rs_distribution_method],
      [S.current.rs_application_store]
    ];

    if (state.pageType.value == TargetManageSettingPageType.preview) {
      logic.setEditPageData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取状态栏高度和应用栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final double footerHeight = (ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight) + 16 * 2 + 40;
    // debugPrint(
    //     "context.size.height:${MediaQuery.of(context).size.height} --- statusBarHeight:$statusBarHeight --- appBarHeight:$appBarHeight --- footerHeight:$footerHeight");

    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Obx(() {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: RSColor.color_0xFFF3F3F3,
              appBar: RSAppBar(
                title: S.current.rs_target_setting,
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height - statusBarHeight - appBarHeight - footerHeight,
                child: Column(
                  children: [
                    _createListViewWidget(),
                    _createTipWidget(),
                  ],
                ),
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: _createFooterWidget()),
          ],
        );
      }),
    );
  }

  Widget _createListViewWidget() {
    return Expanded(
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: state.titles[index]
                  .map((element) => _createItemWidget(element, state.titles[index].indexOf(element) - 1))
                  .toList(),
            );
          });
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
      ),
    );
  }

  Widget _createItemWidget(String title, int fromIndex) {
    String? subtitle;

    // int index = 0;

    if (title == S.current.rs_month) {
      if (state.pageType.value == TargetManageSettingPageType.preview) {
        subtitle = logic.setMonthSubTitle(state.infoEntity.value.month ?? "");
      } else {
        subtitle =
            RSDateUtil.dateRangeToString([state.startDate.value, state.endDate.value], dateFormat: DateFormats.y_mo);
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          hint: S.current.rs_please_select,
          showErrorLine: false,
          showArrow: state.pageType.value == TargetManageSettingPageType.edit, () {
        if (state.pageType.value == TargetManageSettingPageType.preview) {
          // 预览状态禁止编辑
          return;
        }

        var timeRangeString = RSDateUtil.dateRangeToListString([state.startDate.value, state.endDate.value]);

        Get.bottomSheet(
            DatePickerToolPage(
                enableMaxDate: false,
                homeDateToolType: CustomDateToolEnum.MONTH,
                selectedQuickDateIndex: null,
                rangeDateString: state.timeRange.isEmpty ? timeRangeString : state.timeRange,
                selectedTimeRangeCallBack: (timeRange, selectIndex) {
                  // 时间范围 [2023-12-17, 2023-12-17]
                  debugPrint("clickTimeAction - $timeRange --- ($selectIndex)");

                  state.timeRange.value = timeRange;
                  logic.updateTimeRange(timeRange);

                  // 清除应用门店
                  logic.clearSelectedShops();

                  // 获取应用门店
                  logic.getTargetsShops();

                  // 获取输入框的值
                  state.totalAmount.value = logic.getAllInputValues();
                }),
            isScrollControlled: true);
      });
    } else if (title == S.current.rs_metric) {
      if (state.selectedMetricsIndex.value != -1) {
        subtitle = state.editConfigEntity.value.metrics?[state.selectedMetricsIndex.value].name;
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          hint: S.current.rs_please_select,
          showErrorLine: state.metricsErrorTip.value,
          showArrow: state.pageType.value == TargetManageSettingPageType.edit, () async {
        if (state.pageType.value == TargetManageSettingPageType.preview) {
          // 预览状态禁止编辑
          return;
        }
        await Get.bottomSheet(
          GeneralRadioFormBottomSheetPage(
              title: S.current.rs_metric,
              listTitle: state.editConfigEntity.value.metrics?.map((e) => e.name ?? '*').toList() ?? [],
              defaultSelectedIndex: [state.selectedMetricsIndex.value],
              selectedIndexCallback: (List<int> selectedIndex) {
                debugPrint("selectedIndex:$selectedIndex");
                state.selectedMetricsIndex.value = selectedIndex.first;

                // 清除应用门店
                logic.clearSelectedShops();

                // 获取应用门店
                logic.getTargetsShops();

                if (state.metricsErrorTip.value) {
                  state.metricsErrorTip.value = false;
                }
              }),
          isScrollControlled: true,
          isDismissible: false,
        );
      });
    } else if (title == S.current.rs_distribution_method) {
      if (state.selectedDistributionIndex.value != -1) {
        subtitle = state.distributionTitles[state.selectedDistributionIndex.value];
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          hint: S.current.rs_please_select,
          showErrorLine: state.distributionErrorTip.value,
          showArrow: state.pageType.value == TargetManageSettingPageType.edit, () async {
        if (state.pageType.value == TargetManageSettingPageType.preview) {
          // 预览状态禁止编辑
          return;
        }
        await Get.bottomSheet(PickerToolBottomSheetPage(
            centerTitle: S.current.rs_distribution_method,
            defaultIndex: state.selectedDistributionIndex.value,
            listTitle: state.distributionTitles,
            selectedItemIndexCallback: (int index) {
              state.selectedDistributionIndex.value = index;
              state.totalAmount.value = BigInt.zero;
              logic.setDistributionTitles();

              if (state.distributionErrorTip.value) {
                state.distributionErrorTip.value = false;
              }
            }));
      });
    } else if (title == S.current.rs_application_store) {
      if (state.selectedShops.isNotEmpty) {
        subtitle = '${state.selectedShops.length}';
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          hint: S.current.rs_please_select,
          showErrorLine: state.selectedShopsErrorTip.value,
          showArrow: state.pageType.value == TargetManageSettingPageType.edit, () {
        if (state.pageType.value == TargetManageSettingPageType.preview) {
          // 预览状态禁止编辑
          return;
        }

        // 月份、指标不为空时才允许选择门店
        if (state.selectedMetricsIndex.value != -1) {
          Get.to(() => RSStorePage(
                selectedShops: state.selectedShops,
                storeEntity: state.storeEntity.value,
                selectedCurrencyValue: state.selectedCurrencyValue.value,
                applyCallback: (
                  List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
                  List<String> allSelectedBrandIds,
                  String currencyValue,
                  StoreSelectedGroupType groupType,
                ) {
                  // 重置所有门店的选中状态
                  // RSAccountManager().allSelectedShopsFalse(state.storeEntity.value);

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
                      if (shop.isEditable) {
                        shop.isSelected = shopIdsB.contains(shop.shopId);
                      }
                    });
                  });

                  // 选中的门店
                  state.selectedShops.value = allSelectedShops;
                  // 选中的货币value
                  state.selectedCurrencyValue.value = currencyValue;

                  if (state.selectedShopsErrorTip.value) {
                    state.selectedShopsErrorTip.value = false;
                  }
                },
              ));
        } else {
          EasyLoading.showToast("${S.current.rs_please_select}${S.current.rs_metric}");
        }
      });
    } else {
      String? currencySymbol;

      if (state.selectedMetricsIndex.value != -1) {
        currencySymbol = state.editConfigEntity.value.metrics?[state.selectedMetricsIndex.value].dataType ==
                MetricOrDimDataType.CURRENCY
            ? (state.selectedShops.isNotEmpty
                ? logic.getCurrencySymbolByValue(state.selectedCurrencyValue.value)
                : null)
            : null;
      }

      var formWidget = RSFormCommonTypeWidget.buildInputCurrencyFormWidget(
          title, state.textEditingControllerList[fromIndex], currencySymbol,
          enabled: state.pageType.value != TargetManageSettingPageType.preview, onChanged: (String value) {
        state.totalAmount.value = logic.getAllInputValues();
      });
      fromIndex++;
      return formWidget;
    }
  }

  /// 提示视图
  Widget _createTipWidget() {
    String? currencySymbol;

    if (state.selectedMetricsIndex.value != -1) {
      currencySymbol = state.editConfigEntity.value.metrics?[state.selectedMetricsIndex.value].dataType ==
              MetricOrDimDataType.CURRENCY
          ? (state.selectedShops.isNotEmpty ? logic.getCurrencySymbolByValue(state.selectedCurrencyValue.value) : null)
          : null;
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: const Color(0x14D54941),
      child: Row(
        children: [
          Text(
            S.current.rs_target_value,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            "${logic.bigIntToStringWithThousandsSeparator(state.totalAmount.value)}${currencySymbol ?? ''}",
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 尾部视图
  Widget _createFooterWidget() {
    return Container(
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          if (state.pageType.value == TargetManageSettingPageType.preview)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 16,
                ),
                RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
                  S.current.rs_delete,
                  RSColor.color_0xFF5C57E6,
                  RSColor.color_0xFF5C57E6.withOpacity(0.1),
                  () async {
                    // 删除时，需要赋值targetId
                    state.targetId = state.infoEntity.value.targetId ?? '';
                    await logic.deleteTarget();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
                  S.current.rs_edit,
                  RSColor.color_0xFFFFFFFF,
                  RSColor.color_0xFF5C57E6,
                  () async {
                    state.pageType.value = TargetManageSettingPageType.edit;
                    // 编辑时，需要赋值targetId
                    state.targetId = state.infoEntity.value.targetId ?? '';
                    await logic.getTargetsShops();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          if (state.pageType.value == TargetManageSettingPageType.edit)
            RSBottomButtonWidget.buildFixedWidthBottomButton(
              S.current.rs_save,
              (title) {
                if (logic.validate()) {
                  logic.addOrUpdateTarget();
                }
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
          )
        ],
      ),
    );
  }
}
