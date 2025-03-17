import 'package:get/get.dart';

import 'analytics_logic.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsLogic());
  }
}
