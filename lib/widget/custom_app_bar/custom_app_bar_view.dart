import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/store_title_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';
import '../../config/rs_locale.dart';
import '../../function/login/account_manager/account_manager.dart';
import '../../generated/l10n.dart';
import '../../model/business_topic/business_topic_type_enum.dart';
import '../../model/store/store_entity.dart';
import '../../utils/logger/logger_helper.dart';
import 'custom_app_bar_logic.dart';
import 'custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import 'custom_date_tool_widget/custom_date_tool_widget_view.dart';

class CustomAppBarPage extends StatelessWidget {
  CustomAppBarPage({
    super.key,
    required this.selectedTimeRangeCallBack,
    required this.refreshCallBack,
    required this.selectedShops,
  });

  final List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops;
  final DateTimeRangesCallback selectedTimeRangeCallBack;
  final VoidCallback refreshCallBack;

  final logic = Get.put(CustomAppBarLogic());
  final state = Get.find<CustomAppBarLogic>().state;

  @override
  Widget build(BuildContext context) {
    return _createBody();
  }

  Widget _createBody() {
    return Container(
      width: 1.sw,
      height: ScreenUtil().statusBarHeight + 95,
      padding: EdgeInsets.only(
        top: ScreenUtil().statusBarHeight,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StoreTitleWidget(
                selectedShops: selectedShops,
                storeEntity: StoreEntity.fromJson(RSAccountManager().storeEntity?.toJson() ?? StoreEntity().toJson()),
                selectedCurrencyValue: RSAccountManager().getCurrency()?.value,
                applyCallback: (
                  List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
                  List<String> allSelectedBrandIds,
                  String currencyValue,
                  StoreSelectedGroupType groupType,
                ) async {
                  logger.d("RSStorePage-refreshCallBack", StackTrace.current);
                  // 重置所有门店的选中状态
                  RSAccountManager().allSelectedShopsFalse(RSAccountManager().storeEntity);

                  List<StoreCurrencyShopsGroupShops>? groupShops;
                  switch (groupType) {
                    case StoreSelectedGroupType.allType:
                      groupShops = RSAccountManager()
                          .storeEntity
                          ?.currencyShops
                          ?.firstWhere((element) => element.currency?.value == currencyValue)
                          .allShops;
                    case StoreSelectedGroupType.groupType:
                      groupShops = RSAccountManager()
                          .storeEntity
                          ?.currencyShops
                          ?.firstWhere((element) => element.currency?.value == currencyValue)
                          .groupShops;
                  }
                  // 赋值选中的分组类型：全部门店 or 分组门店
                  RSAccountManager().storeEntity?.selectedGroupType = groupType;

                  // 循环赋值
                  for (var selectedShop in allSelectedShops) {
                    groupShops?.forEach((groupShop) {
                      groupShop.brandShops?.forEach((shop) {
                        if (selectedShop.shopId == shop.shopId) {
                          shop.isSelected = true;
                        }
                      });
                    });
                  }
                  // 选中的门店
                  RSAccountManager().selectedShops = allSelectedShops;

                  // 保存用户选中的分组类型
                  await RSAccountManager().saveSelectedGroupType(groupType);

                  // 保存选中的货币
                  await RSAccountManager().saveSelectedCurrency(currencyValue);

                  // 保存选中的品牌
                  await RSAccountManager().saveSelectedBrands(allSelectedBrandIds);

                  refreshCallBack.call();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: InkWell(
                  onTap: () {
                    logic.jumpStoresPKPage();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFF5C57E6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      RSLocale().locale?.languageCode == 'zh' ? '${S.current.rs_store}PK' : '${S.current.rs_store} PK',
                      style: const TextStyle(
                        color: RSColor.color_0xFFFFFFFF,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const Spacer(),
          CustomDateToolWidgetPage(
            key: const ObjectKey(CustomAppBarPage),
            customDateToolEnum: state.customDateToolEnum,
            dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                List<List<DateTime>>? compareDateTimeRanges,
                List<DateTime> displayTime,
                CustomDateToolEnum customDateToolEnum) async {
              state.compareDateRangeTypes = compareDateRangeTypes;
              state.compareDateTimeRanges = compareDateTimeRanges;
              state.customDateToolEnum = customDateToolEnum;

              await RSAccountManager().saveCompareDateRangeType(compareDateRangeTypes);

              selectedTimeRangeCallBack.call(
                  state.compareDateRangeTypes, state.compareDateTimeRanges, displayTime, customDateToolEnum);
            },
          ),
        ],
      ),
    );
  }
}
