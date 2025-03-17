import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_target_manage/mine_setting_target_manage_metrics_filter/mine_setting_target_manage_metrics_filter_view.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_target_manage/target_manage_setting/target_manage_setting_state.dart';
import 'package:flutter_report_project/router/app_routes.dart';
import 'package:flutter_report_project/widget/card_load_state_layout.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/analytics/target_analysis/target_manage_card/target_manage_card_view.dart';
import '../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../../../widget/expandable_text_button/expandable_text_button_view.dart';
import '../../../login/account_manager/account_manager.dart';
import 'mine_setting_target_manage_logic.dart';

/// 目标管理
class MineSettingTargetManagePage extends StatefulWidget {
  const MineSettingTargetManagePage({super.key});

  @override
  State<MineSettingTargetManagePage> createState() => _MineSettingTargetManagePageState();
}

class _MineSettingTargetManagePageState extends State<MineSettingTargetManagePage> {
  final logic = Get.put(MineSettingTargetManageLogic());
  final state = Get.find<MineSettingTargetManageLogic>().state;

  @override
  void dispose() {
    Get.delete<MineSettingTargetManageLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_management_by_objectives,
      ),
      body: Obx(() {
        return Column(
          children: [
            _createHeaderWidget(),
            Expanded(
              child: CardLoadStateLayout(
                state: state.loadState.value,
                successWidget: Column(
                  children: [
                    _createBodyWidget(),
                    _createFooterWidget(),
                  ],
                ),
                reloadCallback: () {
                  logic.getTargetsOptionalMetrics();
                },
                errorCode: state.errorCode,
                errorMessage: state.errorMessage,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _createHeaderWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      color: RSColor.color_0xFFFFFFFF,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomDateToolWidgetPage(
              key: const ObjectKey(MineSettingTargetManagePage),
              enableMaxDate: false,
              isShowCompareWidget: false,
              isShowSwitchTimeEnumWidget: false,
              customDateToolEnum: CustomDateToolEnum.MONTH,
              displayTime: RSAccountManager().timeRange,
              dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                  List<List<DateTime>>? compareDateTimeRanges,
                  List<DateTime> displayTime,
                  CustomDateToolEnum customDateToolEnum) async {
                // 将displayTime.first 时间字符串转成yyyyMM格式字符串
                state.month = DateUtil.formatDate(displayTime.first, format: 'yyyyMM');
                state.timeRange = displayTime;

                if (state.isFirstLoad.value) {
                  state.isFirstLoad.value = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await logic.getTargetsOptionalMetrics();
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await logic.getTargetManageListTargets();
                  });
                }
              },
            ),
          ),
          if (state.targetManageEditConfigEntity.value.metrics?.isNotEmpty ?? false)
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                child: ExpandableTextButtonPage(
                    textWidget: Flexible(
                      child: Text(
                        logic.getMetricsTitle(),
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
                        MineSettingTargetManageMetricsFilterPage(
                            configEntity: state.targetManageEditConfigEntity.value,
                            targetAnalysisDataGridFilterCallBack: (List<int> selectedFilterList) {
                              var filter = logic.getTargetManageListTargetsMetricsCode(selectedFilterList);

                              logic.getTargetManageListTargets(filterMetricCodes: filter);
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
    if ((state.targetManageListTargetsEntity.value.infos?.length ?? 0) == 0) {
      return Expanded(
        child: Container(
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
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemBuilder: (BuildContext context, int index) {
              var entity = state.targetManageListTargetsEntity.value.infos?[index];
              var editConfigEntity = state.targetManageEditConfigEntity.value;
              return TargetManageCardPage(
                entity: entity,
                editConfigEntity: editConfigEntity,
                onTap: () {
                  Get.toNamed(AppRoutes.targetManageSettingPage, arguments: {
                    "infoEntity": entity,
                    'editConfigEntity': editConfigEntity,
                    "pageType": TargetManageSettingPageType.preview,
                    'timeRange': state.timeRange,
                  })?.then((result) {
                    if (result != null && result) {
                      logic.getTargetsOptionalMetrics();
                    }
                  });
                },
              );
            },
            itemCount: state.targetManageListTargetsEntity.value.infos?.length ?? 0),
      );
    }
  }

  Widget _createFooterWidget() {
    return Container(
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        children: [
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          RSBottomButtonWidget.buildFixedWidthBottomButton(
            S.current.rs_add,
            (title) {
              Get.toNamed(AppRoutes.targetManageSettingPage, arguments: {
                'editConfigEntity': state.targetManageEditConfigEntity.value,
                'pageType': TargetManageSettingPageType.edit,
                'timeRange': state.timeRange,
              })?.then((result) {
                if (result != null && result) {
                  logic.getTargetsOptionalMetrics();
                }
              });
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
