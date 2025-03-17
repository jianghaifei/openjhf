import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';
import '../../generated/assets.dart';
import '../../model/business_topic/business_topic_type_enum.dart';
import 'chart_label_state.dart';
import 'chart_label_view.dart';

class ChartLabelLogic extends GetxController {
  final ChartLabelState state = ChartLabelState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  String returnChartImageName(AddMetricsChartType type) {
    switch (type) {
      case AddMetricsChartType.LINE:
        return Assets.imageChartLabelLine;
      case AddMetricsChartType.LIST:
        return Assets.imageChartLabelList;
      case AddMetricsChartType.BAR:
        return Assets.imageChartLabelBar;
      case AddMetricsChartType.PIE:
        return Assets.imageChartLabelPie;
      default:
        return Assets.imageChartLabelLine;
    }
  }

  Color returnWidgetBorderColor(ChartLabelStateType stateType) {
    switch (stateType) {
      case ChartLabelStateType.selected:
        return RSColor.color_0xFF5C57E6;
      case ChartLabelStateType.ifDefault:
        return RSColor.color_0xFF5C57E6.withOpacity(0.3);
      case ChartLabelStateType.none:
        return RSColor.color_0xFFDCDCDC;
    }
  }
}
