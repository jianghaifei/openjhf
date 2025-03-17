import 'package:get/get.dart';

import 'analytics_add_metrics_widget_state.dart';

class AnalyticsAddMetricsWidgetLogic extends GetxController {
  final AnalyticsAddMetricsWidgetState state = AnalyticsAddMetricsWidgetState();

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

  bool setIfDefault(int index, List<int>? ifDefaultList) {
    bool ifDefault = false;
    ifDefaultList?.forEach((element) {
      if (element == index) {
        ifDefault = true;
        return;
      }
    });
    return ifDefault;
  }
}
