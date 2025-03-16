import 'package:get/get.dart';

import '../../../../model/store/store_entity.dart';

class StoreBrandState {
  /// 原始品牌列表
  var originalBrands = <StoreBrands>[].obs;

  /// 展示用品牌列表
  var displayBrands = <StoreBrands>[].obs;

  /// 选中的品牌
  var selectedBrands = <StoreBrands>[].obs;

  /// 全选
  var ifAllSelected = false.obs;

  StoreBrandState() {
    ///Initialize variables
  }
}
