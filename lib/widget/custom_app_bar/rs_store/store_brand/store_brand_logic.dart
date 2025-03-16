import 'package:get/get.dart';

import '../../../../model/store/store_entity.dart';
import 'store_brand_state.dart';

class StoreBrandLogic extends GetxController {
  final StoreBrandState state = StoreBrandState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    defaultSelected();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void selectedChangeValue(StoreBrands? storeBrand, {bool isAllSelected = false}) {
    if (isAllSelected) {
      state.ifAllSelected.value = !state.ifAllSelected.value;

      state.selectedBrands.clear();

      for (var element in state.displayBrands) {
        element.isSelected = state.ifAllSelected.value;

        if (element.isSelected) {
          state.selectedBrands.add(element);
        } else {
          state.selectedBrands.remove(element);
        }
      }
    } else {
      if (storeBrand != null) {
        storeBrand.isSelected = !storeBrand.isSelected;

        if (state.selectedBrands.contains(storeBrand)) {
          state.selectedBrands.remove(storeBrand);
        } else {
          state.selectedBrands.add(storeBrand);
        }
      }
    }

    realTimeDetectionIsSelectAll();
  }

  /// 实时判断是否全选
  void realTimeDetectionIsSelectAll() {
    if (state.displayBrands.isNotEmpty) {
      state.ifAllSelected.value = state.selectedBrands.length == state.originalBrands.length;
    }
  }

  /// 设置默认选中的品牌
  void defaultSelected() {
    var brands = state.originalBrands.where((element) => element.isSelected).toList();

    if (brands.isNotEmpty) {
      // 防止脏数据
      state.selectedBrands.clear();

      // 更新数据源
      for (var element in state.displayBrands) {
        for (var shop in brands) {
          if (element.brandId == shop.brandId) {
            element.isSelected = true;
            state.selectedBrands.add(element);
          }
        }
      }
    }

    realTimeDetectionIsSelectAll();
  }

  List<StoreBrands> copyBrandsData(List<StoreBrands> brands) {
    return brands.map((element) => StoreBrands.fromJson(element.toJson())).toList();
  }
}
