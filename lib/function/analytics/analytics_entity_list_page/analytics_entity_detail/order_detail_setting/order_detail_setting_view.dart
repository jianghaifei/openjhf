import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import 'order_detail_setting_logic.dart';

class OrderDetailSettingPage extends StatefulWidget {
  const OrderDetailSettingPage({super.key});

  @override
  State<OrderDetailSettingPage> createState() => _OrderDetailSettingPageState();
}

class _OrderDetailSettingPageState extends State<OrderDetailSettingPage> {
  final logic = Get.put(OrderDetailSettingLogic());
  final state = Get.find<OrderDetailSettingLogic>().state;

  @override
  void dispose() {
    Get.delete<OrderDetailSettingLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RSAppBar(title: S.current.rs_setting, actions: [
        TextButton(
            onPressed: () {
              logic.editOrderDetailBaseOptions();
            },
            child: Text(
              S.current.rs_save,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ))
      ]),
      body: _createBodyWidget(),
      backgroundColor: RSColor.color_0xFFF3F3F3,
    );
  }

  Widget _createBodyWidget() {
    return Obx(() {
      return ReorderableListView.builder(
          padding: EdgeInsets.only(top: 8, bottom: ScreenUtil().bottomBarHeight),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              key: ValueKey("${index + 1}"),
              color: RSColor.color_0xFFFFFFFF,
              child: _createItem(index),
            );
          },
          itemCount: state.settingOptionsEntity.value.options?.length ?? 0,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            // List UI修改
            state.settingOptionsEntity.value.options
                ?.insert(newIndex, state.settingOptionsEntity.value.options!.removeAt(oldIndex));
          });
    });
  }

  Widget _createItem(int index) {
    var option = state.settingOptionsEntity.value.options?[index];
    return Column(
      children: [
        Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                children: [
                  Image.asset(Assets.imageListReorderable),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      option?.name ?? '-',
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        // tab.ifHidden = !tab.ifHidden;
                        option.show = !option.show;
                      });
                    },
                    child: Icon(
                      option!.show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: RSColor.color_0x60000000,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Divider(
            color: RSColor.color_0xFFF3F3F3,
            thickness: 1,
            height: 1,
            indent: 16,
          ),
        ),
      ],
    );
  }
}
