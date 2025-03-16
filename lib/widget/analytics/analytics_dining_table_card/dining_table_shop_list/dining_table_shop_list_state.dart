import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../model/dining_table/dining_table_shops_template_entity.dart';
import '../../../../model/store/store_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../card_load_state_layout.dart';

class DiningTableShopListState {
  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  // 实时桌台--获取门店列表模板
  var templateEntity = DiningTableShopsTemplateEntity().obs;

  // 店铺PK表格数据
  var storePKTableEntity = StorePKTableEntity().obs;

  // 当前时间标题
  var currentTimeTitle = "".obs;

  // 选中的指标
  var selectedMetrics = <DiningTableShopsTemplateCardMetadataMetrics>[].obs;

  // 选中的维度
  var selectedDims = <DiningTableShopsTemplateCardMetadataDims>[].obs;

  //region 当前页面选择门店模块
  // 门店信息
  var storeEntity = StoreEntity().obs;

  // 选中的门店
  var selectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;

  // 选中的货币value
  var selectedCurrencyValue = "".obs;
  //endregion

  DiningTableShopListState() {
    ///Initialize variables

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
