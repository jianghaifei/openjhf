import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../model/user/user_info_entity.dart';
import '../../router/app_routes.dart';
import '../../utils/app_info.dart';
import '../../utils/network/app_compile_env.dart';
import '../../widget/popup_widget/rs_bubble_popup.dart';
import '../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import '../login/account_manager/account_manager.dart';
import 'mine_logic.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final logic = Get.find<MineLogic>();
  final state = Get.find<MineLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.refreshCallback = () {
      setState(() {});
    };
  }

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
    return Container(
      color: RSColor.color_0xFFFFFFFF,
      width: 1.sw,
      padding: EdgeInsets.only(left: 16, right: 16, top: ScreenUtil().statusBarHeight + 12, bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  RSAccountManager().userInfoEntity?.employee?.employeeName ?? "-",
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
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
                _createPopupWidget(),
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

  /// 查看弹出视图
  Widget _createPopupWidget() {
    var corporations = RSAccountManager().userInfoEntity?.corporations;

    if (corporations != null && corporations.length > 1) {
      return RSBubblePopup(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        barrierColor: Colors.transparent,
        content: _createPopupSubviewWidget(corporations),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                RSAccountManager().userInfoEntity?.employee?.corporationName ?? "-",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Image(
              image: AssetImage(Assets.imageArrowDropDown),
              width: 20,
            ),
          ],
        ),
      );
    } else {
      return Text(
        RSAccountManager().userInfoEntity?.employee?.corporationName ?? "-",
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: RSColor.color_0x60000000,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  /// 查看弹出视图子视图
  Widget _createPopupSubviewWidget(List<UserInfoCorporation> corporations) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeRight: true,
      removeLeft: true,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 5 * 38.0,
          maxWidth: 1.sw / 2,
        ),
        child: Scrollbar(
          trackVisibility: true,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(corporations.length, (index) {
                return InkWell(
                  onTap: () {
                    // 相同集团id不用切换
                    if (corporations[index].corporationId ==
                        RSAccountManager().userInfoEntity?.employee?.corporationId) {
                      return;
                    }
                    setState(() {
                      logic.changeCorporation(index);
                      Get.back();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    color:
                        corporations[index].corporationId == RSAccountManager().userInfoEntity?.employee?.corporationId
                            ? RSColor.color_0xFF5C57E6.withOpacity(0.1)
                            : Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            corporations[index].corporationName ?? "-",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: corporations[index].corporationId ==
                                      RSAccountManager().userInfoEntity?.employee?.corporationId
                                  ? RSColor.color_0xFF5C57E6
                                  : RSColor.color_0xFF000000,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (corporations[index].corporationId !=
                            RSAccountManager().userInfoEntity?.employee?.corporationId)
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Image(image: AssetImage(Assets.imageSwapIcon)),
                          )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
