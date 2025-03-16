import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../model/target_manage/target_manage_edit_config_entity.dart';
import '../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import '../../../../../widget/rs_form_widget/rs_form_common_type_widget.dart';

typedef TargetManageMetricsFilterCallback = void Function(List<int> selectedFilterList);

class MineSettingTargetManageMetricsFilterPage extends StatefulWidget {
  const MineSettingTargetManageMetricsFilterPage(
      {super.key, this.configEntity, this.targetAnalysisDataGridFilterCallBack});

  final TargetManageEditConfigEntity? configEntity;

  final TargetManageMetricsFilterCallback? targetAnalysisDataGridFilterCallBack;

  @override
  State<MineSettingTargetManageMetricsFilterPage> createState() => _MineSettingTargetManageMetricsFilterPageState();
}

class _MineSettingTargetManageMetricsFilterPageState extends State<MineSettingTargetManageMetricsFilterPage> {
  /// 全选
  var ifAllSelected = false;

  /// 选中的筛选条件
  var selectedFilterList = <int>[];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化默认选中的选项
    widget.configEntity?.metrics?.forEach((element) {
      if (element.isSelected) {
        selectedFilterList.add(widget.configEntity?.metrics?.indexOf(element) ?? 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_metric, maxHeight: 0.7, children: [
      _createFilterOptionsWidget(),
      _createFooterWidget(),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createFilterOptionsWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createFilterOptionSubviewWeight(-1),
            ...List.generate(
              widget.configEntity?.metrics?.length ?? 0,
              (index) => _createFilterOptionSubviewWeight(index),
            ),
          ],
        ),
      ),
    );
  }

  // 创建筛选选项子视图
  Widget _createFilterOptionSubviewWeight(int index) {
    TargetManageEditConfigMetrics? metric;
    String title = '*';

    bool selectValue = false;
    if (index == -1) {
      if (selectedFilterList.length == widget.configEntity?.metrics?.length) {
        ifAllSelected = true;
      } else {
        ifAllSelected = false;
      }

      selectValue = ifAllSelected;
      title = S.current.rs_all;
    } else {
      metric = widget.configEntity?.metrics?[index];
      selectValue = metric?.isSelected ?? false;
      title = metric?.name ?? '*';
    }

    return RSFormCommonTypeWidget.buildMultipleCheckAndSubtitle(title, null, selectValue, (check) {
      setState(() {
        if (index == -1) {
          ifAllSelected = check;
          if (check) {
            selectedFilterList.clear();
            selectedFilterList.addAll(List.generate(widget.configEntity?.metrics?.length ?? 0, (index) => index));
            widget.configEntity?.metrics?.forEach((element) {
              element.isSelected = true;
            });
          } else {
            selectedFilterList.clear();
            widget.configEntity?.metrics?.forEach((element) {
              element.isSelected = false;
            });
          }
        } else {
          metric?.isSelected = check;
          if (selectedFilterList.contains(index)) {
            selectedFilterList.remove(index);
          } else {
            selectedFilterList.add(index);
          }
        }
      });
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
        const SizedBox(height: 20),
        RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
          if (selectedFilterList.isNotEmpty) {
            widget.targetAnalysisDataGridFilterCallBack?.call(selectedFilterList);
            Get.back();
          }
        }, editable: selectedFilterList.isNotEmpty),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
