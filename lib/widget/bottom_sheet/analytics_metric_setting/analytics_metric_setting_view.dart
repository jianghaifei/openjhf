import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/assets.dart';
import '../../../utils/color_util.dart';
import 'analytics_metric_setting_logic.dart';

enum MetricSettingType {
  metricSetting,
  rankSetting,
  cardListSetting,
}

class AnalyticsMetricSettingPage extends StatefulWidget {
  const AnalyticsMetricSettingPage({super.key, required this.metricSettingType});

  final MetricSettingType metricSettingType;

  @override
  State<AnalyticsMetricSettingPage> createState() => _AnalyticsMetricSettingPageState();
}

class _AnalyticsMetricSettingPageState extends State<AnalyticsMetricSettingPage> {
  final logic = Get.put(AnalyticsMetricSettingLogic());
  final state = Get.find<AnalyticsMetricSettingLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsMetricSettingLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    state.metricSettingType = widget.metricSettingType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(maxHeight: 1.sh * 0.7),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      child: Column(
        children: [
          _createHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _createMetricCheckBoxWidget(
                      'Metric Display', state.listDataMetricDisplay, state.selectedCheckBoxValues),
                  _createMetricCheckBoxWidget('Extension Showing', state.listDataExtensionShowing,
                      state.selectedCheckBoxExtensionShowingValues),
                  _createCompareTimeWidget(),
                ],
              ),
            ),
          ),
          _createFooterWidget(),
        ],
      ),
    );
  }

  Widget _createCompareTimeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Compare to",
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            children: _createCompareTimeItemWidget(),
          ),
        ],
      ),
    );
  }

  List<Widget> _createCompareTimeItemWidget() {
    List<Widget> widgets = [];

    for (int index = 0; index < state.listDataCompareTime.length; index++) {
      widgets.add(Obx(() {
        return InkWell(
          onTap: () {
            state.selectedCheckBoxCompareIndex.value = index;
            debugPrint("_createCompareTimeItemWidget:${state.selectedCheckBoxCompareIndex.value}");
          },
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Image.asset(state.selectedCheckBoxCompareIndex.value == index
                    ? Assets.imageLoginCheckboxSel
                    : Assets.imageLoginCheckbox),
                SizedBox(width: 10),
                Text(
                  'The Day Last Week',
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        );
      }));
    }
    return widgets;
  }

  Widget _createMetricCheckBoxWidget(String title, var listData, var listSel) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(() {
            return Column(
              children: _createCheckBoxItem(listData, listSel),
            );
          }),
          Divider(
            color: RSColorUtil.hexToColor("#F1F2F4"),
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }

  List<Widget> _createCheckBoxItem(var listData, var listSel) {
    List<Widget> widgets = [];

    for (int index = 0; index < listData.length; index++) {
      var selectValue = listSel.contains(listData[index]);
      widgets.add(InkWell(
        onTap: () {
          if (selectValue) {
            if (listSel.contains(listData[index])) {
              listSel.remove(listData[index]);
            }
          } else {
            if (!listSel.contains(listData[index])) {
              listSel.add(listData[index]);
            }
          }

          setState(() {});
        },
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Text(
                listData[index],
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                selectValue ? Icons.check_box : Icons.check_box_outline_blank,
                color: selectValue ? RSColorUtil.hexToColor("#5C57E6") : RSColorUtil.hexToColor("#C4C7CA"),
                size: 16,
              )
            ],
          ),
        ),
      ));
    }

    return widgets;
  }

  Widget _createHeaderWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          width: 1.sw,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  logic.returnTitleString(widget.metricSettingType),
                  style: TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close_outlined,
                    size: 25,
                    color: RSColor.color_0x90000000,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: RSColorUtil.hexToColor("#F1F2F4"),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        Divider(
          color: RSColorUtil.hexToColor("#F1F2F4"),
          thickness: 1,
          height: 1,
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: ShapeDecoration(
                color: RSColorUtil.hexToColor("#FBFBFB"),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: RSColorUtil.hexToColor("#EFEFEF")),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(
                  color: RSColorUtil.hexToColor("#1A1D1F"),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                debugPrint("");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                decoration: ShapeDecoration(
                  color: RSColor.color_0xFF5C57E6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Apply',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RSColorUtil.hexToColor("#FBFBFB"),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().bottomBarHeight,
        )
      ],
    );
  }
}
