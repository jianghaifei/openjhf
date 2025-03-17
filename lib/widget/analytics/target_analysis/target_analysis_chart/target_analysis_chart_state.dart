import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../config/rs_color.dart';
import '../../../../model/chart_data/rs_chart_data.dart';

enum TargetAnalysisChartType {
  /// 累计
  cumulative,

  /// 分时
  daily,
}

class TargetAnalysisChartState {
  /// chart数据源
  var allChartData = <RSChartData>[].obs;
  var allChartCompData = <RSChartData>[];

  /// Chart Controller
  ChartSeriesController? chartSeriesController;

  late List<Color> chartStartColor;

  late List<double> chartStopColor;

  late LinearGradient gradientColors;

  /// 当前选中的图表类型
  var chartType = TargetAnalysisChartType.cumulative.obs;

  TargetAnalysisChartState() {
    chartStartColor = [
      RSColor.color_0xFF5C57E6.withOpacity(0.5),
      RSColor.color_0xFF5C57E6.withOpacity(0.2),
      RSColor.color_0xFF5C57E6.withOpacity(0.05),
    ];

    chartStopColor = [0.05, 0.2, 0.5];

    gradientColors = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.repeated,
      colors: chartStartColor,
      stops: chartStopColor,
    );
  }
}
