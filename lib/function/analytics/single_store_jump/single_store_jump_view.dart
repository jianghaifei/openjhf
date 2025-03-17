import 'package:flutter/material.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/widget/load_state_layout.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../../widget/rs_app_bar.dart';
import '../../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import '../analytics_tab_bar/analytics_tab_bar_view.dart';
import 'single_store_jump_logic.dart';

class SingleStoreJumpPage extends StatefulWidget {
  const SingleStoreJumpPage({super.key});

  @override
  State<SingleStoreJumpPage> createState() => _SingleStoreJumpPageState();
}

class _SingleStoreJumpPageState extends State<SingleStoreJumpPage> {
  final logic = Get.put(SingleStoreJumpLogic());
  final state = Get.find<SingleStoreJumpLogic>().state;

  var _tabKeys = <GlobalKey<AnalyticsTabBarPageState>>[];

  @override
  void dispose() {
    Get.delete<SingleStoreJumpLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await logic.loadUserTopicTemplate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: state.shopId.isNotEmpty ? RSAccountManager().findShopName(state.shopId.first) : '-',
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: RSColor.color_0xFFFFFFFF,
              child: CustomDateToolWidgetPage(
                key: const ObjectKey(SingleStoreJumpPage),
                displayTime:
                    state.currentCustomDateTime.isEmpty ? RSAccountManager().timeRange : state.currentCustomDateTime,
                customDateToolEnum: state.customDateToolEnum,
                compareDateRangeTypes: state.compareDateRangeTypes,
                dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                    List<List<DateTime>>? compareDateTimeRanges,
                    List<DateTime> displayTime,
                    CustomDateToolEnum customDateToolEnum) async {
                  state.currentCustomDateTime = displayTime;

                  if (compareDateRangeTypes != null) {
                    state.compareDateRangeTypes = compareDateRangeTypes;
                  } else {
                    state.compareDateRangeTypes.clear();
                  }
                  if (compareDateTimeRanges != null) {
                    state.compareDateTimeRanges = compareDateTimeRanges;
                  } else {
                    state.compareDateTimeRanges.clear();
                  }
                  state.customDateToolEnum = customDateToolEnum;

                  debugPrint("StoresPKPage——displayTime: $displayTime");
                  debugPrint("StoresPKPage——compareDateRangeTypes: $compareDateRangeTypes");
                  debugPrint("StoresPKPage——compareDateTimeRanges: $compareDateTimeRanges");

                  if (state.tabs.isNotEmpty) {
                    refreshTabBarView(state.topicIndex);
                  }
                },
              ),
            ),
            Expanded(
              child: LoadStateLayout(
                state: state.loadState.value,
                successWidget: _createTabControllerWidget(),
                reloadCallback: () {
                  // 重新加载所有数据
                  logic.loadUserTopicTemplate();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void refreshTabBarView(int index) {
    // 强制刷新特定的 AnalyticsTabBarPage
    final customKey = _tabKeys[index];
    final page = customKey.currentState;
    page?.refresh(
      state.shopId,
      state.currentCustomDateTime,
      state.compareDateRangeTypes,
      state.compareDateTimeRanges,
      state.customDateToolEnum,
    );
  }

  Widget _createTabControllerWidget() {
    _tabKeys = [];

    var tmpWidget = List.generate(state.tabs.length, (index) {
      final customKey = GlobalKey<AnalyticsTabBarPageState>();
      _tabKeys.add(customKey);
      return AnalyticsTabBarPage(
        key: customKey,
        navsTabs: state.topicTemplateEntity.value.templates?.first.navs?.first.tabs
            ?.where((element) => !element.ifHidden)
            .toList()[index],
        shopIds: state.shopId,
        displayTime: List.from(state.currentCustomDateTime),
        compareDateRangeTypes: List.from(state.compareDateRangeTypes),
        compareDateTimeRanges: List.from(state.compareDateTimeRanges),
        customDateToolEnum: CustomDateToolEnum.values[state.customDateToolEnum.index],
        tabIndex: index,
      );
    });

    return Column(
      children: [
        RSTabControllerWidgetPage(
          tabs: state.tabs,
          initialIndex: state.topicIndex,
          type: RSTabControllerWidgetType.colorBackground,
          tabListenerCallback: (int index) {
            state.topicIndex = index;

            refreshTabBarView(index);
          },
          tabBarViews: tmpWidget,
        ),
      ],
    );
  }
}
