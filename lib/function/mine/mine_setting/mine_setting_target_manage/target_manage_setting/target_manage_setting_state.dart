import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../model/store/store_entity.dart';
import '../../../../../model/target_manage/target_manage_edit_config_entity.dart';
import '../../../../../model/target_manage/target_manage_list_targets_entity.dart';
import '../../../../../model/target_manage/target_manage_shops_entity.dart';
import '../../../../../utils/date_util.dart';
import '../../../../login/account_manager/account_manager.dart';

// 页面类型枚举值
enum TargetManageSettingPageType {
  // 编辑
  edit,

  // 预览
  preview,
}

class TargetManageSettingState {
  // 传递过来的模型
  var infoEntity = TargetManageListTargetsInfos().obs;

  // 编辑配置
  var editConfigEntity = TargetManageEditConfigEntity().obs;

  // 页面类型
  var pageType = TargetManageSettingPageType.edit.obs;

  // titles
  var titles = <List<String>>[].obs;

  // 默认选中的指标下标
  var selectedMetricsIndex = RxInt(-1);
  var metricsErrorTip = false.obs;

  //region 月份
  // 时间范围
  var timeRange = <String>[].obs;

  // 开始时间
  var startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  // 结束时间
  var endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  //endregion

  //region 分配方式
  // 分配方式titles
  var distributionTitles = [
    "${S.current.rs_by} ${S.current.rs_weekday}",
    "${S.current.rs_by} ${S.current.rs_weekly}",
    "${S.current.rs_by} ${S.current.rs_date_day}"
  ];

  // 选择的分配方式下标
  var selectedDistributionIndex = RxInt(-1);
  var distributionErrorTip = false.obs;

  // 输入框控制器数组
  var textEditingControllerList = <TextEditingController>[].obs;

  // 总金额
  var totalAmount = BigInt.zero.obs;

  //endregion

  // 目标id（用于修改使用）
  var targetId = "";

  // 配置相关的门店信息
  var targetManageShopsEntity = TargetManageShopsEntity().obs;

  //region 应用门店
  // 门店信息
  var storeEntity = StoreEntity().obs;

  // 选择的门店
  var selectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;
  var selectedShopsErrorTip = false.obs;

  // 选中的货币value
  var selectedCurrencyValue = "".obs;

  //endregion

  TargetManageSettingState() {
    ///Initialize variables

    // 深拷贝
    if (RSAccountManager().storeEntity != null) {
      storeEntity.value = StoreEntity.fromJson(RSAccountManager().storeEntity!.toJson());
    } else {
      Get.back();
      EasyLoading.showError("storeEntity Empty");
    }

    // 获取页面参数
    var args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey("infoEntity") && args["infoEntity"] != null) {
        infoEntity.value = args["infoEntity"];
      }

      if (args.containsKey("editConfigEntity") && args["editConfigEntity"] != null) {
        editConfigEntity.value = args["editConfigEntity"];
      }

      if (args.containsKey("pageType") && args["pageType"] != null) {
        pageType.value = args["pageType"];
      }

      if (args.containsKey("timeRange") && args["timeRange"] != null) {
        List<DateTime> tmpDateRange = args["timeRange"];

        timeRange.value = RSDateUtil.dateRangeToListString(tmpDateRange);

        startDate.value = tmpDateRange.first;
        endDate.value = tmpDateRange.last;
      }
    }
  }
}
