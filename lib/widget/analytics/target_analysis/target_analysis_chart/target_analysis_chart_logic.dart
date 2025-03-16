import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../model/chart_data/rs_chart_data.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import 'target_analysis_chart_state.dart';

class TargetAnalysisChartLogic extends GetxController {
  final TargetAnalysisChartState state = TargetAnalysisChartState();

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

  void setChartData(TargetManageOverviewCumulativeTrend? cumulativeTrend, TargetManageOverviewDailyTrend? dailyTrend) {
    state.allChartData.clear();
    state.allChartCompData.clear();

    var chartData = returnChartData(cumulativeTrend, dailyTrend, state.chartType.value);

    if (chartData != null && chartData.isNotEmpty) {
      int index = 0;

      for (var chartElement in chartData) {
        if (chartElement.axisY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartData.add(RSChartData(chartElement.axisY?.first.metricName ?? '*',
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(0)));
        }

        if (chartElement.axisCompY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisCompY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartCompData.add(RSChartData(chartElement.axisCompY?.first.metricName ?? '*',
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(1)));
        }
      }

      // 更新chart
      state.chartSeriesController?.updateDataSource();
    }
  }

  List<TargetManageOverviewChart>? returnChartData(TargetManageOverviewCumulativeTrend? cumulativeTrend,
      TargetManageOverviewDailyTrend? dailyTrend, TargetAnalysisChartType chartType) {
    var chartData = cumulativeTrend?.chart;
    if (chartType == TargetAnalysisChartType.daily) {
      chartData = dailyTrend?.chart;
    }

    return chartData;
  }

  // 获取axisY中最大的metricValue
  double getMaxMetricValue(List<TargetManageOverviewChart>? chart) {
    double maxMetricValue = 0.0;

    for (var chartElement in chart ?? []) {
      if (chartElement.axisY?.first != null) {
        var tmpY = double.tryParse(chartElement.axisY?.first.metricValue ?? "0") ?? 0.00;
        if (tmpY > maxMetricValue) {
          maxMetricValue = tmpY;
        }
      }
    }

    return maxMetricValue;
  }
}
