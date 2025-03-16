import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../rs_form_widget/rs_form_common_type_widget.dart';
import 'launch_language_logic.dart';

/// 多语言底部弹窗容器
class LaunchLanguageContainerWidget extends StatelessWidget {
  const LaunchLanguageContainerWidget({super.key, this.callback});

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_languages, children: [
      SizedBox(
        height: 300,
        child: LaunchLanguagePage(callback: callback, source: "LaunchPage"),
      ),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }
}

/// 多语言选择通用视图
class LaunchLanguagePage extends StatelessWidget {
  LaunchLanguagePage({super.key, this.verticalHeight = 0, this.callback, required this.source});

  final logic = Get.put(LaunchLanguageLogic());
  final state = Get.find<LaunchLanguageLogic>().state;

  final String source;
  final VoidCallback? callback;
  final double verticalHeight;

  @override
  Widget build(BuildContext context) {
    logic.setListTitle();
    return _createBody();
  }

  Widget _createBody() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: verticalHeight),
      physics: const ClampingScrollPhysics(),
      itemCount: state.listTitle.length,
      itemBuilder: (context, index) {
        return RSFormCommonTypeWidget.buildRadioFormWidget(state.listTitle[index], state.selectedIndex.value == index,
            (check) {
          logic.switchIndex(index, source);
          callback?.call();
        });
      },
    );
  }
}
