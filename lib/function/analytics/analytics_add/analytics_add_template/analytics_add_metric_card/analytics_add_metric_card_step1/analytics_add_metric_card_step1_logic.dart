import 'package:get/get.dart';

import '../../../../../../utils/logger/logger_helper.dart';
import 'analytics_add_metric_card_step1_state.dart';

class AnalyticsAddMetricCardStep1Logic extends GetxController {
  final AnalyticsAddMetricCardStep1State state = AnalyticsAddMetricCardStep1State();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  Map<String, dynamic> getAnalyticsAddMetricCardStep2Arguments() {
    return {
      "tabName": state.tabName,
      "metricsCardEntity": state.metricsCardEntity,
      "layoutType": state.selectedIndex.value + 1,
    };
  }
}
