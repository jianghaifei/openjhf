import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:get/get.dart';

AppBar RSAppBar({
  String? title,
  bool showDivider = false,
  Color? appBarColor,
  List<Widget>? actions,
  Widget? backDialog,
  bool centerTitle = true,
  double? titleSpacing,
}) {
  return AppBar(
    backgroundColor: appBarColor,
    titleSpacing: titleSpacing,
    leading: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        if (backDialog != null) {
          Get.dialog(backDialog);
        } else {
          Get.back();
        }
      },
    ),
    actions: actions,
    centerTitle: centerTitle,
    title: Text(
      title ?? '',
      style: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    surfaceTintColor: Colors.white,
    elevation: 0,
    bottom: showDivider
        ? const PreferredSize(
            preferredSize: Size(double.infinity, 1),
            child: Divider(
              color: RSColor.color_0xFFE7E7E7,
              height: 1,
              thickness: 1,
            ),
          )
        : null,
  );
}
