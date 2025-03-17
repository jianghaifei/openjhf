import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../model/business_topic/topic_template_entity.dart';

class AnalyticsAddChartSubviewsState {
  List<String> sections = [S.current.rs_base_settings, S.current.rs_advanced];
  var items = {}.obs;

  MetricsEditInfoMetricsCard? chartEntity;

  /// 输入框
  var nameTextController = TextEditingController();
  var nameErrorTip = false.obs;

  /// 选中Chart type 下标
  var selectedChartLabelIndex = RxInt(-1);
  var chartLabelErrorTip = false.obs;

  /// 选中Chart type Change 下标
  var selectedChartLabelChangeIndex = RxInt(-1);

  /// 选中Chart type 展示条数 下标
  var selectedChartLabelDisplayCountIndex = RxInt(-1);

  /// 选中Metric 下标
  var selectedBasicMetricIndex = RxInt(-1);
  var basicMetricErrorTip = false.obs;

  /// 记录选中的默认指标（单选）
  var recordSelectedBasicMetric = MetricsEditInfoMetrics().obs;

  /// 记录选中的对比指标（单选）
  var recordSelectedComparedToMetric = MetricsEditInfoMetrics().obs;

  /// 选中Dim 下标
  var selectedBasicDimIndex = RxInt(-1);
  var basicDimErrorTip = false.obs;

  /// 记录选中的默认指标（单选）
  var recordSelectedBasicDim = MetricsEditInfoDims().obs;

  /// 选中展示条数下标
  var selectedDisplayCountIndex = RxInt(-1);
  var displayCountErrorTip = false.obs;

  /// Compared to 是否选中
  var formComparedToIsCheck = false.obs;
  var comparedToErrorTip = false.obs;

  /// 选中相对比方式 下标
  var selectedComparedToFormIndex = RxInt(-1);

  /// 选中相对比方式为Metrics 下标
  var selectedComparedToMetricsFormIndex = RxInt(-1);
  var comparedToMetricsErrorTip = false.obs;

  /// 高级设置-选中的所有Metrics下标
  var selectedAllMetricsFormIndex = <int>[].obs;

  /// 高级设置-记录选中的所有指标（多选）
  var recordSelectedAllMetrics = <MetricsEditInfoMetrics>[].obs;

  /// 高级设置-选中的所有Dims下标
  var selectedAllDimsFormIndex = <int>[].obs;

  /// 高级设置-记录选中的所有Dims（多选）
  var recordSelectedAllDims = <MetricsEditInfoDims>[].obs;

  /// 高级设置-选中的Filter下标
  var selectedFilterIndex = RxInt(-1);

  /// 高级设置-记录选中的Filter（单选）
  var recordSelectedFilter = MetricsEditInfoMetricFilterConfiguratorFilterOptions().obs;

  /// 卡片模板元数据
  TopicTemplateTemplatesNavsTabsCards? cardTemplateData;

  /// 卡片的下标（编辑反显需要）
  int cardIndex = -1;

  AnalyticsAddChartSubviewsState() {
    ///Initialize variables
  }
}
