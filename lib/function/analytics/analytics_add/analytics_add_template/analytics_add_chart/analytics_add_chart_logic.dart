import 'package:get/get.dart';

import '../../../../../utils/logger/logger_helper.dart';
import 'analytics_add_chart_state.dart';

class AnalyticsAddChartLogic extends GetxController {
  final AnalyticsAddChartState state = AnalyticsAddChartState();

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

  List<String>? getCustomTabTitles() {
    var listTabs = <String>[];
    state.analysisChartEntity?.forEach((element) {
      listTabs.add(element?.cardType?.name ?? "*");
    });
    return listTabs;
  }
}
