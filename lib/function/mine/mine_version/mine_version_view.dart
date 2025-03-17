import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/generated/assets.dart';
import 'package:flutter_report_project/utils/debug_tools/widget/debug_open_widget.dart';
import 'package:flutter_report_project/utils/version_check/version_check.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../router/app_routes.dart';
import '../../../utils/app_info.dart';
import '../../../utils/network/app_compile_env.dart';
import '../../../utils/network/server_url.dart';
import '../../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'mine_version_logic.dart';

class MineVersionPage extends StatelessWidget {
  const MineVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(MineVersionLogic());
    final state = Get.find<MineVersionLogic>().state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_version,
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: SafeArea(
        child: SizedBox(
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createHeaderWidget(),

              _createCheckNewVersionWidget(),
              // SizedBox(height: 40),
              // Column(
              //   children: [S.current.rs_check_new_version].map((e) => _createItemWidget(e, null)).toList(),
              // ),
              const Spacer(),
              Column(
                children: [
                  S.current.rs_login_privacy_agreement,
                ].map((e) => _createPrivacyWidget(e)).toList(),
              ),
              // Text(
              //   '${S.current.rs_call_center}: 400 000 0000',
              //   style: TextStyle(
              //     color: RSColor.colorGrey9,
              //     fontSize: 12,
              //     fontWeight: FontWeight.w500,
              //     height: 2,
              //     letterSpacing: -0.30,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: AutoSizeText(
                  RSAppInfo().channel == RSAppInfoChannel.global
                      ? 'Copyright © 2024 RESTOSUITE PRIVATE LIMITED.\n All rights reserved.'
                      : 'Copyright © 2024 RESTOSUITE PRIVATE LIMITED.\n All rights reserved.',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RSColor.color_0x26000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createHeaderWidget() {
    bool onOffDebug = SpUtil.getBool(RSAppCompileEnv.appCompileEnvDebugKey, defValue: false) ?? false;

    return SizedBox(
      width: 1.sw,
      child: Container(
        color: RSColor.color_0xFFFFFFFF,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: DebugOpenWidget(
                child: Image.asset(
                  Assets.imageAppLogo,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                ),
                pageReturnsCallback: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                RSAppInfo().appDisplayName,
                style: const TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '${S.current.rs_version} ${RSAppInfo().version}${onOffDebug || kDebugMode ? "(${RSAppInfo().buildNumber})" : ""}',
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                RSAppInfo().deviceId,
                style: TextStyle(
                  color: RSColor.color_0x40000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCheckNewVersionWidget() {
    if (RSAPPVersionCheck.isStartInAppUpgrade) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: RSFormCommonTypeWidget.buildGeneralFormWidget(S.current.rs_update_check_new_version, null, () {
          if (Platform.isIOS) {
            RSAPPVersionCheck.upgradeFromAppStore();
          } else {
            Get.toNamed(AppRoutes.versionUpdatePage);
          }
        }),
      );
    } else {
      return Container();
    }
  }

  Widget _createPrivacyWidget(String title) {
    return InkWell(
      onTap: () => _clickAction(title),
      child: Text(
        '《$title》',
        style: TextStyle(
          color: RSColor.color_0xFF5C57E6,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 2,
          letterSpacing: -0.30,
        ),
      ),
    );
  }

  Widget _createItemWidget(String title, String? subtitle) {
    return InkWell(
      onTap: () => _clickAction(title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (subtitle != null)
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: RSColor.color_0x40000000,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: RSColor.color_0x40000000,
                  size: 16,
                )
              ],
            ),
            const Spacer(),
            const Divider(
              color: RSColor.color_0xFFE7E7E7,
              thickness: 1,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  _clickAction(String action) {
    if (action == S.current.rs_check_new_version) {
      EasyLoading.showInfo(S.current.rs_check_new_version);
    } else if (action == S.current.rs_login_privacy_agreement) {
      Get.toNamed(AppRoutes.webViewPage, arguments: {"url": RSServerUrl.appUserPrivacyPolicyUrl});
    } else {
      EasyLoading.showError("Not Found Method");
    }
  }
}
