import 'package:flutter/material.dart';
import 'package:flutter_report_project/index.dart';
import 'package:scm_mobile/index.dart';
import '../../generated/assets.dart';
import '../../utils/logger/logger_helper.dart';
import '../../utils/version_check/version_check.dart';
import 'main_logic.dart';
import 'main_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final logic = Get.find<MainLogic>();
  final state = Get.find<MainLogic>().state;
  bool loading = true;
  List<BottomNavigationBarItem> bottomBarItems = [];
  List<Widget> bottomBarPages = [];
  var currentIndex = 0;
  Color unselectedColor = RSColor.color_0x60000000;
  Color selectedColor = RSColor.color_0xFF5C57E6;

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
    // 检查身份
    var curIdentity = RSIdentify.getIdentify();
    // RSIdentify.changeIdentify(RSIdentify.scmManager);
    if (curIdentity.isEmpty) {
      curIdentity = RSIdentify.boss;
      RSIdentify.changeIdentify(curIdentity);
    }
    if (curIdentity == RSIdentify.boss) {
      bottomBarPages = RsAppBottomBarConfig.bossBottomBarConfig
          .map((e) => e["page"] as Widget)
          .toList();
      bottomBarItems = RsAppBottomBarConfig.bossBottomBarConfig
          .map((e) => _createBottomItem(
              e["title"] as String, e["icon"], e["activeIcon"]))
          .toList();
      unselectedColor = RSColor.color_0x60000000;
      selectedColor = RSColor.color_0xFF5C57E6;
    } else if (curIdentity == RSIdentify.scmManager) {
      bottomBarPages = RsAppBottomBarConfig.scmBottomBarConfig
          .map((e) => e["page"] as Widget)
          .toList();
      bottomBarItems = RsAppBottomBarConfig.scmBottomBarConfig
          .map((e) => _createBottomItem(
              e["title"] as String, e["icon"], e["activeIcon"]))
          .toList();
      unselectedColor = const Color(0xFF999999);
      selectedColor = const Color(0xFF1A1A1A);
      if (RSLocale().locale != null) {
        ScmLocale().changeLocale(RSLocale().locale!);
      }
      var scmContext = ScmContextController();
      scmContext.registerToGet();
      scmContext = Get.find<ScmContextController>();
      scmContext.loadUserInfo();
      scmContext.init();
      scmContext.eventEmitter.listen('changeTab', (value){
        setState(() {
          currentIndex = value;
        });
      });
    }
    // 检查发布平台
    logger.d("版本检测", StackTrace.current);
    // 版本检测
    RSAPPVersionCheck.checkVersion();
  }

  @override
  void dispose() {
    Get.delete<MainLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: IndexedStack(
          index: currentIndex,
          children: bottomBarPages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.98),
          items: bottomBarItems,
          unselectedItemColor: unselectedColor,
          selectedItemColor: selectedColor,
          currentIndex: currentIndex,
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
            setState(() {
              currentIndex = index;
            });
            logger.d("onTap:$index", StackTrace.current);
          },
        ));
  }

  BottomNavigationBarItem _createBottomItem(
      String title, Image icon, Image activeIcon) {
    return BottomNavigationBarItem(
      label: title,
      icon: icon,
      activeIcon: activeIcon,
    );
  }
}
