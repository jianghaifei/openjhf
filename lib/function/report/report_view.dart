import 'package:flutter/material.dart';
import 'package:flutter_report_project/utils/color_util.dart';
import 'package:get/get.dart';

import 'report_logic.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final logic = Get.put(ReportLogic());
  final state = Get.find<ReportLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RSColorUtil.getRandomColor(),
    );
  }

  @override
  void dispose() {
    Get.delete<ReportLogic>();
    super.dispose();
  }
}
