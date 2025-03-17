import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../bottom_button_widget/rs_bottom_button_widget.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import '../rs_bottom_sheet_widget.dart';

typedef SelectedIndexCallback = void Function(List<int> selectedIndex);

// 单选、多选枚举
enum SelectFormType {
  single,
  multiple,
}

/// 通用选择表单底部弹窗
class GeneralSelectFormBottomSheetPage extends StatefulWidget {
  const GeneralSelectFormBottomSheetPage({
    super.key,
    required this.title,
    required this.formTitle,
    required this.defaultSelectedIndex,
    this.selectedIndexCallback,
    this.selectFormType = SelectFormType.single,
    this.displaySelectedCount = false,
  });

  /// 标题
  final String title;

  /// 表单标题
  final List<String> formTitle;

  /// 默认选中的索引
  final List<int> defaultSelectedIndex;

  /// 单选、多选
  final SelectFormType selectFormType;

  /// 显示已选数量
  final bool displaySelectedCount;

  /// 选中回调
  final SelectedIndexCallback? selectedIndexCallback;

  @override
  State<GeneralSelectFormBottomSheetPage> createState() => _GeneralSelectFormBottomSheetPageState();
}

class _GeneralSelectFormBottomSheetPageState extends State<GeneralSelectFormBottomSheetPage> {
  var selectedList = <int>[];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 深拷贝widget.defaultSelectedIndex
    selectedList = List.from(widget.defaultSelectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: widget.title, maxHeight: 0.7, children: [
      _createBody(),
      _createFooterWidget(),
      // SizedBox(
      //   height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      // ),
    ]);
  }

  Widget _createBody() {
    return Expanded(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: widget.formTitle.length,
        itemBuilder: (context, index) {
          if (widget.selectFormType == SelectFormType.single) {
            return RSFormCommonTypeWidget.buildRadioFormWidget(widget.formTitle[index], selectedList.contains(index),
                (check) {
              setState(() {
                if (!selectedList.contains(index)) {
                  selectedList.clear();
                  selectedList.add(index);
                }
              });
            });
          } else {
            return RSFormCommonTypeWidget.buildMultipleCheckAndSubtitle(
                widget.formTitle[index], null, selectedList.contains(index), (check) {
              setState(() {
                if (selectedList.contains(index)) {
                  selectedList.remove(index);
                } else {
                  selectedList.add(index);
                }
              });
            });
          }
        },
      ),
    );
  }

  Widget _createFooterWidget() {
    if (widget.displaySelectedCount) {
      return Column(
        children: [
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
          Container(
            color: RSColor.color_0xFFFFFFFF,
            padding: const EdgeInsets.only(
                top: 16,
                // bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
                left: 16,
                right: 16),
            alignment: Alignment.center,
            // child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {}),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${selectedList.length}',
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
                    onTap: () {
                      if (selectedList.isNotEmpty) {
                        widget.selectedIndexCallback?.call(selectedList);
                        Get.back();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: ShapeDecoration(
                        color: RSColor.color_0xFF5C57E6.withOpacity((selectedList.isEmpty) ? 0.6 : 1),
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
        ],
      );
    } else {
      return Column(
        children: [
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
          Container(
            color: RSColor.color_0xFFFFFFFF,
            padding: const EdgeInsets.only(
                top: 16,
                // bottom: ScreenUtil().bottomBarHeight == 0 ? 20 + 16 : ScreenUtil().bottomBarHeight,
                left: 16,
                right: 16),
            child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
              if (selectedList.isNotEmpty) {
                widget.selectedIndexCallback?.call(selectedList);
                Get.back();
              }
            }, editable: selectedList.isNotEmpty),
          ),
          // const SizedBox(height: 20),
          // const SizedBox(width: 20),
        ],
      );
    }
  }
}
