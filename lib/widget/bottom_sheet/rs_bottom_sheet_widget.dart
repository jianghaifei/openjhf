import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';

class RSBottomSheetWidget extends StatelessWidget {
  const RSBottomSheetWidget({
    super.key,
    required this.children,
    this.maxHeight = 0.8,
    this.minHeight = 0.2,
    this.title,
    this.showDivider = false,
    this.backgroundColor = Colors.white,
  });

  /// child
  final List<Widget> children;

  /// 最大高度
  final double maxHeight;

  /// 最小高度
  final double minHeight;

  /// 创建Title
  final String? title;

  /// 是否显示分割线
  final bool showDivider;

  /// 背景颜色
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = [];
    if (title != null) {
      listWidgets.add(_buildTitleWidget(title!));
    }
    listWidgets.addAll(children);

    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxHeight: maxHeight.sh,
        minHeight: minHeight.sh,
      ),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      child: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight == 0 ? 12 : ScreenUtil().bottomBarHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: listWidgets,
        ),
      ),
    );
  }

  Widget _buildTitleWidget(String title) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 58,
          width: 1.sw,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close_outlined,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
      ],
    );
  }
}
