import 'package:get/get.dart';

import '../../../../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';

class AnalyticsAddFilterSubViewState {
  var filterOptions = <MetricsEditInfoMetricFilterConfiguratorFilterOptions>[].obs;

  MetricsEditInfoMetricsCard? originalAnalysisChartEntity;
  MetricsEditInfoMetricsCard? analysisChartEntity;

  var entity = AnalyticsEntityFilterComponentEntity();

  /// 选中筛选维度下标
  var selectedFilterIndex = RxInt(-1);

  /// 选中的维度绑定的指标
  var selectedFilterBindOptions = <MetricsEditInfoMetricFilterConfiguratorFilterOptions>[].obs;

  /// 选中的维度绑定的指标下标
  var selectedFilterBindOptionIndex = <int>[].obs;

  /// 选中的维度绑定的指标值
  MetricsEditInfoMetricFilterConfiguratorFilterOptions? recordSelectedFilter;

  /// 重试循环次数
  var loopCount = 0;

  AnalyticsAddFilterSubViewState() {
    ///Initialize variables
  }
}
