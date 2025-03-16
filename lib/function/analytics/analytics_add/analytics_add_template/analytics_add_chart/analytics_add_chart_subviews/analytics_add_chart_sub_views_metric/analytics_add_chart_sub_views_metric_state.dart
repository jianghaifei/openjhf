import 'package:get/get.dart';

import '../../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import 'analytics_add_chart_sub_views_metric_view.dart';

class AnalyticsAddChartSubViewsMetricState {
  String title = 'Metric';

  /// 当前页面解析维度/指标
  var dimOrMetricType = PageDimOrMetricType.metric.obs;

  var pageType = SubViewsMetricPageType.single.obs;
  var selectedMetricsIndex = <int>[].obs;

  List<int> defaultIndexList = [];

  MetricsEditInfoMetricsCard? originalAnalysisChartEntity;
  MetricsEditInfoMetricsCard? analysisChartEntity;

  AnalyticsAddChartSubViewsMetricState() {
    ///Initialize variables
  }
}
