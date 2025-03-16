import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scm_mobile/index.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../config/rs_color.dart';
import '../analytics/analytics_view.dart';
import '../mine/mine_view.dart';

class RsAppBottomBarConfig {
  static  List<Map<String, dynamic>> bossBottomBarConfig = [
    {
      'title': S.current.rs_scm_bottom_nav_overview,
      'icon': Image.asset(Assets.imageBottomBarReportIcon),
      'activeIcon': Image.asset(Assets.imageBottomBarReportIconSel),
      'page': const AnalyticsPage(),
    },
    {
      'title': S.current.rs_bottom_nav_mine,
      'icon':  Image.asset(Assets.imageBottomBarMineIcon),
      'activeIcon': Image.asset(Assets.imageBottomBarMineIconSel),
      'page':  MinePage(),
    },
  ];

  static  List<Map<String, dynamic>> scmBottomBarConfig = [
    {
      'title': S.current.rs_bottom_nav_overview,
      'icon': Image.asset(ScmImagePaths.home,package: 'scm_mobile'),
      'activeIcon': Image.asset(ScmImagePaths.homeSel,package: 'scm_mobile'),
      'page': ScmHomePage(),
    },
    {
      'title': S.current.rs_scm_bottom_nav_workbench,
      'icon': Image.asset(ScmImagePaths.workbench,package: 'scm_mobile'),
      'activeIcon': Image.asset(ScmImagePaths.workbenchSel,package: 'scm_mobile'),
      'page': ScmWorkbenchView(),
    },
    {
      'title': S.current.rs_bottom_nav_mine,
      'icon':  Image.asset(Assets.scmImageBottomBarMineIcon),
      'activeIcon': Image.asset(Assets.scmImageBottomBarMineIconSel),
      'page':  MinePage(),
    },
  ];
}

class MainState {
  var currentIndex = 0.obs;

  final defaultColor = RSColor.color_0x60000000;
  final activeColor = RSColor.color_0xFF5C57E6;

  MainState() {
    ///Initialize variables
  }
}
