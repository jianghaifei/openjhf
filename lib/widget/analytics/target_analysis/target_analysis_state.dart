import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/store/store_entity.dart';
import '../../../model/target_manage/target_manage_config_entity.dart';
import '../../../model/target_manage/target_manage_overview_entity.dart';
import '../../../utils/date_util.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class TargetAnalysisState {
  // 是否第一次加载
  var isFirstLoad = true.obs;

  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;
  String? errorCode;
  String? errorMessage;

  // 目标管理配置模型
  var targetManageConfigEntity = TargetManageConfigEntity().obs;

  // 目标管理概览模型
  var targetManageOverviewEntity = TargetManageOverviewEntity().obs;

  // 当前页面选择的指标
  var selectedMetric = TargetManageConfigMetrics().obs;

  // 显示提示
  var showTip = true.obs;

  //region 当前页面选择门店模块
  // 门店信息
  var storeEntity = StoreEntity().obs;

  // 选中的门店
  var selectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;

  // 选中的货币value
  var selectedCurrencyValue = "".obs;

  //endregion

  //region 自定义门店&时间
  // 外部传入自定义的时间——影响范围：当前页面
  var shopIds = <String>[].obs;

  // 传递过来的时间范围（入参使用：['2023-12-17','2023-12-18']）
  var timeRange = <String>[].obs;

  // 自定义日期组件的枚举值：日/月
  var customDateToolEnum = CustomDateToolEnum.DAY;

  // 当前页面自定义时间范围
  var currentCustomDateTime = <DateTime>[];
  //endregion

  // 指标code
  String? metricCode;

  TargetAnalysisState() {
    ///Initialize variables

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("shopIds") && args["shopIds"] != null) {
        shopIds.value = args["shopIds"];
      }

      if (args.containsKey("customDateToolEnum") && args["customDateToolEnum"] != null) {
        customDateToolEnum = args["customDateToolEnum"];
      }

      if (args.containsKey("metricCode") && args["metricCode"] != null) {
        metricCode = args["metricCode"];
      }

      if (args.containsKey("timeRange") && args["timeRange"] != null) {
        timeRange.value = args["timeRange"];
        currentCustomDateTime = RSDateUtil.listStringToDateRange(timeRange);
      } else {
        timeRange.value = RSDateUtil.dateRangeToListString(RSAccountManager().timeRange);
      }
    }

    // 深拷贝
    selectedShops.value = RSAccountManager()
        .selectedShops
        .map((element) => StoreCurrencyShopsGroupShopsBrandShops.fromJson(element.toJson()))
        .toList();
    selectedCurrencyValue.value = RSAccountManager().getCurrency()?.value ?? "";

    if (RSAccountManager().storeEntity != null) {
      storeEntity.value = StoreEntity.fromJson(RSAccountManager().storeEntity!.toJson());
    } else {
      Get.back();
      EasyLoading.showError("storeEntity Empty");
    }
  }
}
