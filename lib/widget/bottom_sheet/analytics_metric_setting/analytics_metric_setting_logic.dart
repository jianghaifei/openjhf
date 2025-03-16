import 'package:get/get.dart';

import 'analytics_metric_setting_state.dart';
import 'analytics_metric_setting_view.dart';

class AnalyticsMetricSettingLogic extends GetxController {
  final AnalyticsMetricSettingState state = AnalyticsMetricSettingState();

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

  String returnTitleString(MetricSettingType type) {
    switch (type) {
      case MetricSettingType.metricSetting:
        return "Metric Setting";
      case MetricSettingType.rankSetting:
        return "Rank Setting";
      case MetricSettingType.cardListSetting:
        return "Card List Setting";
      default:
        return "Metric Setting";
    }
  }
}
