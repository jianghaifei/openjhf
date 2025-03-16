import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../router/app_routes.dart';
import '../../utils/app_info.dart';
import '../../utils/debug_tools/widget/debug_open_widget.dart';
import '../../utils/network/app_compile_env.dart';
import '../../widget/bottom_sheet/launch_language/launch_language_view.dart';
import '../../widget/popup_widget/rs_bubble_popup.dart';
import 'launch_logic.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final logic = Get.put(LaunchLogic());
  final state = Get.find<LaunchLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.imageLaunchBg), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 112, bottom: 24),
                  child: DebugOpenWidget(
                    child: Image.asset(Assets.imageAppLogo),
                    pageReturnsCallback: () {
                      debugPrint("reloadEnv");
                      setState(() {
                        logic.reloadEnv();
                        int envIndex = RSAppCompileEnv.getCurrentEnvListIndex();
                        if (envIndex != -1) {
                          state.currentEnvIndex.value = envIndex;
                        } else {
                          RSAppCompileEnv.resetEnvString();
                          state.currentEnvIndex.value = 0;
                        }
                      });
                    },
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 125,
                        height: 10,
                        color: RSColor.color_0xFF5C57E6.withOpacity(0.88),
                      ),
                    ),
                    Text(
                      RSAppInfo().channel == RSAppInfoChannel.global ? 'RestoSuite\nInsight' : '数说',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    S.current.rs_slogan,
                    style: TextStyle(
                      color: RSColor.color_0x60000000,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
                if (RSAppInfo().channel == RSAppInfoChannel.global ||
                    (flustars.SpUtil.getBool(RSAppCompileEnv.appCompileEnvDebugKey, defValue: false) ?? false))
                  Padding(
                    padding: EdgeInsets.only(bottom: 38),
                    child: _createSwitchEnvWidget(),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.loginPage);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      height: 48,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: RSColor.color_0xFF5C57E6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        '${S.current.rs_login_uppercase} →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: ScreenUtil().statusBarHeight + 20,
              right: 0,
              child: Obx(() {
                return InkWell(
                  onTap: () {
                    Get.bottomSheet(LaunchLanguageContainerWidget(
                      callback: () {
                        logic.refreshCurrentLanguage();
                        Get.back();
                      },
                    ), isScrollControlled: true);
                  },
                  child: Row(
                    children: [
                      Text(
                        state.currentLanguage.value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _createSwitchEnvWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.rs_launch_server_region,
          style: TextStyle(
            color: RSColor.color_0x90000000,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: _createPopup(),
          ),
        )
      ],
    );
  }

  Widget _createPopup() {
    return RSBubblePopup(
        padding: EdgeInsets.zero,
        content: Obx(() {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _createEnvWidgets(),
            ),
          );
        }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return Text(
                state.envList[state.currentEnvIndex.value],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
            const Icon(Icons.expand_more),
          ],
        ));
  }

  List<Widget> _createEnvWidgets() {
    List<Widget> listWidget = [];

    listWidget.add(SizedBox(
      height: 8,
    ));
    for (int i = 0; i < state.envList.length; i++) {
      listWidget.add(InkWell(
        onTap: () {
          state.currentEnvIndex.value = i;
          // 切换APP域名配置
          logic.switchEnvType(state.envList[i]);
        },
        child: Container(
          width: 1.sw - 60,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.envList[i],
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Image(
                image:
                    AssetImage(state.currentEnvIndex.value == i ? Assets.imageCheckCircleSel : Assets.imageCheckCircle),
                color: state.currentEnvIndex.value == i ? RSColor.color_0xFF5C57E6 : RSColor.color_0x26000000,
              ),
            ],
          ),
        ),
      ));
    }
    listWidget.add(SizedBox(
      height: 8,
    ));

    return listWidget;
  }

  @override
  void dispose() {
    Get.delete<LaunchLogic>();
    super.dispose();
  }
}
