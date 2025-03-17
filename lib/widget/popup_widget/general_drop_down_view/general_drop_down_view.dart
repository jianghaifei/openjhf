import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/l10n.dart';
import '../../bottom_button_widget/rs_bottom_button_widget.dart';
import '../../rs_custom_grid.dart';
import '../drop_down_popup/rs_popup.dart';

typedef ApplyCallback = Function(List<int> selectedIndexList);

// 单选、多选枚举
enum GeneralDropDownType {
  single,
  multiple,
}

class GeneralDropDownView extends StatefulWidget {
  const GeneralDropDownView({
    super.key,
    required this.contextText,
    required this.defaultIndexList,
    required this.applyCallback,
    this.type = GeneralDropDownType.multiple,
  });

  /// 内容文本
  final List<String> contextText;

  /// 默认选择下标
  final List<int> defaultIndexList;

  /// 默认多选
  final GeneralDropDownType type;

  /// Callback
  final ApplyCallback applyCallback;

  @override
  State<GeneralDropDownView> createState() => _GeneralDropDownViewState();
}

class _GeneralDropDownViewState extends State<GeneralDropDownView> {
  List<int> selectedIndexList = [];

  @override
  void initState() {
    super.initState();

    selectedIndexList = List.from(widget.defaultIndexList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: SingleChildScrollView(child: Container(padding: EdgeInsets.all(16), child: _createOptionsWidget()))),
        _createFooterWidget(),
      ],
    );
  }

  Widget _createOptionsWidget() {
    return RSCustomGridView(
      itemCount: widget.contextText.length,
      rowCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndexList.contains(index);

        return GestureDetector(
          onTap: () {
            // 如果当前类型是单选类型
            if (widget.type == GeneralDropDownType.single) {
              if (!selectedIndexList.contains(index)) {
                selectedIndexList.clear();
                selectedIndexList.add(index);
              }
            } else {
              if (selectedIndexList.contains(index)) {
                if (selectedIndexList.length > 1) {
                  selectedIndexList.remove(index);
                } else {
                  EasyLoading.showToast(S.current.rs_please_select_at_least_one_metric);
                }
              } else {
                selectedIndexList.add(index);
              }
            }

            setState(() {});
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: ShapeDecoration(
              color: isSelected ? RSColor.color_0xFF5C57E6.withOpacity(0.1) : RSColor.color_0xFFF3F3F3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: AutoSizeText(
              widget.contextText[index],
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
                S.current.rs_apply,
                RSColor.color_0xFFFFFFFF,
                RSColor.color_0xFF5C57E6,
                () {
                  widget.applyCallback.call(selectedIndexList);
                  RSPopup.pop(Get.context!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
