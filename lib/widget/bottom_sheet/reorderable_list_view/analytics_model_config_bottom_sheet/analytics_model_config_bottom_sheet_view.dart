import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/topic_template_entity.dart';
import '../../../bottom_button_widget/rs_bottom_button_widget.dart';
import '../../rs_bottom_sheet_widget.dart';

class AnalyticsModelConfigBottomSheetPage extends StatefulWidget {
  const AnalyticsModelConfigBottomSheetPage({super.key, required this.metadataInfo, required this.applyCallback});

  final TopicTemplateTemplatesNavsTabsCardsCardMetadata metadataInfo;
  final Function(TopicTemplateTemplatesNavsTabsCardsCardMetadata metadataInfo) applyCallback;

  @override
  State<AnalyticsModelConfigBottomSheetPage> createState() => _AnalyticsModelConfigBottomSheetPageState();
}

class _AnalyticsModelConfigBottomSheetPageState extends State<AnalyticsModelConfigBottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    return RSBottomSheetWidget(title: S.current.rs_setting, children: [
      _createBodyWidget(),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
          widget.applyCallback.call(widget.metadataInfo);
          Get.back();
        }),
      ),
      SizedBox(
        height: ScreenUtil().bottomBarHeight == 0 ? 20 : 0,
      ),
    ]);
  }

  Widget _createBodyWidget() {
    return SizedBox(
      height: 300,
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          setState(() {
            widget.metadataInfo.metrics?.insert(newIndex, widget.metadataInfo.metrics!.removeAt(oldIndex));
          });
        },
        children: widget.metadataInfo.metrics!.map((e) => _createItem(e)).toList(),
      ),
    );
  }

  Widget _createItem(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics metric) {
    return Column(
      key: ValueKey(metric.metricCode),
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
                      metric.metricName ?? "-",
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!metric.ifHidden) {
                        int? countOfFalse = widget.metadataInfo.metrics?.where((item) => !item.ifHidden).length;
                        if (countOfFalse == 1) {
                          EasyLoading.showToast(S.current.rs_at_least_display_one_metric);
                          return;
                        }
                      }

                      setState(() {
                        metric.ifHidden = !metric.ifHidden;
                      });
                    },
                    child: Icon(
                      metric.ifHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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
