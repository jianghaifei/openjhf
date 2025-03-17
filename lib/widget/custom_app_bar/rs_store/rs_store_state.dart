import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../model/store/store_entity.dart';

class RSStoreState {
  /// tabs
  final List<String> tabs = [S.current.rs_all, S.current.rs_group];

  /// 原始数据模型
  var storeEntity = StoreEntity().obs;

  /// 选中的品牌
  var selectedBrands = <StoreBrands>[].obs;

  /// 选中的门店
  var selectedShops = <StoreCurrencyShopsGroupShopsBrandShops>[].obs;

  /// 原始品牌列表
  var originalBrands = <StoreBrands>[];

  RSStoreState() {
    ///Initialize variables
  }
}
