import 'package:flutter/material.dart';
import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';
import 'package:get/get.dart';

import '../../model/store/store_entity.dart';
import '../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../widget/load_state_layout.dart';
import '../login/account_manager/account_manager.dart';

class AnalyticsState {
  /// 主题下标
  var topicIndex = 0;

  /// 页面加载状态
  var loadState = LoadState.stateLoading.obs;

  /// 门店title
  var selectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;

  /// obs传值刷新用
  var tmpValue = "".obs;

  /// ------------------

  /// tab
  TabController? tabController;

  /// 业务主题
  var tabs = <String>[].obs; //['Sales', 'Items', 'Payments', 'Employees'];

  /// 模板实体
  var topicTemplateEntity = TopicTemplateEntity().obs;

  /// ----------自定义时间模块----------

  // 自定义日期组件的枚举值：日/月
  var customDateToolEnum = CustomDateToolEnum.DAY;

  // 当前页面自定义时间范围
  var currentCustomDateTime = <DateTime>[];

  // 对比时间范围类型——Enum
  var compareDateRangeTypes = <CompareDateRangeType>[];

  // 对比时间范围——DateTime
  List<List<DateTime>> compareDateTimeRanges = [];

  AnalyticsState() {
    ///Initialize variables
  }
}
