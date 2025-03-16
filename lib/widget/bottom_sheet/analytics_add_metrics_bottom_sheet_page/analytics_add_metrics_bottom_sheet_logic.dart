import 'package:get/get.dart';

import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import 'analytics_add_metrics_bottom_sheet_state.dart';
import 'analytics_add_metrics_bottom_sheet_view.dart';

class AnalyticsAddMetricsBottomSheetPageLogic extends GetxController {
  final AnalyticsAddMetricsBottomSheetPageState state = AnalyticsAddMetricsBottomSheetPageState();

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

  List<int> findIfDefaultIndex(MetricsEditInfoMetricsCard? custom, AnalyticsAddMetricsOrDimsType pageType,
      List<MetricsEditInfoMetrics?>? lastSelectedMetrics, List<MetricsEditInfoDims?>? lastSelectedDims) {
    List<int> list = [];

    int index = 0;
    if (pageType == AnalyticsAddMetricsOrDimsType.metrics) {
      custom?.metrics?.forEach((metricElement) {
        lastSelectedMetrics?.forEach((element) {
          if (element?.metricCode == metricElement.metricCode) {
            list.add(index);
          }
        });
        index++;
      });
    } else {
      custom?.dims?.forEach((dimElement) {
        lastSelectedDims?.forEach((element) {
          if (element?.dimCode == dimElement.dimCode) {
            list.add(index);
          }
        });
        index++;
      });
    }

    return list;
  }
}
