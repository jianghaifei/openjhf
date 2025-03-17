import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';
import '../analytics/analytics_view.dart';
import '../mine/mine_view.dart';

class MainState {
  final List<Widget> bottomBarPages = [const AnalyticsPage(), MinePage()]; //const OverviewPage(), const ReportPage(),

  var currentIndex = 0.obs;

  final defaultColor = RSColor.color_0x60000000;
  final activeColor = RSColor.color_0xFF5C57E6;

  MainState() {
    ///Initialize variables
  }
}
