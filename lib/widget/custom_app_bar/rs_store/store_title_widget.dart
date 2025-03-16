import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/rs_store_view.dart';
import 'package:flutter_report_project/widget/custom_app_bar/rs_store/store_subview_group/store_subview_group_view.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/store/store_entity.dart';

/// 门店名称视图
class StoreTitleWidget extends StatefulWidget {
  const StoreTitleWidget(
      {super.key,
      required this.selectedShops,
      this.storeEntity,
      this.selectedCurrencyValue,
      required this.applyCallback});

  final List<StoreCurrencyShopsGroupShopsBrandShops> selectedShops;
  final StoreEntity? storeEntity;
  final String? selectedCurrencyValue;
  final SelectedShopApplyCallback applyCallback;

  @override
  State<StoreTitleWidget> createState() => _StoreTitleWidgetState();
}

class _StoreTitleWidgetState extends State<StoreTitleWidget> {
  var storeTitle = "-";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedShops.length == 1) {
      storeTitle = RSAccountManager().findShopName(widget.selectedShops.first.shopId);
    } else {
      storeTitle = "${widget.selectedShops.length} ${S.current.rs_location}";
    }

    return Expanded(
      child: InkWell(
        onTap: clickAction,
        child: Row(
          children: [
            Flexible(
              child: Text(
                storeTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (storeTitle.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Image(
                  image: AssetImage(Assets.imageArrowDropDown),
                  width: 10,
                  fit: BoxFit.fitWidth,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void clickAction() {
    if (widget.storeEntity == null || widget.storeEntity?.shops == null || widget.storeEntity!.shops!.isEmpty) {
      return;
    }
    Get.to(() => RSStorePage(
          storeEntity: widget.storeEntity,
          selectedShops: widget.selectedShops,
          selectedCurrencyValue: widget.selectedCurrencyValue,
          applyCallback: (
            List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
            List<String> allSelectedBrandIds,
            String currencyValue,
            StoreSelectedGroupType groupType,
          ) {
            // 赋值title
            setState(() {
              if (allSelectedShops.length == 1) {
                storeTitle = RSAccountManager().findShopName(allSelectedShops.first.shopId);
              } else {
                storeTitle = "${RSAccountManager().selectedShops.length} ${S.current.rs_location}";
              }
            });

            widget.applyCallback(allSelectedShops, allSelectedBrandIds, currencyValue, groupType);
          },
        ));
  }
}
