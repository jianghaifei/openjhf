import 'package:flutter_report_project/function/analytics/analytics_logic.dart';
import 'package:flutter_report_project/function/mine/mine_logic.dart';
import 'package:get/get.dart';

class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsLogic(), fenix: true);
    Get.lazyPut(() => MineLogic(), fenix: true);
  }
}
