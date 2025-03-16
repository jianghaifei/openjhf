import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup_child.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup_route.dart';

class RSPopup {
  ///Dismiss the popup related to the specific BuildContext
  static pop(BuildContext context) {
    RSDropPopupRoute.pop(context);
  }

  ///Show popup
  static Future<T?> show<T>(
    BuildContext context,
    RSPopupChild child, {
    Offset? offsetLT,
    Offset? offsetRB,
    bool cancelable = true,
    bool outsideTouchCancelable = true,
    bool darkEnable = true,
    Duration duration = const Duration(milliseconds: 200),
    List<RRect>? highlights,
  }) {
    return Navigator.of(context).push<T>(
      RSDropPopupRoute(
        child: child,
        offsetLT: offsetLT,
        offsetRB: offsetRB,
        cancelable: cancelable,
        outsideTouchCancelable: outsideTouchCancelable,
        darkEnable: darkEnable,
        duration: duration,
        highlights: highlights,
      ) as Route<T>,
    );
  }

  ///Set popup highlight positions
  static setHighlights(BuildContext context, List<RRect> highlights) {
    RSDropPopupRoute.setHighlights(context, highlights);
  }
}
