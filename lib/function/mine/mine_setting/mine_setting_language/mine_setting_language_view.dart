import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/bottom_sheet/launch_language/launch_language_view.dart';
import '../../../../widget/rs_app_bar.dart';
import 'mine_setting_language_logic.dart';

class MineSettingLanguagePage extends StatelessWidget {
  MineSettingLanguagePage({super.key});

  final logic = Get.put(MineSettingLanguageLogic());
  final state = Get.find<MineSettingLanguageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: S.current.rs_languages,
        appBarColor: RSColor.color_0xFFFFFFFF,
      ),
      body: LaunchLanguagePage(verticalHeight: 8, source: "MinePage"),
    );
  }
}
