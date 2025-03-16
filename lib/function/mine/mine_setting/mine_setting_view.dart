import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:get/get.dart';

import '../../../config/rs_locale.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes.dart';
import '../../../widget/rs_app_bar.dart';
import '../../../widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'mine_setting_logic.dart';

class MineSettingPage extends StatefulWidget {
  const MineSettingPage({super.key});

  @override
  State<MineSettingPage> createState() => _MineSettingPageState();
}

class _MineSettingPageState extends State<MineSettingPage> {
  final logic = Get.put(MineSettingLogic());
  final state = Get.find<MineSettingLogic>().state;

  @override
  void dispose() {
    Get.delete<MineSettingLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_setting,
      ),
      body: Obx(() {
        return _createBody();
      }),
    );
  }

  Widget _createBody() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      physics: const ClampingScrollPhysics(),
      itemCount: state.listTitle.length,
      itemBuilder: (context, index) {
        var configType = state.userConfigEntity.value.userConfig?[index].configType;

        String? subtitle;
        if (configType == SettingConfigEnum.LANGUAGE) {
          var list = [S.current.rs_languages_auto];
          list.addAll(RSLocale.languagesTitle);

          subtitle = list[RSLocale().localeIndex];
        }

        return GestureDetector(
          onTap: () => _clickAction(configType),
          child: RSFormCommonTypeWidget.buildGeneralFormWidget(
              state.listTitle[index], subtitle, () => _clickAction(configType, title: state.listTitle[index])),
        );
      },
    );
  }

  _clickAction(SettingConfigEnum? configType, {String? title}) {
    if (configType == SettingConfigEnum.MY_ACCOUNT || title == S.current.rs_my_account) {
      // 我的账户
      Get.toNamed(AppRoutes.mineSettingAccountPage);
    } else if (configType == SettingConfigEnum.LANGUAGE || title == S.current.rs_languages) {
      // 语言切换
      Get.toNamed(AppRoutes.mineSettingLanguagePage)?.then((value) {
        setState(() {});
      });
    } else if (configType == SettingConfigEnum.STORE_TARGETS) {
      // 目标管理
      Get.toNamed(AppRoutes.mineSettingTargetManagePage);
    } else if (configType == SettingConfigEnum.METRIC_ABBREVIATION) {
      // 指标单位
      var config = state.userConfigEntity.value.userConfig?.firstWhere((element) => element.configType == configType);
      if (config != null) {
        Get.toNamed(AppRoutes.mineSettingMetricsUnitPage, arguments: {'config': config});
      } else {
        EasyLoading.showError('Missing Parameter');
      }
    } else {
      EasyLoading.showError('Not Found Method');
    }

    // else if (configType == S.current.rs_theme) {
    // Get.toNamed(AppRoutes.mineSettingThemePage);
    // }
  }
}
