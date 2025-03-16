import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_list_setting_options_entity.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../bottom_button_widget/rs_bottom_button_widget.dart';

class AnalyticsEntityListSettingBottomSheet extends StatefulWidget {
  const AnalyticsEntityListSettingBottomSheet({super.key, required this.entity, required this.applyCallback});

  final AnalyticsEntityListSettingOptionsEntity entity;
  final Function(AnalyticsEntityListSettingOptionsEntity entity) applyCallback;

  @override
  State<AnalyticsEntityListSettingBottomSheet> createState() => _AnalyticsEntityListSettingBottomSheetState();
}

class _AnalyticsEntityListSettingBottomSheetState extends State<AnalyticsEntityListSettingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_display_dim, children: [
      _createBodyWidget(),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
          widget.applyCallback.call(widget.entity);
          Get.back();
        }),
      ),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createBodyWidget() {
    return Flexible(
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          setState(() {
            widget.entity.options?.insert(newIndex, widget.entity.options!.removeAt(oldIndex));
          });
        },
        children: widget.entity.options!.map((e) => _createItem(e)).toList(),
      ),
    );
  }

  Widget _createItem(AnalyticsEntityListSettingOptionsOptions optionsEntity) {
    return Column(
      key: ValueKey(optionsEntity.code),
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
                      optionsEntity.name ?? "-",
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (optionsEntity.show) {
                        int? countOfFalse = widget.entity.options?.where((item) => item.show).length;
                        if (countOfFalse == 1) {
                          EasyLoading.showToast(S.current.rs_show_least_one);
                          return;
                        }
                      }
                      setState(() {
                        optionsEntity.show = !optionsEntity.show;
                      });
                    },
                    child: Icon(
                      optionsEntity.show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
