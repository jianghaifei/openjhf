import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/color_util.dart';
import 'mine_setting_theme_logic.dart';

class MineSettingThemePage extends StatelessWidget {
  MineSettingThemePage({super.key});

  final logic = Get.put(MineSettingThemeLogic());
  final state = Get.find<MineSettingThemeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: S.current.rs_theme,
          appBarColor: RSColor.color_0xFFF3F3F3,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: ScreenUtil().bottomBarHeight),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Obx(() {
              return Column(
                children: _createListWidget(),
              );
            }),
          ),
        ));
  }

  List<Widget> _createListWidget() {
    List<Widget> widgets = [];

    for (int i = 0; i < state.listData.length; i++) {
      widgets.add(_createItemWidget(state.listData[i], i, i == state.listData.length - 1));
    }

    return widgets;
  }

  Widget _createItemWidget(String title, int index, bool isLast) {
    return InkWell(
      onTap: () async {
        logic.switchIndex(index);

        EasyLoading.show();
        Future.delayed(const Duration(milliseconds: 250), () {
          EasyLoading.dismiss();
        });
      },
      child: SizedBox(
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
                    color: RSColorUtil.hexToColor("#666666"),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (state.selectedIndex.value == index)
                  Icon(
                    Icons.check_box,
                    color: RSColorUtil.hexToColor("#5C57E6"),
                    size: 16,
                  )
              ],
            ),
            const Spacer(),
            if (!isLast)
              Divider(
                color: RSColorUtil.hexToColor("#F1F2F4"),
                thickness: 1,
                height: 1,
              ),
          ],
        ),
      ),
    );
  }
}
