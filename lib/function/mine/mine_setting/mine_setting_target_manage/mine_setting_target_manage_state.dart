import 'package:flustars/flustars.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:get/get.dart';

import '../../../../model/target_manage/target_manage_edit_config_entity.dart';
import '../../../../model/target_manage/target_manage_list_targets_entity.dart';
import '../../../../widget/card_load_state_layout.dart';

class MineSettingTargetManageState {
  // 是否第一次加载
  var isFirstLoad = true.obs;

  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;
  String? errorCode;
  String? errorMessage;

  // 编辑配置模型
  var targetManageEditConfigEntity = TargetManageEditConfigEntity().obs;

  // 获取集团下所有目标列表
  var targetManageListTargetsEntity = TargetManageListTargetsEntity().obs;

  // 月份：yyyyMM
  String month = DateUtil.formatDate(RSAccountManager().timeRange.first, format: 'yyyyMM');

  List<DateTime> timeRange = [];

  MineSettingTargetManageState() {
    ///Initialize variables
  }
}
