import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/rs_app_bar.dart';
import '../../../login/account_manager/account_manager.dart';
import 'mine_setting_account_logic.dart';

class MineSettingAccountPage extends StatelessWidget {
  MineSettingAccountPage({super.key});

  final logic = Get.put(MineSettingAccountLogic());
  final state = Get.find<MineSettingAccountLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.setListTitle();

    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_my_account,
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: 1.sw,
          margin: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createHeadWidget(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: _createListBodyWidget(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : 0),
                child: InkWell(
                  onTap: () {
                    logic.sendLogoutRequest();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white,
                    child: Text(
                      S.current.rs_logout,
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createHeadWidget() {
    return Container(
      color: RSColor.color_0xFFFFFFFF,
      width: 1.sw,
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 24),
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
    );
  }

  Widget _createListBodyWidget() {
    return Column(
      children: state.listTitle.map((title) {
        String? subtitle = "-";

        if (title == S.current.rs_employee_name) {
          subtitle = RSAccountManager().userInfoEntity?.employee?.employeeName;
        } else if (title == S.current.rs_employee_code) {
          subtitle = RSAccountManager().userInfoEntity?.employee?.employeeCode;
        } else if (title == S.current.rs_email) {
          subtitle = RSAccountManager().userInfoEntity?.employee?.employeeEmail;
        } else if (title == S.current.rs_phone) {
          subtitle = RSAccountManager().userInfoEntity?.employee?.employeePhone;
        } else if (title == S.current.rs_corporation) {
          subtitle = RSAccountManager().userInfoEntity?.employee?.corporationName;
        }

        return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, null, showArrow: false);
      }).toList(),
    );
  }
}
