import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/model/store/store_entity.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/store_brand/store_brand_view.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/store_subview_group/store_subview_group_view.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'rs_store_logic.dart';

class RSStorePage extends StatefulWidget {
  const RSStorePage({
    super.key,
    required this.storeEntity,
    required this.selectedShops,
    required this.selectedCurrencyValue,
    required this.applyCallback,
  });

  final StoreEntity? storeEntity;
  final List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops;
  final String? selectedCurrencyValue;
  final SelectedShopApplyCallback applyCallback;

  @override
  State<RSStorePage> createState() => _RSStorePageState();
}

class _RSStorePageState extends State<RSStorePage> {
  final logic = Get.put(RSStoreLogic());
  final state = Get.find<RSStoreLogic>().state;

  @override
  void dispose() {
    Get.delete<RSStoreLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 初始化数据
    logic.initData(widget.storeEntity, widget.selectedShops);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Obx(() {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: RSAppBar(
            title: S.current.rs_select_location,
            centerTitle: false,
            titleSpacing: 0,
            actions: [_createAppBarRightWidget()],
          ),
          body: _createTabControllerWidget(),
        );
      }),
    );
  }

  Widget _createAppBarRightWidget() {
    return Container(
      constraints: BoxConstraints(maxWidth: 1.sw * 0.4),
      padding: const EdgeInsets.only(right: 16),
      child: ExpandableTextButtonPage(
          textWidget: Flexible(
            child: Text(
              logic.getAllSelectedBrandName(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          iconWidget: const Image(
            image: AssetImage(Assets.imageArrowDropDown),
            fit: BoxFit.fitWidth,
          ),
          onPressed: () async {
            await RSPopup.show(
              Get.context!,
              RSCustomDropDownPage(
                paddingTop: ScreenUtil().statusBarHeight + AppBar().preferredSize.height,
                customWidget: StoreBrandPage(
                    storeBrands: state.storeEntity.value.brands ?? [],
                    applyCallback: (List<StoreBrands> brands) {
                      setState(() {
                        state.selectedBrands.value = brands;
                        state.storeEntity.update((val) {
                          val?.brands = state.selectedBrands;
                        });
                      });
                    }),
                maxHeight: 1.sh * 0.5,
              ),
              offsetLT: Offset(0, ScreenUtil().statusBarHeight + AppBar().preferredSize.height),
            );
          }),
    );
  }

  Widget _createTabControllerWidget() {
    return Column(
      children: [
        RSTabControllerWidgetPage(
            tabs: state.tabs,
            initialIndex: state.storeEntity.value.selectedGroupType == StoreSelectedGroupType.allType ? 0 : 1,
            tabBarViews: List.generate(state.tabs.length, (index) {
              return StoreSubviewGroupPage(
                storeEntity: state.storeEntity.value,
                groupType: index == 0 ? StoreSelectedGroupType.allType : StoreSelectedGroupType.groupType,
                selectedShops: state.selectedShops,
                selectedCurrencyValue: widget.selectedCurrencyValue,
                applyCallback: (
                  List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
                  List<String> allSelectedBrandIds,
                  String currencyValue,
                  StoreSelectedGroupType groupType,
                ) {
                  widget.applyCallback.call(allSelectedShops, allSelectedBrandIds, currencyValue, groupType);
                  Get.back();
                },
              );
            })),
      ],
    );
  }
}
