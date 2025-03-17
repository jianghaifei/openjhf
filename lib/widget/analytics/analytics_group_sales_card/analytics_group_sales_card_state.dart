import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/metrics_card/module_group_metrics_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class AnalyticsGroupSalesCardState {
  /// 分组-请求结果返回模型
  var resultModuleGroupMetricsEntity = ModuleGroupMetricsEntity().obs;

  /// 选中指标下标
  var selectedMetricsIndex = 0.obs;

  /// 选中指标模型
  var selectedMetric = TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics().obs;

  /// 维度下标
  var selectedDimsIndex = 0.obs;

  /// 图标类型状态(0：chart, 1: list)
  var chartTypeStatus = 0.obs;

  /// 显示最大条目数
  final int showMaxLength = 6;

  /// chart数据源
  var allChartData = <RSChartData>[].obs;

  /// Chart Controller
  CircularSeriesController? chartSeriesController;

  /// -----去往编辑页需要的模型-----

  /// 卡片模板元数据
  var cardTemplateData = TopicTemplateTemplatesNavsTabsCards().obs;

  /// 卡片的下标（编辑反显需要）
  int cardIndex = -1;

  /// （编辑反显需要）
  MetricsEditInfoMetricsCard? analysisChart;

  /// （编辑反显需要）
  String? tabId;

  /// （编辑反显需要）
  String? tabName;

  /// 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  /// 元数据
  var metadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata().obs;

  // 外部传入自定义的时间——影响范围：当前页面
  List<String>? shopIds;
  List<DateTime>? displayTime;
  List<CompareDateRangeType>? compareDateRangeTypes;
  List<List<DateTime>>? compareDateTimeRanges;
  CustomDateToolEnum customDateToolEnum = CustomDateToolEnum.DAY;

  AnalyticsGroupSalesCardState() {
    ///Initialize variables
  }
}
