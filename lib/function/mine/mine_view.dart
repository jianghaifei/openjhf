import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_report_project/index.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../utils/app_info.dart';
import '../../utils/network/app_compile_env.dart';
import '../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import '../login/account_manager/account_manager.dart';
import 'mine_logic.dart';

class MinePage extends StatelessWidget {
  MinePage({super.key});

  final logic = Get.find<MineLogic>();
  final state = Get.find<MineLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.setListTitle();
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      body: _createBody(),
      // floatingActionButton: FloatingActionButton(
      //   child: Text(S.current.rs_debug),
      //   onPressed: () {
      //     Get.toNamed(AppRoutes.debugToolsPage);
      //   },
      // ),
    );
  }

  Widget _createBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createHeadWidget(),
        _createListViewWidget(),
      ],
    );
  }

  Widget _createHeadWidget() {
    final currentIdentifyUI = RSIdentify.identifyUI[RSIdentify.getIdentify()];
    return Container(
      color: RSColor.color_0xFFFFFFFF,
      width: 1.sw,
      padding: EdgeInsets.only(left: 16, right: 16, top: ScreenUtil().statusBarHeight + 12, bottom: 32),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            // margin: EdgeInsets.only(top: 10.h),
            decoration: const ShapeDecoration(
              color: Colors.transparent,
              shape: OvalBorder(),
            ),
            child: Builder(builder: (context) {
              if (flustars.RegexUtil.isURL(RSAccountManager().userInfoEntity?.employee?.avatar ?? "")) {
                return CachedNetworkImage(
                  imageUrl: RSAccountManager().userInfoEntity?.employee?.avatar ?? "",
                  placeholder: (context, url) => Image.asset(
                    Assets.imageMineDefaultAvatar,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    Assets.imageMineDefaultAvatar,
                    fit: BoxFit.contain,
                  ),
                );
              } else {
                return Image.asset(
                  Assets.imageMineDefaultAvatar,
                  fit: BoxFit.contain,
                );
              }
            }),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 用户名
                    Text(
                      RSAccountManager().userInfoEntity?.employee?.employeeName ?? "-",
                      style: const TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // 身份切换
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        gradient: LinearGradient(colors: [Color(currentIdentifyUI['tagColor'][0]), Color(currentIdentifyUI['tagColor'][1])]),
                      ),
                      child: GestureDetector(
                        onTap: () {
                            Get.toNamed(AppRoutes.mineChangeIdentityPage);
                        },
                        child:  Row(
                          children: [
                            Text(
                              currentIdentifyUI['name'],
                              style: const TextStyle(
                                color: Color(0xFF181819),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4,),
                            Image.asset('assets/image/id_change.png',width: 16,height: 16,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "#${RSAccountManager().userInfoEntity?.employee?.employeeId ?? "-"}",
                    style: const TextStyle(
                      color: RSColor.color_0x60000000,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  RSAccountManager().userInfoEntity?.employee?.corporationName ?? "-",
                  style: const TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createListViewWidget() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const ClampingScrollPhysics(),
        itemCount: state.listTitle.length,
        itemBuilder: (context, index) {
          String itemTitle = state.listTitle[index];
          String? debugSubtitle;
          if (itemTitle == S.current.rs_version) {
            bool onOffDebug = flustars.SpUtil.getBool(RSAppCompileEnv.appCompileEnvDebugKey, defValue: false) ?? false;

            debugSubtitle = "V ${RSAppInfo().version}${onOffDebug || kDebugMode ? "(${RSAppInfo().buildNumber})" : ""}";
          }
          return GestureDetector(
            onTap: () => _clickAction(itemTitle),
            child:
                RSFormCommonTypeWidget.buildGeneralFormWidget(itemTitle, debugSubtitle, () => _clickAction(itemTitle)),
          );
        },
      ),
    );
  }

  _clickAction(String action) {
    if (action == S.current.rs_setting) {
      Get.toNamed(AppRoutes.mineSettingPage);
    } else if (action == S.current.rs_give_feedback) {
      Get.toNamed(AppRoutes.mineFeedbackPage);
    } else if (action == S.current.rs_version) {
      Get.toNamed(AppRoutes.mineVersionPage);
    } else {
      EasyLoading.showError("Not Found Method");
    }
  }
}
