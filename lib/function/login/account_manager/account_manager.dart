import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:get/get.dart';

import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/store/store_entity.dart';
import '../../../model/user/user_info_entity.dart';
import '../../../router/app_routes.dart';
import '../../../utils/date_util.dart';
import '../../../utils/utils.dart';

enum CompareDateRangeType {
  yesterday,
  lastWeek,
  lastMonth,
  lastYear,
}

class RSAccountManager {
  /// 用户token
  static const kUserToken = 'kUserToken';

  /// 用户选中的品牌
  static const kUserBrands = 'kUserBrands';

  /// 用户选中的货币
  static const kUserCurrency = 'kUserCurrency';

  /// 用户选中的分组类型
  static const kUserGroupType = 'kUserGroupType';

  /// 工厂方法构造函数 - 通过UserModel()获取对象1
  factory RSAccountManager() => _getInstance();

  /// instance的getter方法 - 通过UserModel.instance获取对象2
  static RSAccountManager get instance => _getInstance();

  /// 静态变量_instance，存储唯一对象
  static RSAccountManager? _instance;

  /// 获取唯一对象
  static RSAccountManager _getInstance() {
    _instance ??= RSAccountManager._internal();
    return _instance!;
  }

  /// 初始化...
  RSAccountManager._internal() {
    //初始化其他操作...
  }

  /// 门店信息（新）
  StoreEntity? storeEntity;

  /// 选中门店（新）
  List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops = [];

  /// 设置当前选中品牌（新）
  void setSelectedStoreBrands() {
    var brandIdValue = SpUtil.getStringList(kUserBrands);

    if (brandIdValue != null && brandIdValue.isNotEmpty) {
      // 根据缓存查找是否已有选中的品牌
      for (var local in brandIdValue) {
        storeEntity?.brands?.forEach((brand) {
          if (brand.brandId == local) {
            brand.isSelected = true;
          }
        });
      }
    } else {
      // 默认全选品牌
      storeEntity?.brands?.forEach((brand) {
        brand.isSelected = true;
      });
    }
  }

  /// 根据门店id查找门店名字（新）
  String findShopName(String? shopId) {
    if (shopId == null) {
      return '-';
    }
    var shop = storeEntity?.shops?.firstWhere((element) => shopId == element.shopId);

    return shop?.shopName ?? '-';
  }

  /// 根据品牌、货币查找所有门店（新）
  List<StoreCurrencyShopsGroupShopsBrandShops> findAllShopsBaseBrandAndCurrency() {
    List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops = [];

    // 货币
    var currency = getCurrency();
    // 所有选中品牌的分组
    var groupShops = getAllSelectedBrandsGroup(storeEntity);

    // 将找到的门店都加入选中门店数组
    for (var group in groupShops) {
      if (group.currency?.value != null && group.currency?.value == currency?.value) {
        List<StoreCurrencyShopsGroupShops>? groupShops = [];

        // 判断是哪个分组
        switch (storeEntity?.selectedGroupType) {
          case StoreSelectedGroupType.allType:
            groupShops = group.allShops;
          case StoreSelectedGroupType.groupType:
            groupShops = group.groupShops;
          default:
            groupShops = group.allShops;
        }

        if (groupShops != null) {
          for (var element in groupShops) {
            element.brandShops?.forEach((shop) {
              shop.isSelected = true;
              int index = selectedShops.indexWhere((item) => item.shopId == shop.shopId);
              if (index == -1) {
                selectedShops.add(shop);
              }
            });
          }
        }
      }
    }

    return selectedShops;
  }

  /// 获取已选中品牌下的门店分组（新）
  List<StoreCurrencyShops> getAllSelectedBrandsGroup(StoreEntity? storeEntity,
      {StoreSelectedGroupType? selectedGroupType}) {
    List<StoreCurrencyShops> filteredCurrencyShops = [];

    // 找出选中的品牌
    List<String> selectedBrandIds =
        storeEntity?.brands?.where((element) => element.isSelected).map((element) => element.brandId ?? '').toList() ??
            [];

    storeEntity?.currencyShops?.forEach((currencyShop) {
      List<StoreCurrencyShopsGroupShops> filteredGroupShops = [];

      List<StoreCurrencyShopsGroupShops>? groupShops = [];

      // 判断是哪个分组
      var groupType = selectedGroupType ?? storeEntity.selectedGroupType;
      switch (groupType) {
        case StoreSelectedGroupType.allType:
          groupShops = currencyShop.allShops;
        case StoreSelectedGroupType.groupType:
          groupShops = currencyShop.groupShops;
        default:
          groupShops = currencyShop.allShops;
      }

      groupShops?.forEach((groupShop) {
        List<StoreCurrencyShopsGroupShopsBrandShops>? filteredBrandShops;
        // 判断是否品牌全选，如果全选则不过滤门店（暂时以此方式处理线上门店）
        if (_getBrandsIsAllSelected(storeEntity)) {
          filteredBrandShops = groupShop.brandShops;
        } else {
          filteredBrandShops =
              groupShop.brandShops?.where((brandShop) => selectedBrandIds.contains(brandShop.brandId)).toList();
        }

        if (filteredBrandShops != null && filteredBrandShops.isNotEmpty) {
          var model = StoreCurrencyShopsGroupShops();
          model.shopGroup = groupShop.shopGroup;
          model.brandShops = filteredBrandShops;
          filteredGroupShops.add(model);
        }
      });

      if (filteredGroupShops.isNotEmpty) {
        var model = StoreCurrencyShops();
        model.currency = currencyShop.currency;

        // 判断是哪个分组
        var groupType = selectedGroupType ?? storeEntity.selectedGroupType;
        switch (groupType) {
          case StoreSelectedGroupType.allType:
            model.allShops = filteredGroupShops;
          case StoreSelectedGroupType.groupType:
            model.groupShops = filteredGroupShops;
          default:
            model.allShops = filteredGroupShops;
        }

        filteredCurrencyShops.add(model);
      }
    });

    return filteredCurrencyShops;
  }

  /// 获取用户选中的分组类型
  StoreSelectedGroupType getSelectedGroupType() {
    var groupType = SpUtil.getString(kUserGroupType);
    if (groupType != null && groupType.isNotEmpty) {
      return RSUtils.enumFromString(StoreSelectedGroupType.values, groupType) ?? StoreSelectedGroupType.allType;
    } else {
      return StoreSelectedGroupType.allType;
    }
  }

  /// 保存用户选中的分组类型
  Future<void> saveSelectedGroupType(StoreSelectedGroupType groupType) async {
    await SpUtil.putString(kUserGroupType, RSUtils.enumToString(groupType));
  }

  /// 保存选中的货币
  Future<void> saveSelectedCurrency(String currencyValue) async {
    await SpUtil.putString(kUserCurrency, currencyValue);
  }

  /// 保存选中的品牌
  Future<void> saveSelectedBrands(List<String> brandIds) async {
    await SpUtil.putStringList(kUserBrands, brandIds);
  }

  /// 所有门店选择状态置为false
  void allSelectedShopsFalse(StoreEntity? storeEntity) {
    storeEntity?.currencyShops?.forEach((currencyShop) {
      _setAllShopsSelectedFalse(currencyShop.allShops);
      _setAllShopsSelectedFalse(currencyShop.groupShops);
    });
  }

  /// 所有门店选择状态置为false
  void _setAllShopsSelectedFalse(List<StoreCurrencyShopsGroupShops>? shops) {
    shops?.forEach((groupShop) {
      groupShop.brandShops?.forEach((shop) {
        shop.isSelected = false;
      });
    });
  }

  /// 判断是否品牌全选，如果全选则不过滤门店（暂时以此方式处理线上门店）
  bool _getBrandsIsAllSelected(StoreEntity storeEntity) {
    bool isAllSelected = true;
    storeEntity.brands?.forEach((element) {
      if (!element.isSelected) {
        isAllSelected = false;
      }
    });
    return isAllSelected;
  }

  /// 获取所有货币符号对象（新）
  List<StoreCurrencyShopsCurrency> getAllCurrency() {
    List<StoreCurrencyShopsCurrency> shopCurrency = [];
    storeEntity?.currencyShops?.forEach((element) {
      if (element.currency != null) {
        shopCurrency.add(element.currency!);
      }
    });

    return shopCurrency;
  }

  /// 当前货币币种（新）
  StoreCurrencyShopsCurrency? getCurrency() {
    StoreCurrencyShopsCurrency? locationCurrency;
    var tmp = getAllCurrency();
    if (tmp.isNotEmpty) {
      locationCurrency = tmp.first;
    }

    var currencyValue = SpUtil.getString(kUserCurrency);

    storeEntity?.currencyShops?.forEach((element) {
      if (element.currency?.value == currencyValue) {
        locationCurrency = element.currency;
      }
    });

    if (getAllCurrency().isNotEmpty) {
      locationCurrency ??= getAllCurrency().first;
    }

    return locationCurrency;
  }

  //region 时间&对比相关
  /// 时间范围 —— 私有字段["2024-03-04", "2024-03-07"],
  List<DateTime> _timeRange = [];

  /// 时间范围（数组格式）—— get
  List<DateTime> get timeRange {
    if (_timeRange.isEmpty) {
      // var startTime = RSDateUtil.timeToString(DateTime.now());
      var time = DateTime.now();
      return [time, time];
    } else {
      return _timeRange;
    }
  }

  /// 时间范围（数组格式）—— set
  set timeRange(List<DateTime> range) {
    _timeRange = range;
  }

  /// 时间范围（字符串格式）
  String get timeRangeString {
    return RSDateUtil.formatTimesString(RSDateUtil.dateRangeToListString(timeRange));
  }

  /// 对比——昨天
  List<DateTime> dayCompareDate = [];

  List<String> get getDayCompareDate {
    return dayCompareDate.map((element) => RSDateUtil.timeToString(element)).toList();
  }

  /// 对比——上周
  List<DateTime> weekCompareDate = [];

  List<String> get getWeekCompareDate {
    return weekCompareDate.map((element) => RSDateUtil.timeToString(element)).toList();
  }

  /// 对比——上月
  List<DateTime> monthCompareDate = [];

  List<String> get getMonthCompareDate {
    return monthCompareDate.map((element) => RSDateUtil.timeToString(element)).toList();
  }

  /// 对比——去年
  List<DateTime> yearCompareDate = [];

  List<String> get getYearCompareDate {
    return yearCompareDate.map((element) => RSDateUtil.timeToString(element)).toList();
  }

  /// 对比开关Key
  static const kUserCompareDateRangeTypeList = 'kUserCompareDateRangeTypeList';

  /// 保存对比时间范围类型
  Future<void> saveCompareDateRangeType(List<CompareDateRangeType>? compareDateRangeTypes) async {
    List<String> tmpList = [];

    compareDateRangeTypes?.forEach((element) {
      tmpList.add(RSUtils.enumToString(element));
    });

    if (tmpList.isNotEmpty) {
      await SpUtil.putStringList(kUserCompareDateRangeTypeList, tmpList);
    } else {
      await SpUtil.remove(kUserCompareDateRangeTypeList);
    }
  }

  /// 获取对比时间范围类型——[Enum]
  List<CompareDateRangeType> getCompareDateRangeTypeStrings() {
    var compareDateRangeTypeStrings = SpUtil.getStringList(kUserCompareDateRangeTypeList);
    var tmpTypes = _getCompareDateRangeEnumTypes(compareDateRangeTypeStrings,
        openCompare: compareDateRangeTypeStrings != null && compareDateRangeTypeStrings.isNotEmpty);
    return tmpTypes;
  }

  /// 获取对比时间范围类型——[Enum]
  List<CompareDateRangeType> _getCompareDateRangeEnumTypes(List<String>? compareDateRangeTypeStrings,
      {bool openCompare = true}) {
    if (openCompare) {
      List<CompareDateRangeType> tmpDateRangeEnumTypes = [];
      compareDateRangeTypeStrings?.forEach((element) {
        var type = RSUtils.enumFromString(CompareDateRangeType.values, element);

        if (type != null) {
          tmpDateRangeEnumTypes.add(type);
        }
      });

      return tmpDateRangeEnumTypes;
    } else {
      return [];
    }
  }

  //endregion

  UserInfoEntity? get userInfoEntity {
    Map<String, dynamic>? object = SpUtil.getObject(kUserToken)?.cast<String, dynamic>();
    if (object != null) {
      return UserInfoEntity.fromJson(object);
    }

    return null;
  }

  /// 更新用户信息
  Future<void> updateUserInfo(UserInfoEntity userInfoEntity) async {
    UserInfoEntity? localUserInfo = RSAccountManager().userInfoEntity;

    if (localUserInfo != null) {
      userInfoEntity.accessToken ??= localUserInfo.accessToken;
      userInfoEntity.email ??= localUserInfo.email;
      userInfoEntity.phone ??= localUserInfo.phone;
      userInfoEntity.phoneAreaCode ??= localUserInfo.phoneAreaCode;
    }
    await loginSuccess(userInfoEntity);
    logger.d("更新用户信息，userInfoEntity:${userInfoEntity.toJson()}", StackTrace.current);
  }

  /// 登录成功
  Future<void> loginSuccess(UserInfoEntity? userInfoEntity) async {
    debugPrint("Token：${userInfoEntity?.accessToken}");
    if (userInfoEntity != null) {
      SpUtil.putObject(kUserToken, userInfoEntity.toJson());
    }
    logger.d("登录成功，userInfoEntity:${userInfoEntity?.toJson()}", StackTrace.current);
  }

  /// 登出
  Future<void> logout() async {
    if (Get.currentRoute != AppRoutes.launchPage) {
      await SpUtil.remove(kUserToken);
      cleanData();
      Get.offAllNamed(AppRoutes.launchPage);
    }
  }

  /// 清空数据
  void cleanData() {
    /// 时间范围（数组格式）
    _timeRange = [];

    /// 门店信息
    storeEntity = null;

    /// 清空选中门店
    selectedShops.clear();

    /// 删除缓存——货币符号
    SpUtil.remove(kUserCurrency);

    /// 删除缓存——品牌
    SpUtil.remove(kUserBrands);

    /// 删除缓存——用户token
    SpUtil.remove(kUserToken);

    /// 删除缓存——对比时间范围类型
    SpUtil.remove(kUserCompareDateRangeTypeList);

    logger.d("退出登录，清空数据", StackTrace.current);
  }
}
