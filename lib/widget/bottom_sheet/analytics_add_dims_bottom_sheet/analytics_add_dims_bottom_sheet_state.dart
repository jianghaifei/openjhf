import 'package:get/get.dart';

import '../../../function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_sub_views_metric/analytics_add_chart_sub_views_metric_view.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';

class AnalyticsAddDimsOrMetricsBottomSheetState {
  var selectedIndex = <int>[].obs;

  var bindingDimsList = <MetricsEditInfoDims>[].obs;

  var bindingMetricsList = <MetricsEditInfoMetrics>[].obs;

  /// 设为默认的下标
  var setDefaultIndex = RxInt(-1);

  var dimOrMetricType = PageDimOrMetricType.dim.obs;

  AnalyticsAddDimsOrMetricsBottomSheetState() {
    ///Initialize variables
  }
}
