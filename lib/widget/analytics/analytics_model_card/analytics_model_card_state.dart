import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class AnalyticsModelCardState {
  /// 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  bool pageEditing = false;

  /// 图标类型状态
  var chartTypeStatus = 0.obs;

  /// chart数据源
  var allChartData = <RSChartData>[].obs;
  var allChartDayCompData = <RSChartData>[];
  var allChartWeekCompData = <RSChartData>[];
  var allChartMonthCompData = <RSChartData>[];
  var allChartYearCompData = <RSChartData>[];

  /// Chart Controller
  ChartSeriesController? chartSeriesController;

  /// 指标&时段卡片-请求结果返回模型
  var resultMetricsCardEntity = ModuleMetricsCardEntity().obs;

  /// -----去往编辑页需要的模型-----

  /// 卡片的下标（编辑反显需要）
  int cardIndex = -1;

  /// 卡片模板元数据
  var cardTemplateData = TopicTemplateTemplatesNavsTabsCards().obs;

  // 外部传入自定义的时间——影响范围：当前页面
  List<String>? shopIds;
  List<DateTime>? displayTime;
  List<CompareDateRangeType>? compareDateRangeTypes;
  List<List<DateTime>>? compareDateTimeRanges;
  CustomDateToolEnum customDateToolEnum = CustomDateToolEnum.DAY;

  AnalyticsModelCardState() {
    ///Initialize variables
  }
}
