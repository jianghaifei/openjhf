import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../model/store/store_entity.dart';
import 'rs_store_state.dart';

class RSStoreLogic extends GetxController {
  final RSStoreState state = RSStoreState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 初始化数据
  void initData(StoreEntity? storeEntity, List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops) {
    // 赋值
    if (storeEntity != null) {
      state.storeEntity.value = storeEntity;
      state.selectedShops.value = selectedShops;

      state.originalBrands =
          storeEntity.brands?.map((element) => StoreBrands.fromJson(element.toJson())).toList() ?? [];

      state.selectedBrands.value = storeEntity.brands?.where((element) => element.isSelected).toList() ?? [];
    } else {
      Get.back();
      EasyLoading.showError("门店信息获取失败");
    }
  }

  /// 获取所有选定的品牌名称
  String getAllSelectedBrandName() {
    var allSelectedBrands = state.selectedBrands.where((element) => element.isSelected).toList();
    if (allSelectedBrands.length == state.originalBrands.length) {
      return S.current.rs_all_brands;
    } else {
      return allSelectedBrands.map((element) => element.brandName).join(',');
    }
  }
}
