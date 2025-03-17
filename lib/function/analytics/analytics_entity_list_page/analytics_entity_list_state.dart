import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import 'package:get/get.dart';

import '../../../model/analytics_entity_list/analytics_entity_list_entity.dart';
import '../../../model/analytics_entity_list/evaluate_list_entity.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../utils/date_util.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../login/account_manager/account_manager.dart';

class AnalyticsEntityListState {
  /// 评论实体
  final String EVALUATION = 'EVALUATION';

  /// 刷新组件
  EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 实体列表模型
  var listEntity = AnalyticsEntityListEntity().obs;

  /// 评论列表模型
  var evaluateListEntity = EvaluateListEntity().obs;

  /// 指标筛选组件数据模型
  var filterComponentEntity = AnalyticsEntityFilterComponentEntity().obs;

  /// 搜索实体模型
  var searchFilterEntity = AnalyticsEntityFilterComponentFilters().obs;

  /// range实体模型
  var rangeFilterEntity = AnalyticsEntityFilterComponentFilters().obs;

  /// Filter --- 最大最小值
  var filterMinAndMax = RxList<double?>([]);
  var filterNumericalValueTypeString = ["~"].obs;

  /// Filter --- OrderBy
  var selectedOrderByIndex = RxInt(-1);

  /// 当前页码
  int currentPageNo = 1;

  /// 分页大小
  final int pageSize = 30;

  /// 页面标题
  var entityTitle = "".obs;

  /// 是否正序（默认倒序:DESC, 正序:ASC）
  var isAscSort = false.obs;

  /// 实体（入参使用）
  String? entity;

  /// 实体，去往下一个列表页时需要传入上一级的实体（入参使用）
  String? lastEntity;

  /// 指标编号（入参使用）
  String? metricCode;

  /// 过滤指标编号（入参使用）
  String? filterMetricCode;

  /// 维度编号（入参使用）
  String? dimsCode;

  /// 一级页点击其它进来
  // List<String?>? filterValueArray;

  /// 过滤的值（入参使用替换filterValue）
  List<ModuleMetricsCardDrillDownInfoFilter>? filters;

  /// 当前页面的Filter参数，用于去往新列表页时带入
  var filterParams = [];

  var relationDims = [];
  var relationMetrics = [];

  /// 传递过来的时间范围（入参使用：['2023-12-17','2023-12-18']）
  var timeRange = <String>[].obs;

  /// 过滤条件展示名字
  // var filterConditions = <String>[].obs;
  var selectedFilters = <AnalyticsEntityFilterComponentFilters>[].obs;

  /// 是否拥有过滤条件
  var isHaveFilterConditions = false.obs;

  /// 搜索框
  var searchTextFieldController = TextEditingController().obs;

  /// 单门店入参使用
  List<String>? shopIds;

  /// ----------自定义时间模块----------

  // 自定义日期组件的枚举值：日/月
  var customDateToolEnum = CustomDateToolEnum.DAY;

  // 当前页面自定义时间范围
  var currentCustomDateTime = <DateTime>[];

  AnalyticsEntityListState() {
    ///Initialize variables
    handleData();
  }

  void handleData() {
    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("entity") && args["entity"] != null) {
        entity = args["entity"];
      }

      if (args.containsKey("shopIds") && args["shopIds"] != null) {
        shopIds = args["shopIds"];
      }

      if (args.containsKey("customDateToolEnum") && args["customDateToolEnum"] != null) {
        customDateToolEnum = args["customDateToolEnum"];
      }

      if (args.containsKey("lastEntity") && args["lastEntity"] != null) {
        lastEntity = args["lastEntity"];
      }

      if (args.containsKey("entityTitle") && args["entityTitle"] != null) {
        entityTitle.value = args["entityTitle"];
      }

      if (args.containsKey("metricCode") && args["metricCode"] != null) {
        metricCode = args["metricCode"];
      }

      if (args.containsKey("filterMetricCode") && args["filterMetricCode"] != null) {
        filterMetricCode = args["filterMetricCode"];
      }

      if (args.containsKey("dimsCode") && args["dimsCode"] != null) {
        dimsCode = args["dimsCode"];
      }

      // if (args.containsKey("filterValueArray") && args["filterValueArray"] != null) {
      //   filterValueArray = args["filterValueArray"];
      // }

      if (args.containsKey("filter") && args["filter"] != null) {
        filters = args["filter"];
      }

      // 上一个列表页传入
      if (args.containsKey("filterParams") && args["filterParams"] != null) {
        filterParams = args["filterParams"];
      }

      // 上一个列表页传入
      if (args.containsKey("relationDims") && args["relationDims"] != null) {
        relationDims = args["relationDims"];
      }
      // 上一个列表页传入
      if (args.containsKey("relationMetrics") && args["relationMetrics"] != null) {
        relationMetrics = args["relationMetrics"];
      }

      if (args.containsKey("timeRange") && args["timeRange"] != null) {
        timeRange.value = args["timeRange"];
        currentCustomDateTime = RSDateUtil.listStringToDateRange(timeRange);
      } else {
        timeRange.value = RSDateUtil.dateRangeToListString(RSAccountManager().timeRange);
      }
    } else {
      EasyLoading.showError('Missing parameter');
      logger.w("Missing parameter", StackTrace.current);
      Get.back();
      return;
    }
  }
}
