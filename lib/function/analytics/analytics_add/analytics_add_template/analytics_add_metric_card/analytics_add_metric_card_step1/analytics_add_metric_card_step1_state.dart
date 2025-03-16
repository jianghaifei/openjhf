import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';

class AnalyticsAddMetricCardStep1State {
  var selectedIndex = RxInt(-1);

  String? tabName;
  MetricsEditInfoMetricsCard? metricsCardEntity;

  AnalyticsAddMetricCardStep1State() {
    ///Initialize variables
  }
}
