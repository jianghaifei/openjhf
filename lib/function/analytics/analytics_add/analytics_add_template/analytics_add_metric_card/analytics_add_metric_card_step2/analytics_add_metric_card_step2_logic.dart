import 'package:get/get.dart';

import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../utils/logger/logger_helper.dart';
import 'analytics_add_metric_card_step2_state.dart';

class AnalyticsAddMetricCardStep2Logic extends GetxController {
  final AnalyticsAddMetricCardStep2State state = AnalyticsAddMetricCardStep2State();

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

  List<int> findIfDefaultIndex() {
    List<int> list = [];

    int index = 0;
    state.metricsCardEntity?.metrics?.forEach((element) {
      if (element.ifDefault) {
        list.add(index);
      }
      index++;
    });
    return list;
  }

  Map<String, dynamic> getAnalyticsAddMetricCardStep3Arguments() {
    if (state.metricsCardEntity != null && state.metricsCardEntity?.metrics != null) {
      MetricsEditInfoMetricsCard? metricsCard = MetricsEditInfoMetricsCard.fromJson(state.metricsCardEntity!.toJson());

      List<MetricsEditInfoMetrics>? listMetrics = [];

      for (int index in state.selectIndexList) {
        if (state.metricsCardEntity?.metrics != null && index < state.metricsCardEntity!.metrics!.length) {
          listMetrics.add(state.metricsCardEntity!.metrics![index]);
        }
      }

      metricsCard.metrics = listMetrics;
      return {
        "metricsCardEntity": metricsCard,
        "layoutType": state.layoutType,
      };
    }

    return {};
  }
}
