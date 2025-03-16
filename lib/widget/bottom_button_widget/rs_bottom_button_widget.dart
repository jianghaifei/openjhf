import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/rs_color.dart';

class RSBottomButtonWidget {
  /// 单按钮——固定宽度
  static Widget buildFixedWidthBottomButton(
    String title,
    Function(String title) callback, {
    double? width,
    double? height,
    bool editable = true,
  }) {
    return InkWell(
      onTap: () {
        if (editable) {
          callback.call(title);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: width ?? 1.sw - 16 * 2,
        height: height ?? 40,
        decoration: ShapeDecoration(
          color: RSColor.color_0xFF5C57E6.withOpacity(editable ? 1 : 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
          ),
        ),
        child: AutoSizeText(
          title,
          style: TextStyle(
            color: RSColor.color_0xFFFFFFFF,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 自适应约束按钮
  static Widget buildAdaptiveConstraintsButtonWidget(
    String title,
    Color titleColor,
    Color backgroundColor,
    VoidCallback callback, {
    double? height,
    TextStyle? textStyle,
  }) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Container(
          height: height ?? 40,
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
            style: textStyle ??
                TextStyle(
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
