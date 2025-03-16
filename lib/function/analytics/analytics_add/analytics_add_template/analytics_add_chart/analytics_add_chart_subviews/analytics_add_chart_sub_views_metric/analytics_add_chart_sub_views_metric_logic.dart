import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../../../generated/l10n.dart';
import '../../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import 'analytics_add_chart_sub_views_metric_state.dart';
import 'analytics_add_chart_sub_views_metric_view.dart';

class AnalyticsAddChartSubViewsMetricLogic extends GetxController {
  final AnalyticsAddChartSubViewsMetricState state = AnalyticsAddChartSubViewsMetricState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    var args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey("pageType") && args.containsKey("analysisChartEntity")) {
        state.pageType.value = args["pageType"];
        state.originalAnalysisChartEntity = args["analysisChartEntity"];
        state.analysisChartEntity = MetricsEditInfoMetricsCard.fromJson(state.originalAnalysisChartEntity!.toJson());

        if (args.containsKey("defaultList")) {
          state.defaultIndexList = args["defaultList"];
        }

        if (args.containsKey("dimOrMetricType")) {
          state.dimOrMetricType.value = args["dimOrMetricType"];
        }

        setDefaultMetrics();
      } else {
        EasyLoading.showError('page arguments is null');

        Get.back();
      }
    } else {
      EasyLoading.showError('page arguments is null');
      Get.back();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void setDefaultMetrics() {
    if (state.dimOrMetricType.value == PageDimOrMetricType.metric) {
      if (state.analysisChartEntity?.metrics != null) {
        for (int index = 0; index < state.analysisChartEntity!.metrics!.length; index++) {
          if (state.analysisChartEntity?.metrics?[index].dimOptions != null &&
              state.analysisChartEntity!.metrics![index].dimOptions!.isNotEmpty) {
            state.selectedMetricsIndex.add(index);
          }
        }
      }
    } else {
      if (state.analysisChartEntity?.dims != null) {
        for (int index = 0; index < state.analysisChartEntity!.dims!.length; index++) {
          if (state.analysisChartEntity?.dims?[index].metricOptions != null &&
              state.analysisChartEntity!.dims![index].metricOptions!.isNotEmpty) {
            state.selectedMetricsIndex.add(index);
          }
        }
      }
    }
  }

  String getDimNameBasedOnDimCode(String dimCode) {
    String dimName = '';

    state.analysisChartEntity?.dims?.forEach((dim) {
      if (dim.dimCode == dimCode) {
        dimName = dim.dimName ?? '';
      }
    });

    return dimName;
  }

  String getMetricNameBasedOnMetricCode(String metricCode) {
    String metricName = '';

    state.analysisChartEntity?.metrics?.forEach((metric) {
      if (metric.metricCode == metricCode) {
        metricName = metric.metricName ?? '';
      }
    });

    return metricName;
  }

  bool checkOption() {
    if (state.selectedMetricsIndex.isNotEmpty) {
      for (var index in state.selectedMetricsIndex) {
        if (state.dimOrMetricType.value == PageDimOrMetricType.metric) {
          var dimOptions = state.analysisChartEntity!.metrics?[index].dimOptions;
          if (dimOptions == null || dimOptions.isEmpty) {
            EasyLoading.showToast(S.current.rs_add_dim_tip);
            return false;
          }
        } else {
          var metricOptions = state.analysisChartEntity!.dims?[index].metricOptions;
          if (metricOptions == null || metricOptions.isEmpty) {
            EasyLoading.showToast("请为维度配置指标");
            return false;
          }
        }
      }
      return true;
    } else {
      EasyLoading.showToast(S.current.rs_add_metric_tip);
      return false;
    }
  }
}
