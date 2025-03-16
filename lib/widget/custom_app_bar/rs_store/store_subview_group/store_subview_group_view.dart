import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/store_subview_group/store_subview_group_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/store/store_entity.dart';
import '../../../rs_custom_text_field.dart';
import 'store_subview_group_logic.dart';

typedef SelectedShopApplyCallback = Function(
  List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
  List<String> allSelectedBrandIds,
  String currencyValue,
  StoreSelectedGroupType groupType,
);

class StoreSubviewGroupPage extends StatefulWidget {
  const StoreSubviewGroupPage({
    super.key,
    required this.groupType,
    required this.storeEntity,
    required this.selectedShops,
    required this.selectedCurrencyValue,
    required this.applyCallback,
  });

  final StoreSelectedGroupType groupType;
  final StoreEntity storeEntity;
  final List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops;
  final String? selectedCurrencyValue;
  final SelectedShopApplyCallback applyCallback;

  @override
  State<StoreSubviewGroupPage> createState() => _StoreSubviewGroupPageState();
}

class _StoreSubviewGroupPageState extends State<StoreSubviewGroupPage> with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  StoreSubviewGroupLogic get logic => Get.find<StoreSubviewGroupLogic>(tag: tag);

  StoreSubviewGroupState get state => Get.find<StoreSubviewGroupLogic>(tag: tag).state;

  @override
  bool get wantKeepAlive => true;

  // final logic = Get.put(StoreSubviewGroupLogic());
  // final state = Get.find<StoreSubviewGroupLogic>().state;

  @override
  void dispose() {
    Get.delete<StoreSubviewGroupLogic>();
    super.dispose();
  }

  @override
  void initState() {
    Get.put(StoreSubviewGroupLogic(), tag: tag);

    super.initState();

    state.groupType = widget.groupType;
  }

  void loadData() {
    // 赋值
    // state.originalStoreEntity = StoreEntity.fromJson(widget.storeEntity.toJson());
    state.displayStoreEntity.value = StoreEntity.fromJson(widget.storeEntity.toJson());
    state.displayStoreEntity.value.currencyShops = RSAccountManager()
        .getAllSelectedBrandsGroup(state.displayStoreEntity.value, selectedGroupType: state.groupType);

    state.displayStoreCurrencyShops.value = RSAccountManager()
        .getAllSelectedBrandsGroup(state.displayStoreEntity.value, selectedGroupType: state.groupType);
    state.initData(widget.selectedCurrencyValue);
    logic.defaultSelected(switchCurrency: widget.selectedShops.isEmpty);
    logic.realTimeDetectionIsSelectAll();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loadData();

    return _createBodyWidget();
  }

  Widget _createBodyWidget() {
    return Obx(() {
      var groupShops = logic.getCurrentGroupShops(state.displayStoreCurrencyShops);

      List<StoreCurrencyShopsGroupShopsBrandShops>? brandShops = [];
      if (groupShops != null && state.selectedLeftListIndex.value < groupShops.length) {
        brandShops = groupShops[state.selectedLeftListIndex.value].brandShops;
      }
      return Column(
        children: [
          _createCurrencyListWidget(),
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Container(
                    color: RSColor.color_0xFFF3F3F3,
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: groupShops?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return _createLeftListItemWidget(index);
                        }),
                  ),
                ),
                SizedBox(
                  width: 1.sw - 100,
                  child: Column(
                    children: [
                      _createSearchWidget(),
                      if (state.showAllSelected.value && (brandShops != null && brandShops.isNotEmpty))
                        _createRightListItemWidget(-1),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: brandShops?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return _createRightListItemWidget(index);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _createFooterWidget(),
        ],
      );
    });
  }

  Widget _createSearchWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: RSCustomTextField(
        textFieldController: state.searchTextFieldController.value,
        hintText: S.current.rs_location_search_hint,
        onChanged: logic.performSearch,
      ),
    );
  }

  Widget _createLeftListItemWidget(int index) {
    bool isCurrent = state.selectedLeftListIndex.value == index;

    // bool isBefore = index == state.selectedLeftListIndex.value - 1;
    // bool isAfter = index == state.selectedLeftListIndex.value + 1;

    return InkWell(
      onTap: () {
        if (state.selectedLeftListIndex.value != index) {
          state.selectedLeftListIndex.value = index;

          // 清除搜索条件
          logic.performSearch('', cleanQuery: true);
          state.searchTextFieldController.value.text = '';

          logic.realTimeDetectionIsSelectAll();
        }
      },
      child: Container(
        color: RSColor.color_0xFFFFFFFF,
        child: Row(
          children: [
            if (isCurrent)
              Container(
                width: 3,
                height: 14,
                decoration: ShapeDecoration(
                  color: RSColor.color_0xFF5C57E6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: isCurrent ? 13 : 16, top: 16, right: 16, bottom: 16),
                alignment: Alignment.centerLeft,
                color: isCurrent ? RSColor.color_0xFFFFFFFF : RSColor.color_0xFFF3F3F3,
                // decoration: BoxDecoration(
                //   color: isCurrent ? RSColor.color_0xFFFFFFFF : RSColor.color_0xFFF3F3F3,
                //   borderRadius: BorderRadius.only(
                //     bottomRight: Radius.circular(isBefore ? 9.r : 0),
                //     topRight: Radius.circular(isAfter ? 9.r : 0),
                //   ),
                // ),
                child: Text(
                  logic.getCurrentGroupShops(state.displayStoreCurrencyShops)?[index].shopGroup?.shopGroupName ?? '*',
                  style: TextStyle(
                    color: isCurrent ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createRightListItemWidget(int index) {
    var groupShops = logic.getCurrentGroupShops(state.displayStoreCurrencyShops);

    var shops = groupShops?[state.selectedLeftListIndex.value].brandShops;

    bool selectValue = false;
    bool editableValue = true;
    if (index == -1) {
      selectValue = groupShops?[state.selectedLeftListIndex.value].isAllSelected ?? false;
    } else {
      selectValue = shops?[index].isSelected ?? false;
      editableValue = shops?[index].isEditable ?? true;
    }

    return InkWell(
      onTap: () {
        if (!editableValue) {
          return;
        }
        if (index == -1) {
          logic.selectedChangeValue(null, isAllSelected: true);
        } else {
          logic.selectedChangeValue(shops?[index]);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image(
                  image: AssetImage(selectValue ? Assets.imageCheckBoxSel : Assets.imageCheckBox),
                  gaplessPlayback: true,
                  color: selectValue
                      ? RSColor.color_0xFF5C57E6.withOpacity(editableValue ? 1 : 0.2)
                      : RSColor.color_0x26000000.withOpacity(editableValue ? 0.26 : 0.026),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      index == -1
                          ? "${S.current.rs_location_select_all}(${shops?.where((e) => e.isEditable).toList().length ?? 0})"
                          : "${RSAccountManager().findShopName(shops?[index].shopId)}${kDebugMode ? '(${shops?[index].shopId})' : ''}",
                      style: TextStyle(
                        color: RSColor.color_0x90000000.withOpacity(editableValue ? 0.9 : 0.2),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 0,
            indent: 44,
          ),
        ],
      ),
    );
  }

  Widget _createCurrencyListWidget() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        itemCount: state.displayStoreCurrencyShops.length,
        itemBuilder: (BuildContext context, int index) {
          return _currencyItems(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 8,
          );
        },
      ),
    );
  }

  Widget _currencyItems(int index) {
    bool isCurrent = state.selectedCurrencyIndex.value == index;

    var model = state.displayStoreCurrencyShops[index].currency;
    String currency = "${model?.symbol}(${model?.name})";

    return InkWell(
      onTap: () {
        if (state.selectedCurrencyIndex.value != index) {
          state.selectedCurrencyIndex.value = index;

          // 重置下标
          state.selectedLeftListIndex.value = 0;

          // 清除搜索条件
          logic.performSearch('', cleanQuery: true);
          state.searchTextFieldController.value.text = '';

          // logic.defaultSelected(switchCurrency: true);
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: ShapeDecoration(
          color: isCurrent ? RSColor.color_0xFF5C57E6.withOpacity(0.1) : RSColor.color_0xFFF3F3F3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          currency,
          style: TextStyle(
            color: isCurrent ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${state.allSelectedShops.length}",
                      style: const TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: S.current.rs_location_selected,
                      style: const TextStyle(
                        color: RSColor.color_0x40000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (state.allSelectedShops.isNotEmpty) {
                      // await logic.confirmAction();

                      // 保存选中的品牌
                      var allSelectedBrands = state.displayStoreEntity.value.brands
                              ?.where((brand) => brand.isSelected)
                              .map((brand) => brand.brandId ?? '')
                              .toList() ??
                          [];

                      // 保存选中的货币
                      var currency =
                          state.displayStoreCurrencyShops[state.selectedCurrencyIndex.value].currency?.value ?? "";

                      widget.applyCallback.call(state.allSelectedShops, allSelectedBrands, currency, state.groupType);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFF5C57E6.withOpacity((state.allSelectedShops.isEmpty) ? 0.6 : 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      S.current.rs_confirm,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: RSColor.color_0xFFFFFFFF,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
        )
      ],
    );
  }
}
