import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';

class PickerToolBottomSheetPage extends StatefulWidget {
  const PickerToolBottomSheetPage({
    super.key,
    required this.listTitle,
    this.leftTitle,
    this.centerTitle,
    this.rightTitle,
    required this.selectedItemIndexCallback,
    this.defaultIndex = 0,
  });

  final List<String> listTitle;

  final String? leftTitle;
  final String? centerTitle;
  final String? rightTitle;
  final int defaultIndex;

  final Function(int index) selectedItemIndexCallback;

  @override
  State<PickerToolBottomSheetPage> createState() => _PickerToolBottomSheetPageState();
}

class _PickerToolBottomSheetPageState extends State<PickerToolBottomSheetPage> {
  int selectedItemIndex = 0;
  late FixedExtentScrollController _scrollController;

  var leftTitle = S.current.rs_cancel;
  var centerTitle = S.current.rs_by;
  var rightTitle = S.current.rs_confirm;

  @override
  void initState() {
    super.initState();

    if (widget.leftTitle != null) {
      leftTitle = widget.leftTitle!;
    }

    if (widget.centerTitle != null) {
      centerTitle = widget.centerTitle!;
    }

    if (widget.rightTitle != null) {
      rightTitle = widget.rightTitle!;
    }

    _scrollController = FixedExtentScrollController(initialItem: widget.defaultIndex < 0 ? 0 : widget.defaultIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(children: [
      _createTitleWidget(),
      _createBodyWidget(),
    ]);
  }

  Widget _createTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 58,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Text(
              leftTitle,
              style: TextStyle(
                color: RSColor.color_0x60000000,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            centerTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () {
              widget.selectedItemIndexCallback.call(selectedItemIndex);
              Get.back();
            },
            child: Text(
              rightTitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBodyWidget() {
    return SizedBox(
      height: 200,
      child: CupertinoPicker(
        scrollController: _scrollController,
        itemExtent: 40,
        onSelectedItemChanged: (int value) {
          selectedItemIndex = value;
        },
        children: widget.listTitle
            .map((e) => Center(
                  child: Text(
                    e,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
