import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class AnalyticsTopRankCardState {
  // ----------PK----------
  // PK模型
  var resultStorePKTableEntity = StorePKTableEntity().obs;

  // ----------------------

  /// 显示最大条目数
  final int showMaxLength = 5;

  /// 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  /// 卡片元数据
  var metadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata().obs;

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

  // 外部传入自定义的时间——影响范围：当前页面
  List<String>? shopIds;
  List<DateTime>? displayTime;
  List<CompareDateRangeType>? compareDateRangeTypes;
  List<List<DateTime>>? compareDateTimeRanges;
  CustomDateToolEnum customDateToolEnum = CustomDateToolEnum.DAY;

  AnalyticsTopRankCardState() {
    ///Initialize variables
  }
}
