import 'package:get/get.dart';

import '../../../function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_sub_views_metric/analytics_add_chart_sub_views_metric_view.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import 'analytics_add_dims_bottom_sheet_state.dart';

class AnalyticsAddDimsOrMetricsBottomSheetLogic extends GetxController {
  final AnalyticsAddDimsOrMetricsBottomSheetState state = AnalyticsAddDimsOrMetricsBottomSheetState();

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

  void getDims(int metricIndex, MetricsEditInfoMetricsCard? analysisChartEntity) {
    var currentMetric = analysisChartEntity?.metrics?[metricIndex];

    final metricDimConfigurator = analysisChartEntity?.metricDimConfigurator
        ?.firstWhere((config) => config.metricCode == currentMetric?.metricCode);

    var findDim = analysisChartEntity?.dims
        ?.where((dim) => metricDimConfigurator?.dimCodeOptions?.contains(dim.dimCode) ?? false)
        .toList();

    if (findDim != null && findDim.isNotEmpty) {
      state.bindingDimsList.value = findDim;
      setDefaultDims(metricIndex, analysisChartEntity);
    }
  }

  void getMetrics(int dimIndex, MetricsEditInfoMetricsCard? analysisChartEntity) {
    var currentDim = analysisChartEntity?.dims?[dimIndex];

    final metricDimConfigurator =
        analysisChartEntity?.dimMetricConfigurator?.firstWhere((config) => config.dimCode == currentDim?.dimCode);

    var findMetric = analysisChartEntity?.metrics
        ?.where((metric) => metricDimConfigurator?.metricCodeOptions?.contains(metric.metricCode) ?? false)
        .toList();

    if (findMetric != null && findMetric.isNotEmpty) {
      state.bindingMetricsList.value = findMetric;
      setDefaultMetrics(dimIndex, analysisChartEntity);
    }
  }

  void setDefaultDims(int metricIndex, MetricsEditInfoMetricsCard? analysisChartEntity) {
    if (analysisChartEntity?.metrics?[metricIndex].dimOptions != null && state.bindingDimsList.isNotEmpty) {
      for (int index = 0; index < state.bindingDimsList.length; index++) {
        analysisChartEntity?.metrics?[metricIndex].dimOptions?.forEach((dimCode) {
          if (state.bindingDimsList[index].dimCode == dimCode) {
            state.selectedIndex.add(index);
            if (state.setDefaultIndex.value == -1 &&
                dimCode == analysisChartEntity.metrics?[metricIndex].dimOptions?.first) {
              state.setDefaultIndex.value = index;
            }
          }
        });
      }
    }
  }

  void setDefaultMetrics(int dimIndex, MetricsEditInfoMetricsCard? analysisChartEntity) {
    if (analysisChartEntity?.dims?[dimIndex].metricOptions != null && state.bindingMetricsList.isNotEmpty) {
      for (int index = 0; index < state.bindingMetricsList.length; index++) {
        analysisChartEntity?.dims?[dimIndex].metricOptions?.forEach((metricCode) {
          if (state.bindingMetricsList[index].metricCode == metricCode) {
            state.selectedIndex.add(index);
            if (state.setDefaultIndex.value == -1 &&
                metricCode == analysisChartEntity.dims?[dimIndex].metricOptions?.first) {
              state.setDefaultIndex.value = index;
            }
          }
        });
      }
    }
  }

  void bindingData(int index, MetricsEditInfoMetricsCard? analysisChartEntity) {
    if (state.dimOrMetricType.value == PageDimOrMetricType.dim) {
      analysisChartEntity?.dims?[index].metricOptions =
          findAllSelectedMetrics().map((element) => element.metricCode ?? '').toList();
    } else {
      analysisChartEntity?.metrics?[index].dimOptions =
          findAllSelectedDims().map((element) => element.dimCode ?? '').toList();
    }
  }

  List<MetricsEditInfoDims> findAllSelectedDims() {
    List<MetricsEditInfoDims> selectedDims = [];
    for (int index in state.selectedIndex) {
      if (index < state.bindingDimsList.length) {
        selectedDims.add(state.bindingDimsList[index]);
      }
    }

    if (state.setDefaultIndex.value != -1) {
      var tmpDim = state.bindingDimsList[state.setDefaultIndex.value];
      int findIndex = selectedDims.indexWhere((element) => element.dimCode == tmpDim.dimCode);
      if (findIndex != -1) {
        selectedDims.removeAt(findIndex);
        selectedDims.insert(0, tmpDim);
      }
    }

    return selectedDims;
  }

  List<MetricsEditInfoMetrics> findAllSelectedMetrics() {
    List<MetricsEditInfoMetrics> selectedMetrics = [];
    for (int index in state.selectedIndex) {
      if (index < state.bindingMetricsList.length) {
        selectedMetrics.add(state.bindingMetricsList[index]);
      }
    }

    if (state.setDefaultIndex.value != -1) {
      var tmpMetric = state.bindingMetricsList[state.setDefaultIndex.value];
      int findIndex = selectedMetrics.indexWhere((element) => element.metricCode == tmpMetric.metricCode);
      if (findIndex != -1) {
        selectedMetrics.removeAt(findIndex);
        selectedMetrics.insert(0, tmpMetric);
      }
    }

    return selectedMetrics;
  }
}
