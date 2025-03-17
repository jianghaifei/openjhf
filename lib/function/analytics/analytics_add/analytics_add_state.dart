import '../../../generated/l10n.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';

class AnalyticsAddState {
  final List<String> sections = [S.current.rs_custom, S.current.rs_template];
  final Map<String, List<String>> items = {
    S.current.rs_custom: [S.current.rs_metric_card, S.current.rs_analysis_chart, S.current.rs_analysis_model],
    S.current.rs_template: [S.current.rs_template],
  };

  MetricsEditInfoEntity? metricsEditInfoEntity;

  String? navId;
  String? tabId;
  String? tabName;
  List<String?> recordKeyMetricsAddedMetricCodes = [];
  TopicTemplateTemplatesNavsTabs? tabsData;

  AnalyticsAddState() {
    ///Initialize variables
  }
}
