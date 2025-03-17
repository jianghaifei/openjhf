import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:get/get.dart';

import '../../../../model/store/store_entity.dart';
import 'store_subview_group_state.dart';

class StoreSubviewGroupLogic extends GetxController {
  final StoreSubviewGroupState state = StoreSubviewGroupState();

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

  /// 所有门店选择状态置为false
  void allSelectedShopsFalse() {
    state.allSelectedShops.clear();

    state.displayStoreEntity.value.currencyShops?.forEach((currencyShop) {
      _setAllShopsSelectedFalse(currencyShop.allShops);
      _setAllShopsSelectedFalse(currencyShop.groupShops);
    });
  }

  void _setAllShopsSelectedFalse(List<StoreCurrencyShopsGroupShops>? shops) {
    shops?.forEach((groupShop) {
      groupShop.brandShops?.forEach((shop) {
        // 如果是可编辑的，则重置
        if (shop.isEditable) {
          shop.isSelected = false;
        }
      });
    });
  }

  void selectedChangeValue(StoreCurrencyShopsGroupShopsBrandShops? shop, {bool isAllSelected = false}) {
    // 切换了货币
    if (state.selectedCurrencyIndex.value != state.recordSelectedCurrencyIndex) {
      state.recordAllSelectedShops.value = state.allSelectedShops.map((e) => e).toList();

      allSelectedShopsFalse();
      state.recordSelectedCurrencyIndex = state.selectedCurrencyIndex.value;
    }

    if (isAllSelected) {
      var groupShop = getCurrentGroupShops(state.displayStoreCurrencyShops)?[state.selectedLeftListIndex.value];

      groupShop?.isAllSelected = !groupShop.isAllSelected;

      groupShop?.brandShops?.forEach((brandShop) {
        getCurrentGroupShops(state.displayStoreCurrencyShops)?.forEach((group) {
          group.brandShops?.forEach((shop) {
            if (shop.shopId == brandShop.shopId && brandShop.isEditable) {
              shop.isSelected = groupShop.isAllSelected;
              int index = state.allSelectedShops.indexWhere((item) => item.shopId == brandShop.shopId);
              if (groupShop.isAllSelected) {
                if (index == -1) {
                  state.allSelectedShops.add(brandShop);
                }
              } else {
                if (index != -1) {
                  state.allSelectedShops.removeAt(index);
                }
              }
            }
          });
        });
      });

      realTimeDetectionIsSelectAll();
    } else {
      if (shop != null) {
        changeShopSelectedStatus(shop, !shop.isSelected);
      }
    }
  }

  /// 遍历所有店铺并修改对应店铺的选中状态
  void changeShopSelectedStatus(StoreCurrencyShopsGroupShopsBrandShops brandShop, bool selected) {
    int index = state.allSelectedShops.indexWhere((item) => item.shopId == brandShop.shopId);

    if (selected) {
      if (index == -1) {
        state.allSelectedShops.add(brandShop);
        brandShop.isSelected = true;
      }
    } else {
      if (index != -1) {
        state.allSelectedShops.removeAt(index);
        brandShop.isSelected = false;
      }
    }

    getCurrentGroupShops(state.displayStoreEntity.value.currencyShops)?.forEach((group) {
      group.brandShops?.forEach((shop) {
        if (shop.shopId == brandShop.shopId && brandShop.isEditable) {
          shop.isSelected = selected;
        }
      });
    });

    realTimeDetectionIsSelectAll();
  }

  /// 实时判断分组下门店是否全选
  void realTimeDetectionIsSelectAll() {
    var element = getCurrentGroupShops(state.displayStoreCurrencyShops)?[state.selectedLeftListIndex.value];

    bool allSelected = true;

    element?.brandShops?.forEach((shop) {
      if (!shop.isSelected) {
        allSelected = false;
      }
    });

    element?.isAllSelected = allSelected;

    if (element != null) {
      getCurrentGroupShops(state.displayStoreCurrencyShops)?[state.selectedLeftListIndex.value] = element;
    }

    update();
  }

  /// 默认选中门店
  void defaultSelected({bool switchCurrency = false}) {
    if (!switchCurrency) {
      state.allSelectedShops.clear();

      getCurrentGroupShops(state.displayStoreCurrencyShops)?.forEach((groupShop) {
        groupShop.brandShops?.forEach((shop) {
          int index = state.allSelectedShops.indexWhere((item) => item.shopId == shop.shopId);

          if (shop.isSelected && index == -1 && shop.isEditable) {
            state.allSelectedShops.add(shop);
          }
        });
      });
    }

    realTimeDetectionIsSelectAll();
  }

  /// 搜索
  void performSearch(String query, {bool cleanQuery = false}) {
    if (query.isNotEmpty) {
      state.showAllSelected.value = false;
    } else {
      state.showAllSelected.value = true;
    }

    // 根据搜索关键字过滤数据
    List<StoreCurrencyShopsGroupShopsBrandShops>? result;
    if (cleanQuery) {
      result = getCurrentGroupShops(StoreEntity.fromJson(state.displayStoreEntity.value.toJson()).currencyShops)?[
              state.selectedLeftListIndex.value]
          .brandShops;
    } else {
      result = getCurrentGroupShops(StoreEntity.fromJson(state.displayStoreEntity.value.toJson()).currencyShops)?[
              state.selectedLeftListIndex.value]
          .brandShops
          ?.where((item) =>
              item.shopId!.toLowerCase().contains(query.toLowerCase()) ||
              item.shopName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // 如果是切换货币，需要将之前选中的门店状态保留
    if (state.selectedCurrencyIndex.value == state.recordSelectedCurrencyIndex) {
      result?.forEach((element) {
        for (var selectedShop in state.allSelectedShops) {
          if (element.shopId == selectedShop.shopId && element.isEditable) {
            element.isSelected = selectedShop.isSelected;
          }
        }
      });
    }

    List<StoreCurrencyShops> tmpShops = state.displayStoreCurrencyShops.map((element) => element).toList();

    List<StoreCurrencyShopsGroupShops>? groupShops;
    switch (state.groupType) {
      case StoreSelectedGroupType.allType:
        groupShops = tmpShops[state.selectedCurrencyIndex.value].allShops;
      case StoreSelectedGroupType.groupType:
        groupShops = tmpShops[state.selectedCurrencyIndex.value].groupShops;
    }

    groupShops?[state.selectedLeftListIndex.value].brandShops = result;

    state.displayStoreCurrencyShops.value = tmpShops;

    realTimeDetectionIsSelectAll();
  }

  /// 获取当前分组下的门店——浅拷贝
  List<StoreCurrencyShopsGroupShops>? getCurrentGroupShops(List<StoreCurrencyShops>? storeCurrencyShops,
      {int? currencyIndex}) {
    if (storeCurrencyShops == null || storeCurrencyShops.isEmpty) {
      return null;
    }

    List<StoreCurrencyShopsGroupShops>? groupShops;

    switch (state.groupType) {
      case StoreSelectedGroupType.allType:
        // 全部
        groupShops = storeCurrencyShops[currencyIndex ?? state.selectedCurrencyIndex.value].allShops;

      case StoreSelectedGroupType.groupType:
        // 分组
        groupShops = storeCurrencyShops[currencyIndex ?? state.selectedCurrencyIndex.value].groupShops;
    }

    return groupShops;
  }
}
