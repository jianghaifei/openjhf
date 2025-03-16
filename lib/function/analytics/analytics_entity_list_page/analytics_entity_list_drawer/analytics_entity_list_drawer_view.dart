import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/function/analytics/analytics_entity_list_page/analytics_entity_list_drawer/amount_limit/amount_limit_view.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/widget/bottom_button_widget/rs_bottom_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../widget/rs_custom_grid.dart';
import 'analytics_entity_list_drawer_logic.dart';

typedef ApplyCallback = Function(List<double?> limitNumbers, String filterTypeString);

class AnalyticsEntityListDrawerPage extends StatefulWidget {
  const AnalyticsEntityListDrawerPage({
    super.key,
    required this.metricsTitle,
    this.filters,
    required this.filterMinAndMax,
    required this.filterTypeString,
    required this.applyCallback,
  });

  final String metricsTitle;
  final List<double?> filterMinAndMax;
  final List<String> filterTypeString;
  final ApplyCallback applyCallback;

  /// 筛选器信息
  final List<AnalyticsEntityFilterComponentFilters>? filters;

  @override
  State<AnalyticsEntityListDrawerPage> createState() => _AnalyticsEntityListDrawerPageState();
}

class _AnalyticsEntityListDrawerPageState extends State<AnalyticsEntityListDrawerPage> {
  final logic = Get.put(AnalyticsEntityListDrawerLogic());
  final state = Get.find<AnalyticsEntityListDrawerLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsEntityListDrawerLogic>();

    var limitList = logic.returnLimitList();
    logic.handleModelData(limitList, widget.filters);
    widget.applyCallback.call(limitList, state.currentSymbol.value);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    logic.handleData(widget.filterMinAndMax, widget.filterTypeString.first);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        color: RSColor.color_0xFFFFFFFF,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              height: AppBar().preferredSize.height,
              child: Text(
                S.current.rs_filter,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Offstage(
              offstage: !logic.getIfShowRange(widget.filters),
              child: Obx(() {
                return AmountLimitPage(
                  metricsTitle: widget.metricsTitle,
                  symbol: state.currentSymbol.value,
                  minimumController: state.minimumController,
                  maximumController: state.maximumController,
                  symbolChanged: (value) {
                    state.currentSymbol.value = value;
                  },
                );
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _createListWidget(),
                  ),
                ),
              ),
            ),
            _createFooterWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> _createListWidget() {
    List<Widget> list = [];

    /// 过滤出应该展示的
    widget.filters?.forEach((element) {
      if (element.options != null && element.options!.isNotEmpty) {
        if (element.componentType == EntityComponentType.MULTI_SELECTION) {
          list.add(_createExpansionTileWidget(element.displayName ?? "*", _createOptionsWidget(element.options)));
        }

        if (element.componentType == EntityComponentType.SELECTION) {
          list.add(_createExpansionTileWidget(
              element.displayName ?? "*", _createOptionsWidget(element.options, singleChoice: true)));
        }
      }
    });

    list.add(SizedBox(
      height: 8,
    ));

    return list;
  }

  Widget _createExpansionTileWidget(String title, Widget child) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: true,
          iconColor: RSColor.color_0x90000000,
          collapsedIconColor: RSColor.color_0x90000000,
          title: AutoSizeText(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [child]),
    );
  }

  Widget _createOptionsWidget(List<AnalyticsEntityFilterComponentFiltersOptions>? options,
      {bool singleChoice = false}) {
    return RSCustomGridView(
      itemCount: options?.length ?? 0,
      rowCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (singleChoice && options[index].isSelected == false) {
              // 单选逻辑处理
              for (var element in options) {
                element.isSelected = false;
              }
            }
            setState(() {
              options[index].isSelected = !options[index].isSelected;
            });
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: ShapeDecoration(
              color: options![index].isSelected ? RSColor.color_0xFF5C57E6.withOpacity(0.1) : RSColor.color_0xFFF3F3F3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: AutoSizeText(
              options[index].displayName ?? '*',
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: options[index].isSelected ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
                fontSize: 14,
                fontWeight: options[index].isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 16,
            ),
            RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
              S.current.rs_clean_all,
              RSColor.color_0xFF5C57E6,
              RSColor.color_0xFF5C57E6.withOpacity(0.1),
              () => clickAction("cleanAllAction"),
            ),
            SizedBox(
              width: 14,
            ),
            RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
              S.current.rs_apply,
              RSColor.color_0xFFFFFFFF,
              RSColor.color_0xFF5C57E6,
              () => clickAction("applyAction"),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
        )
      ],
    );
  }

  void clickAction(String action) {
    if (action == "cleanAllAction") {
      logic.cleanAllData(widget.filters);
      setState(() {});
    } else if (action == "applyAction") {
      Get.back();
    } else {
      EasyLoading.showError("Not Found Method");
    }
  }
}
