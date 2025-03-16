import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';

enum RSAlertPopupType {
  normal,
  onlyCancel,
  onlyDone,
  notHaveButton,
}

class RSAlertPopup extends StatefulWidget {
  const RSAlertPopup({
    super.key,
    this.title,
    this.contentText,
    this.contentBodyAlignment = Alignment.center,
    this.contentTextAlign = TextAlign.center,
    this.customContentWidget,
    required this.alertPopupType,
    this.leftButtonTitle,
    this.rightButtonTitle,
    this.cancelCallback,
    this.doneCallback,
  });

  final String? title;
  final String? contentText;
  final Alignment contentBodyAlignment;
  final TextAlign contentTextAlign;
  final Widget? customContentWidget;

  final RSAlertPopupType alertPopupType;

  final String? leftButtonTitle;
  final String? rightButtonTitle;

  final VoidCallback? cancelCallback;
  final VoidCallback? doneCallback;

  @override
  State<RSAlertPopup> createState() => _RSAlertPopupState();
}

class _RSAlertPopupState extends State<RSAlertPopup> {
  var leftButtonTitle = S.current.rs_cancel;
  var rightButtonTitle = S.current.rs_confirm;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.leftButtonTitle != null) {
      leftButtonTitle = widget.leftButtonTitle!;
    }

    if (widget.rightButtonTitle != null) {
      rightButtonTitle = widget.rightButtonTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.alertPopupType == RSAlertPopupType.notHaveButton ? true : false,
      child: Center(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32),
        padding: EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: RSColor.color_0xFFFFFFFF,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null) _createTitle(widget.title ?? ''),
            if (widget.contentText != null || widget.customContentWidget != null) _createBody(),
            if (widget.alertPopupType != RSAlertPopupType.notHaveButton)
              _createBottom(leftButtonTitle, rightButtonTitle),
          ],
        ),
      )),
    );
  }

  Widget _createTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _createBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 1.sh * 0.5,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Align(
              alignment: widget.contentBodyAlignment,
              child: _buildBodySubview(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodySubview() {
    if (widget.customContentWidget != null) {
      return widget.customContentWidget!;
    } else {
      return Text(
        widget.contentText ?? '',
        textAlign: widget.contentTextAlign,
        style: TextStyle(
          color: RSColor.color_0x60000000,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  Widget _createBottom(String leftTitle, String rightTitle) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          if (widget.alertPopupType == RSAlertPopupType.normal || widget.alertPopupType == RSAlertPopupType.onlyCancel)
            buildButtonWidget(leftTitle, RSColor.color_0xFF5C57E6, RSColor.color_0xFF5C57E6.withOpacity(0.1), () {
              widget.cancelCallback?.call();
              Get.back();
            }),
          if (widget.alertPopupType == RSAlertPopupType.normal)
            SizedBox(
              width: 12,
            ),
          if (widget.alertPopupType == RSAlertPopupType.normal || widget.alertPopupType == RSAlertPopupType.onlyDone)
            buildButtonWidget(rightTitle, RSColor.color_0xFFFFFFFF, RSColor.color_0xFF5C57E6, () {
              widget.doneCallback?.call();
              Get.back();
            }),
        ],
      ),
    );
  }

  Widget buildButtonWidget(String title, Color titleColor, Color backgroundColor, VoidCallback callback) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(49)),
          ),
          child: AutoSizeText(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
