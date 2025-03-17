import 'package:get/get.dart';

import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';

class AnalyticsAddMetricCardStep2State {
  List<String> tabs = [];

  var selectIndexList = <int>[].obs;

  String? tabName;
  MetricsEditInfoMetricsCard? metricsCardEntity;
  int layoutType = 0;

  AnalyticsAddMetricCardStep2State() {
    ///Initialize variables
  }
}
