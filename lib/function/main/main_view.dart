import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../utils/logger/logger_helper.dart';
import '../../utils/version_check/version_check.dart';
import 'main_logic.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final logic = Get.find<MainLogic>();
  final state = Get.find<MainLogic>().state;

  @override
  void dispose() {
    Get.delete<MainLogic>();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // 预加载图片资源
    precacheImage(const AssetImage(Assets.imageHomeHeadBackground), context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 检查发布平台
    logger.d("版本检测", StackTrace.current);
    // 版本检测
    RSAPPVersionCheck.checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          backgroundColor: Colors.white,
          extendBody: true,
          body: IndexedStack(
            index: state.currentIndex.value,
            children: state.bottomBarPages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(0.98),
            items: [
              _createBottomItem(S.current.rs_bottom_nav_overview, Assets.imageBottomBarReportIcon,
                  Assets.imageBottomBarReportIconSel),
              // _createBottomItem('Report', Assets.imageBottomBarReportIcon, Assets.imageBottomBarReportSelIcon),
              _createBottomItem(
                  S.current.rs_bottom_nav_mine, Assets.imageBottomBarMineIcon, Assets.imageBottomBarMineIconSel),
            ],
            unselectedItemColor: state.defaultColor,
            selectedItemColor: state.activeColor,
            currentIndex: state.currentIndex.value,
            // item > 3时必须要设置,不然未选中项字体颜色变白
            // type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              color: RSColor.color_0xFF5C57E6,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            onTap: (index) {
              // _controller.jumpToPage(index);
              state.currentIndex.value = index;
              logger.d("onTap:$index", StackTrace.current);
              if (index == 1) {
                setState(() {});
              }
            },
          ));
    });
  }

  BottomNavigationBarItem _createBottomItem(String title, String imageName, String imageSelName) {
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(imageName),
      activeIcon: Image.asset(imageSelName),
    );
  }
}
