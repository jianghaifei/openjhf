import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/widget/bottom_button_widget/rs_bottom_button_widget.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/topic_template_entity.dart';

class TopicEditBottomSheetPage extends StatefulWidget {
  const TopicEditBottomSheetPage({super.key, required this.topicTemplateEntity, required this.applyCallback});

  final TopicTemplateEntity topicTemplateEntity;
  final Function(TopicTemplateEntity entity) applyCallback;

  @override
  State<TopicEditBottomSheetPage> createState() => _TopicEditBottomSheetPageState();
}

class _TopicEditBottomSheetPageState extends State<TopicEditBottomSheetPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.topicTemplateEntity.templates?.first.navs?.first.tabs == null) {
      Get.back();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_topic, children: [
      _createBodyWidget(),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
          widget.applyCallback.call(widget.topicTemplateEntity);
          Get.back();
        }),
      ),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createBodyWidget() {
    return Expanded(
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          setState(() {
            widget.topicTemplateEntity.templates?.first.navs?.first.tabs
                ?.insert(newIndex, widget.topicTemplateEntity.templates!.first.navs!.first.tabs!.removeAt(oldIndex));
          });
        },
        children: widget.topicTemplateEntity.templates!.first.navs!.first.tabs!.map((e) => _createItem(e)).toList(),
      ),
    );
  }

  Widget _createItem(TopicTemplateTemplatesNavsTabs tab) {
    return Column(
      key: ValueKey(tab.tabId),
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
                      tab.tabName ?? "-",
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!tab.ifHidden) {
                        int? countOfFalse = widget.topicTemplateEntity.templates!.first.navs!.first.tabs
                            ?.where((item) => !item.ifHidden)
                            .length;
                        if (countOfFalse == 1) {
                          EasyLoading.showToast(S.current.rs_at_least_display_one_theme);
                          return;
                        }
                      }
                      setState(() {
                        tab.ifHidden = !tab.ifHidden;
                      });
                    },
                    child: Icon(
                      tab.ifHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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
