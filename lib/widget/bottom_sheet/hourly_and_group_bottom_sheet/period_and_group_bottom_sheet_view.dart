import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';

class PeriodAndGroupBottomSheetPage extends StatelessWidget {
  const PeriodAndGroupBottomSheetPage(
      {super.key, required this.title, this.listTitleWidget, required this.listItemWidget});

  final String title;

  final Widget? listTitleWidget;
  final List<Widget> listItemWidget;

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: title, children: [
      if (listTitleWidget != null) listTitleWidget!,
      _listItemWidget(),
    ]);
  }

  Widget _listItemWidget() {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: listItemWidget,
        ),
      ),
    );
  }
}
