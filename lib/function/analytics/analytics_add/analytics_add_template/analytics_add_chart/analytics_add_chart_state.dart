import '../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../model/business_topic/topic_template_entity.dart';

class AnalyticsAddChartState {
  late List<String> tabs;

  String? tabName;
  List<MetricsEditInfoMetricsCard?>? analysisChartEntity;

  /// 卡片模板元数据
  TopicTemplateTemplatesNavsTabsCards? cardTemplateData;

  /// 卡片的下标（编辑反显需要）
  int cardIndex = -1;

  AnalyticsAddChartState() {
    ///Initialize variables
  }
}
