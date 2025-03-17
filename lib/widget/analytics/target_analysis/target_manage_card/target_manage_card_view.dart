import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_button_widget/rs_bottom_button_widget.dart';
import 'package:flutter_report_project/widget/metric_card_general_widget.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/target_manage/target_manage_edit_config_entity.dart';
import '../../../../model/target_manage/target_manage_list_targets_entity.dart';
import '../../../../router/app_routes.dart';
import '../../../progress_widget.dart';
import 'target_manage_card_logic.dart';

/// 目标管理卡片
class TargetManageCardPage extends StatefulWidget {
  const TargetManageCardPage({super.key, this.entity, this.editConfigEntity, this.onTap});

  final TargetManageListTargetsInfos? entity;

  final TargetManageEditConfigEntity? editConfigEntity;

  final VoidCallback? onTap;

  @override
  State<TargetManageCardPage> createState() => _TargetManageCardPageState();
}

class _TargetManageCardPageState extends State<TargetManageCardPage> {
  final logic = Get.put(TargetManageCardLogic());
  final state = Get.find<TargetManageCardLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetManageCardLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetricCardGeneralWidget(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _createHeaderWidget(),
            // _createFooterWidget(),
          ],
        ));
  }

  Widget _createHeaderWidget() {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
              child: _createHeaderLeftWidget(),
            ),
          ),
          Expanded(
            child: _createHeaderRightWidget(),
          ),
        ],
      ),
    );
  }

  Widget _createHeaderLeftWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.entity?.metricName ?? '*',
          style: const TextStyle(
            color: RSColor.color_0x60000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.entity?.displayTarget ?? '*',
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.entity?.distributionName ?? '*',
            style: const TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.entity?.displayShopCount ?? '*',
            style: const TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createHeaderRightWidget() {
    double rate = 0.0;
    if (widget.entity?.achievementRate != null) {
      rate = double.parse(widget.entity?.achievementRate ?? '0');
    }

    return Center(
      child: CircleWaveProgressBar(
        size: const Size(90, 90),
        percentage: rate,
        centerText: widget.entity?.displayAchievementRate ?? '0.00%',
        textStyle: const TextStyle(
          color: RSColor.color_0x90000000,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        heightController: CircleWaterController(),
        waveDistance: 35,
        flowSpeed: 0.1,
      ),
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
              "${S.current.rs_check}${S.current.rs_progress}",
              RSColor.color_0xFF5C57E6,
              Colors.transparent,
              textStyle: const TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              () {
                Get.toNamed(AppRoutes.targetAnalysisPage);
              },
            ),
            Container(
              width: 1,
              height: 12,
              color: RSColor.color_0xFFE7E7E7,
            ),
            RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
              "${S.current.rs_check}${S.current.rs_configuration}",
              RSColor.color_0xFF5C57E6,
              Colors.transparent,
              textStyle: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              () {},
            ),
          ],
        ),
      ],
    );
  }
}
