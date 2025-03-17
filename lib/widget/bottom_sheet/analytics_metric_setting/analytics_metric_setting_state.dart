import 'package:get/get.dart';

import 'analytics_metric_setting_view.dart';

class AnalyticsMetricSettingState {
  MetricSettingType metricSettingType = MetricSettingType.metricSetting;

  var listDataMetricDisplay = ["Net Sales", "Total Sales", "Orders", "Guests"].obs;
  var listDataExtensionShowing = ["Compare to"].obs;

  var listDataCompareTime =
      ["The Day Last Week", "The Day Last Week", "The Day Last Week", "The Day Last Week", "The Day Last Week"].obs;

  var selectedCheckBoxValues = [].obs;
  var selectedCheckBoxExtensionShowingValues = [].obs;
  var selectedCheckBoxCompareIndex = 0.obs;

  AnalyticsMetricSettingState() {
    ///Initialize variables
  }
}
