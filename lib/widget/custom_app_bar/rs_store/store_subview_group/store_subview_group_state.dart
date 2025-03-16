import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:get/get.dart';

import '../../../../model/store/store_entity.dart';

class StoreSubviewGroupState {
  /// 分组类型
  var groupType = StoreSelectedGroupType.allType;

  /// search
  final searchTextFieldController = TextEditingController().obs;

  /// 货币下标
  var selectedCurrencyIndex = 0.obs;
  var recordSelectedCurrencyIndex = 0;

  /// 左侧列表下标
  var selectedLeftListIndex = 0.obs;

  /// 原始数据模型
  // var originalStoreEntity = StoreEntity();

  /// 展示——数据模型
  var displayStoreEntity = StoreEntity().obs;

  /// 展示——门店数据模型
  var displayStoreCurrencyShops = <StoreCurrencyShops>[].obs;

  /// 所有选中的门店
  var allSelectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;
  var recordAllSelectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;

  /// 是否显示全选
  var showAllSelected = true.obs;

  StoreSubviewGroupState() {
    ///Initialize variables
  }

  void initData(String? currencyValue) {
    var findCurrency = RSAccountManager().getAllCurrency().firstWhere((element) => element.value == currencyValue);

    int index = -1;

    if (displayStoreCurrencyShops.isNotEmpty) {
      for (int i = 0; i < displayStoreCurrencyShops.length; i++) {
        if (displayStoreCurrencyShops[i].currency?.value == findCurrency.value) {
          index = i;
        }
      }
    }

    if (index != -1) {
      selectedCurrencyIndex.value = index;
      recordSelectedCurrencyIndex = index;
    }

    selectedLeftListIndex.value = 0;
  }
}
