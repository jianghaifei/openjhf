import 'package:flutter/material.dart';
import 'package:flutter_report_project/model/store/store_entity.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../popup_widget/drop_down_popup/rs_popup.dart';
import 'store_brand_logic.dart';

typedef BrandsCallback = Function(List<StoreBrands> brands);

class StoreBrandPage extends StatefulWidget {
  const StoreBrandPage({
    super.key,
    required this.storeBrands,
    required this.applyCallback,
  });

  final List<StoreBrands> storeBrands;
  final BrandsCallback applyCallback;

  @override
  State<StoreBrandPage> createState() => _StoreBrandPageState();
}

class _StoreBrandPageState extends State<StoreBrandPage> {
  final logic = Get.put(StoreBrandLogic());
  final state = Get.find<StoreBrandLogic>().state;

  @override
  void dispose() {
    Get.delete<StoreBrandLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// 深拷贝——店铺
    state.originalBrands.value = logic.copyBrandsData(widget.storeBrands);
    state.displayBrands.value = logic.copyBrandsData(widget.storeBrands);
  }

  @override
  Widget build(BuildContext context) {
    return _createDropDownWidget();
  }

  Widget _createDropDownWidget() {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createBrandListItemWidget(-1),
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.displayBrands.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _createBrandListItemWidget(index);
                  })),
          _createFooterWidget(),
        ],
      );
    });
  }

  Widget _createBrandListItemWidget(int index) {
    bool selectValue = false;
    if (index == -1) {
      selectValue = state.ifAllSelected.value;
    } else {
      selectValue = state.displayBrands[index].isSelected;
    }

    return InkWell(
      onTap: () {
        setState(() {
          if (index == -1) {
            logic.selectedChangeValue(null, isAllSelected: true);
          } else {
            logic.selectedChangeValue(state.displayBrands[index]);
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image(
                  image: AssetImage(selectValue ? Assets.imageCheckBoxSel : Assets.imageCheckBox),
                  gaplessPlayback: true,
                  color: selectValue ? RSColor.color_0xFF5C57E6 : RSColor.color_0xFFDCDCDC,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      index == -1
                          ? "${S.current.rs_location_select_all}(${state.displayBrands.length})"
                          : state.displayBrands[index].brandName ?? '*',
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 0,
            indent: 44,
          ),
        ],
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
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: state.selectedBrands.length.toString(),
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: S.current.rs_location_selected,
                      style: TextStyle(
                        color: RSColor.color_0x40000000,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (state.selectedBrands.isNotEmpty) {
                      widget.applyCallback.call(state.displayBrands);
                      RSPopup.pop(Get.context!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFF5C57E6
                          .withOpacity((state.selectedBrands.isEmpty && !state.ifAllSelected.value) ? 0.6 : 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      S.current.rs_confirm,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
      ],
    );
  }
}
