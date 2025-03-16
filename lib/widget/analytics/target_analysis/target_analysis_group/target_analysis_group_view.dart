import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../config/rs_color.dart';
import '../../../../model/chart_data/rs_chart_data.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../metric_card_general_widget.dart';
import 'target_analysis_group_logic.dart';

/// 门店达成率
class TargetAnalysisGroupPage extends StatefulWidget {
  const TargetAnalysisGroupPage({super.key, this.shopAchievement});

  final TargetManageOverviewShopAchievement? shopAchievement;

  @override
  State<TargetAnalysisGroupPage> createState() => _TargetAnalysisGroupPageState();
}

class _TargetAnalysisGroupPageState extends State<TargetAnalysisGroupPage> {
  final logic = Get.put(TargetAnalysisGroupLogic());
  final state = Get.find<TargetAnalysisGroupLogic>().state;

  @override
  void dispose() {
    Get.delete<TargetAnalysisGroupLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.setChartData(widget.shopAchievement);
  }

  @override
  Widget build(BuildContext context) {
    return MetricCardGeneralWidget(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.shopAchievement?.title ?? '*',
          style: const TextStyle(
            color: RSColor.color_0x90000000,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildPieChartWidget(),
        _createWrapWidget(),
      ],
    ));
  }

  Widget _buildPieChartWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 140,
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.shopAchievement?.metrics?.first.displayValue ?? '0',
                      style: const TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.shopAchievement?.metrics?.first.name ?? '0',
                      style: TextStyle(
                        color: RSColor.color_0x40000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              )
            ],
            series: [
              DoughnutSeries<RSChartData, String>(
                onRendererCreated: (CircularSeriesController controller) {
                  state.chartSeriesController = controller;
                },
                dataSource: state.allChartData,
                radius: '100%',
                innerRadius: '80%',
                animationDuration: 800,
                strokeColor: Colors.white,
                strokeWidth: 1,
                pointColorMapper: (RSChartData data, _) => data.color,
                xValueMapper: (RSChartData data, _) => data.x,
                yValueMapper: (RSChartData data, _) => data.y,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createWrapWidget() {
    List<Widget> widgets = [];
    // List.generate(4, (index) {
    //   widgets.add(_createWrapItemWidget('门店名称', 40 + index, '¥123123', '123123', '万', RSColor.chartColors[index]));
    // });

    if (widget.shopAchievement != null &&
        widget.shopAchievement?.reportData != null &&
        widget.shopAchievement?.reportData?.rows != null &&
        widget.shopAchievement!.reportData!.rows!.length <= RSColor.chartColors.length) {
      for (int i = 0; i < widget.shopAchievement!.reportData!.rows!.length; i++) {
        var rows = widget.shopAchievement!.reportData!.rows?[i];

        // 维度
        String title = rows?.dims?.first.displayValue ?? '*';
        // 同环比
        num percent = rows?.metrics?.first.proportion ?? 0.0;
        // 展示金额
        String displayValue = rows?.metrics?.first.displayValue ?? '*';

        widgets.add(
          _createWrapItemWidget(title, percent, displayValue, RSColor.chartColors[i]),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.only(top: 16),
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 16,
        runSpacing: 16,
        children: widgets,
      ),
    );
  }

  Widget _createWrapItemWidget(String title, num percent, String displayValue, Color color) {
    return SizedBox(
      width: (1.sw - 16 * 5) / 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 12,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  displayValue,
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '$percent%',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RSColor.color_0x40000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
