import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../widget/bottom_sheet/rs_bottom_sheet_widget.dart';

class OrderDetailDrillDownBottomSheetPage extends StatefulWidget {
  const OrderDetailDrillDownBottomSheetPage({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.listItemWidget,
  });

  final String title;
  final Color backgroundColor;
  final List<Widget> listItemWidget;

  @override
  State<OrderDetailDrillDownBottomSheetPage> createState() => _OrderDetailDrillDownBottomSheetPageState();
}

class _OrderDetailDrillDownBottomSheetPageState extends State<OrderDetailDrillDownBottomSheetPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: widget.title, backgroundColor: widget.backgroundColor, children: [
      _listItemWidget(),
      SizedBox(height: 24),
    ]);
  }

  Widget _listItemWidget() {
    return Flexible(
      child: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 8),
          color: RSColor.color_0xFFFFFFFF,
          child: Column(
            children: widget.listItemWidget,
          ),
        ),
      ),
    );
  }
}
