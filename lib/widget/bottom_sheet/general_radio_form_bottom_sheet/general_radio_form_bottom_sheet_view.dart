import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../bottom_button_widget/rs_bottom_button_widget.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import '../rs_bottom_sheet_widget.dart';
import 'general_radio_form_bottom_sheet_logic.dart';
import 'general_radio_form_bottom_sheet_state.dart';

typedef SelectedIndexCallback = void Function(List<int> selectedIndex);

/// 通用单选底部弹窗
class GeneralRadioFormBottomSheetPage extends StatefulWidget {
  const GeneralRadioFormBottomSheetPage({
    super.key,
    required this.title,
    required this.listTitle,
    required this.defaultSelectedIndex,
    this.selectedIndexCallback,
  });

  final String title;

  final List<String> listTitle;

  final List<int> defaultSelectedIndex;

  final SelectedIndexCallback? selectedIndexCallback;

  @override
  State<GeneralRadioFormBottomSheetPage> createState() => _GeneralRadioFormBottomSheetPageState();
}

class _GeneralRadioFormBottomSheetPageState extends State<GeneralRadioFormBottomSheetPage> {
  final GeneralRadioFormBottomSheetLogic logic = Get.put(GeneralRadioFormBottomSheetLogic());
  final GeneralRadioFormBottomSheetState state = Get.find<GeneralRadioFormBottomSheetLogic>().state;

  var selectedList = <int>[];

  @override
  void dispose() {
    Get.delete<GeneralRadioFormBottomSheetLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedList = widget.defaultSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: widget.title, maxHeight: 0.7, children: [
      _createBody(),
      _createFooterWidget(),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createBody() {
    return Expanded(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: widget.listTitle.length,
        itemBuilder: (context, index) {
          return RSFormCommonTypeWidget.buildRadioFormWidget(widget.listTitle[index], selectedList.contains(index),
              (check) {
            setState(() {
              if (!selectedList.contains(index)) {
                selectedList.clear();
                selectedList.add(index);
              }
            });
          });
        },
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
        const SizedBox(height: 20),
        RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
          if (selectedList.isNotEmpty) {
            widget.selectedIndexCallback?.call(selectedList);
            Get.back();
          }
        }, editable: selectedList.isNotEmpty),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
