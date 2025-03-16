import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import 'mine_feedback_logic.dart';

class MineFeedbackPage extends StatelessWidget {
  MineFeedbackPage({super.key});

  final logic = Get.put(MineFeedbackLogic());
  final state = Get.find<MineFeedbackLogic>().state;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: RSAppBar(
          title: S.current.rs_feedback,
        ),
        body: SafeArea(
          child: Column(
            children: [
              _createTextFieldWidget(),
              const Spacer(),
              Obx(() {
                return InkWell(
                  onTap: () {
                    if (state.inputString.value.isEmpty) {
                      return;
                    }
                    EasyLoading.show(status: "Send");
                    Future.delayed(const Duration(seconds: 3), () {
                      EasyLoading.dismiss();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 47,
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: RSColor.color_0xFF5C57E6.withOpacity(state.inputString.value.isNotEmpty ? 1 : 0.4),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    child: Text(
                      S.current.rs_feedback_send,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTextFieldWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: RSColor.color_0xFFE7E7E7, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        maxLength: state.maxLength,
        maxLines: 7,
        showCursor: true,
        cursorColor: RSColor.color_0xFF5C57E6,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: S.current.rs_please_input_feedback,
          hintStyle: TextStyle(
            color: RSColor.color_0x60000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          state.inputString.value = value;
        },
      ),
    );
  }
}
