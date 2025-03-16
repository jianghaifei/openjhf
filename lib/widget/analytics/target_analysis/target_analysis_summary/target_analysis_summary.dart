import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/metric_card_general_widget.dart';

import '../../../../model/target_manage/target_manage_overview_entity.dart';

/// 总结卡片
class TargetAnalysisSummaryPage extends StatelessWidget {
  const TargetAnalysisSummaryPage({super.key, this.summary, required this.onTap});

  final TargetManageOverviewSummary? summary;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MetricCardGeneralWidget(
        margin: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary?.title ?? '*',
              style: const TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () {
                  if (summary?.drillDown ?? false) {
                    onTap.call();
                  }
                },
                child: Text.rich(TextSpan(children: [
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                        summary?.msg ?? '*',
                        style: const TextStyle(
                          color: RSColor.color_0x60000000,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  if (summary?.drillDown ?? false)
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: RSColor.color_0x60000000,
                          size: 20,
                        )),
                ])),
              ),
            ),
          ],
        ));
  }
}
