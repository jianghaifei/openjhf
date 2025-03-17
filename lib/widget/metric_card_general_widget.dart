import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/popup_widget/rs_alert/rs_alert_view.dart';
import 'package:get/get.dart';

import '../generated/l10n.dart';

class MetricCardGeneralWidget extends StatelessWidget {
  const MetricCardGeneralWidget({
    super.key,
    required this.child,
    this.enableEditing = false,
    this.padding,
    // zlj 添加
    this.margin,
    this.borderRadius,
    this.deleteWidgetCallback,
    this.from
  });

  final Widget child;

  final bool enableEditing;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final String? from;

  final VoidCallback? deleteWidgetCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: padding ?? EdgeInsets.all(16),
          margin: margin ?? EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
              color: RSColor.color_0xFFFFFFFF,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              )),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
        Offstage(
          offstage: !enableEditing,
          child: InkWell(
            onTap: () {
              Get.dialog(RSAlertPopup(
                title: S.current.rs_delete_card_tip,
                alertPopupType: RSAlertPopupType.normal,
                doneCallback: () {
                  deleteWidgetCallback?.call();
                },
              ));
            },
            child: Container(
              alignment: Alignment.center,
              transform: Matrix4.translationValues(8, 0, 0),
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                color: RSColor.color_0xFFE7E7E7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "－",
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
