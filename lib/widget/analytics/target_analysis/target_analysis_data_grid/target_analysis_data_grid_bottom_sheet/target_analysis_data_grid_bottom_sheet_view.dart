import 'package:flutter/material.dart';

import '../../../../bottom_sheet/rs_bottom_sheet_widget.dart';

class TargetAnalysisDataGridBottomSheetPage extends StatefulWidget {
  const TargetAnalysisDataGridBottomSheetPage({super.key, required this.title, required this.bodyWidget});

  final String title;
  final Widget bodyWidget;

  @override
  State<TargetAnalysisDataGridBottomSheetPage> createState() => _TargetAnalysisDataGridBottomSheetPageState();
}

class _TargetAnalysisDataGridBottomSheetPageState extends State<TargetAnalysisDataGridBottomSheetPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: widget.title, children: [
      widget.bodyWidget,
      // SizedBox(
      //   height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      // ),
    ]);
  }
}
