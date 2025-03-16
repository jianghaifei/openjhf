import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class AnalyticsHourlySalesCardState {
  /// 选中指标下标
  var selectedMetricsIndex = 0.obs;

  /// 选中指标模型
  var selectedMetric = TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics().obs;

  /// 维度下标
  var selectedDimsIndex = 0.obs;

  /// 图标类型状态
  var chartTypeStatus = 0.obs;

  /// chart数据源
  var allChartData = <RSChartData>[].obs;
  var allChartDayCompData = <RSChartData>[];
  var allChartWeekCompData = <RSChartData>[];
  var allChartMonthCompData = <RSChartData>[];
  var allChartYearCompData = <RSChartData>[];

  /// 显示最大条目数
  final int showMaxLength = 6;

  /// Chart Controller
  ChartSeriesController? chartSeriesController;

  /// 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  /// 元数据
  var metadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata().obs;

  /// 指标&时段卡片-请求结果返回模型
  var resultMetricsCardEntity = ModuleMetricsCardEntity().obs;

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

  // var metricName = ''.obs;
  // var compareMetricName = ''.obs;

  late List<Color> chartStartColor;

  late List<double> chartStopColor;

  late LinearGradient gradientColors;

  // 外部传入自定义的时间——影响范围：当前页面
  List<String>? shopIds;
  List<DateTime>? displayTime;
  List<CompareDateRangeType>? compareDateRangeTypes;
  List<List<DateTime>>? compareDateTimeRanges;
  CustomDateToolEnum customDateToolEnum = CustomDateToolEnum.DAY;

  AnalyticsHourlySalesCardState() {
    ///Initialize variables

    chartStartColor = [
      RSColor.color_0xFF5C57E6.withOpacity(0.5),
      RSColor.color_0xFF5C57E6.withOpacity(0.2),
      RSColor.color_0xFF5C57E6.withOpacity(0.1),
    ];

    chartStopColor = [0.1, 0.2, 0.5];

    gradientColors = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.repeated,
      colors: chartStartColor,
      stops: chartStopColor,
    );
  }
}
