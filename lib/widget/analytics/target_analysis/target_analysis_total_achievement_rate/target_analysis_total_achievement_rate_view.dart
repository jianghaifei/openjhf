import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/metric_card_general_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../progress_widget.dart';
import 'target_analysis_total_achievement_rate_logic.dart';

/// 总体达成率
class TargetAnalysisTotalAchievementRatePage extends StatefulWidget {
  const TargetAnalysisTotalAchievementRatePage({super.key, this.overall});

  final TargetManageOverviewOverall? overall;

  @override
  State<TargetAnalysisTotalAchievementRatePage> createState() => _TargetAnalysisTotalAchievementRatePageState();
}

class _TargetAnalysisTotalAchievementRatePageState extends State<TargetAnalysisTotalAchievementRatePage> {
  final logic = Get.put(TargetAnalysisTotalAchievementRateLogic());
  final state = Get.find<TargetAnalysisTotalAchievementRateLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetAnalysisTotalAchievementRateLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rate = 0.0;
    if (widget.overall?.achievementRate != null && widget.overall?.achievementRate?.value != null) {
      rate = double.parse(widget.overall?.achievementRate?.value ?? '0');
    }

    return MetricCardGeneralWidget(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.overall?.title ?? '*',
          style: const TextStyle(
            color: RSColor.color_0x90000000,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: CircleWaveProgressBar(
              size: const Size(140, 140),
              percentage: rate,
              centerText: widget.overall?.achievementRate?.displayValue ?? '0.00%',
              textStyle: const TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              heightController: CircleWaterController(),
              waveDistance: 35,
              flowSpeed: 0.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: buildBottomWidget(),
        ),
      ],
    ));
  }

  Widget buildBottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        var displayValue = '';
        var name = '';
        switch (index) {
          case 0:
            displayValue = widget.overall?.achieved?.displayValue ?? '*';
            name = widget.overall?.achieved?.name ?? '*';
            break;
          case 1:
            displayValue = widget.overall?.target?.displayValue ?? '*';
            name = widget.overall?.target?.name ?? '*';
            break;
          case 2:
            displayValue = widget.overall?.notAchieved?.displayValue ?? '*';
            name = widget.overall?.notAchieved?.name ?? '*';
            break;
        }

        return SizedBox(
          width: (1.sw - 16 * 5) / 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayValue,
                style: const TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  name,
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
