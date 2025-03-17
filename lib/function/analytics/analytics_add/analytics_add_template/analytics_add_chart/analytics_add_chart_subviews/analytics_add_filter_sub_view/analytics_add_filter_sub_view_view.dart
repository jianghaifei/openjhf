import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'package:get/get.dart';

import '../../../../../../../config/rs_color.dart';
import '../../../../../../../generated/l10n.dart';
import '../../../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../../../widget/bottom_sheet/general_select_form_bottom_sheet/general_select_form_bottom_sheet_view.dart';
import 'analytics_add_filter_sub_view_logic.dart';
import 'analytics_add_filter_sub_view_state.dart';

/// 添加删选条件页面
class AnalyticsAddFilterSubViewPage extends StatefulWidget {
  const AnalyticsAddFilterSubViewPage({super.key});

  @override
  State<AnalyticsAddFilterSubViewPage> createState() => _AnalyticsAddFilterSubViewPageState();
}

class _AnalyticsAddFilterSubViewPageState extends State<AnalyticsAddFilterSubViewPage> {
  final AnalyticsAddFilterSubViewLogic logic = Get.put(AnalyticsAddFilterSubViewLogic());
  final AnalyticsAddFilterSubViewState state = Get.find<AnalyticsAddFilterSubViewLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddFilterSubViewLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_filter_criteria,
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: Obx(() {
        return _createBody();
      }),
    );
  }

  Widget _createBody() {
    return Column(children: [
      Expanded(child: _createListView()),
      _createFooterWidget(),
    ]);
  }

  Widget _createListView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.filterOptions.length,
        itemBuilder: (context, index) {
          return Obx(() {
            return _createItemWidget(index);
          });
        });
  }

  Widget _createItemWidget(int index) {
    bool ifSelected = state.selectedFilterIndex.value == index;

    return RSFormCommonTypeWidget.buildSecondaryOperationFormWidget(
        state.filterOptions[index].displayName ?? '-',
        ifSelected,
        ifSelected && state.selectedFilterBindOptionIndex.isNotEmpty
            ? '${state.selectedFilterBindOptionIndex.length}'
            : null, (check) {
      if (state.selectedFilterIndex.value != index) {
        state.selectedFilterBindOptionIndex.clear();
        state.selectedFilterIndex.value = index;
      } else {
        state.selectedFilterBindOptionIndex.clear();
        state.selectedFilterIndex.value = -1;
      }
    }, () async {
      var filters = await logic.getSelectedMetricFilterByDims();
      if (filters == null) {
        return;
      }

      Get.bottomSheet(
        GeneralSelectFormBottomSheetPage(
            title: S.current.rs_filter_criteria,
            formTitle: filters.options?.map((e) => e.displayName ?? '').toList() ?? [],
            selectFormType: SelectFormType.multiple,
            displaySelectedCount: true,
            defaultSelectedIndex: state.selectedFilterBindOptionIndex,
            selectedIndexCallback: (list) {
              state.selectedFilterBindOptionIndex.value = list;
            }),
        isScrollControlled: true,
        isDismissible: false,
      );
    });
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 + 16 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) async {
            // 组装绑定数据
            var filters = await logic.getSelectedMetricFilterByDims();
            if (filters != null) {
              if (state.selectedFilterBindOptionIndex.isNotEmpty) {
                List<String> result = [];
                for (var index in state.selectedFilterBindOptionIndex) {
                  result.addAll(filters.options?[index].value ?? []);
                }

                state.filterOptions[state.selectedFilterIndex.value].bindOptionsValue = result;

                Get.back(result: result);
              } else {
                EasyLoading.showToast("${S.current.rs_please_select}${S.current.rs_filter_criteria}");
              }
            } else {
              Get.back(result: true);
            }
          }),
        ),
      ],
    );
  }
}
