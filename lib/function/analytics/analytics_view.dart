import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_config.dart';
import 'package:flutter_report_project/function/analytics/analytics_tab_bar/analytics_tab_bar_view.dart';
import 'package:flutter_report_project/router/app_routes.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../model/business_topic/business_topic_type_enum.dart';
import '../../model/store/store_entity.dart';
import '../../widget/ai/ai_button.dart';
import '../../widget/custom_app_bar/custom_app_bar_view.dart';
import '../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../widget/load_state_layout.dart';
import '../../widget/popup_widget/screen.dart';
import '../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import '../login/account_manager/account_manager.dart';
import 'analytics_logic.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final logic = Get.put(AnalyticsLogic());
  final state = Get.find<AnalyticsLogic>().state;

  var _tabKeys = <GlobalKey<AnalyticsTabBarPageState>>[];

  // @override
  // bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsLogic>();
    super.dispose();
    logger.d("dispose", StackTrace.current);
  }

  @override
  void initState() {
    super.initState();
    logger.d("initState", StackTrace.current);

    fetchTabs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.loadAllData();
    });

    logic.refreshTabCallback = () {
      fetchTabs();
    };
  }

  void fetchTabs() {
    // 处理编辑页面将某个主题隐藏，导致tabs长度有变化
    if (state.topicIndex >= state.tabs.length) {
      state.topicIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return Obx(() {
      return Stack(
        children: [
          Container(
            width: 1.sw,
            height: ScreenUtil().statusBarHeight + 95,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imageHomeHeadBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().statusBarHeight + 95),
              child: CustomAppBarPage(
                selectedShops: state.selectedShops,
                selectedTimeRangeCallBack: (List<CompareDateRangeType>? compareDateRangeTypes,
                    List<List<DateTime>>? compareDateTimeRanges,
                    List<DateTime> displayTime,
                    CustomDateToolEnum customDateToolEnum) {
                  debugPrint("CustomDateToolWidgetPage.types: $compareDateRangeTypes");
                  debugPrint("CustomDateToolWidgetPage.dateTimeRanges: $compareDateTimeRanges");

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

                  RSAccountManager().timeRange = displayTime;

                  // 清空后再赋值
                  RSAccountManager().dayCompareDate.clear();
                  RSAccountManager().weekCompareDate.clear();
                  RSAccountManager().monthCompareDate.clear();
                  RSAccountManager().yearCompareDate.clear();

                  if (compareDateRangeTypes != null &&
                      compareDateRangeTypes.isNotEmpty &&
                      compareDateTimeRanges != null &&
                      compareDateTimeRanges.isNotEmpty) {
                    for (int index = 0; index < compareDateRangeTypes.length; index++) {
                      var type = compareDateRangeTypes[index];
                      if (index < compareDateTimeRanges.length) {
                        List<DateTime> compareDate = compareDateTimeRanges[index];
                        switch (type) {
                          case CompareDateRangeType.yesterday:
                            RSAccountManager().dayCompareDate = compareDate;
                          case CompareDateRangeType.lastWeek:
                            RSAccountManager().weekCompareDate = compareDate;
                          case CompareDateRangeType.lastMonth:
                            RSAccountManager().monthCompareDate = compareDate;
                          case CompareDateRangeType.lastYear:
                            RSAccountManager().yearCompareDate = compareDate;
                        }
                      }
                    }
                  }
                  if (state.tabs.isNotEmpty) {
                    refreshTabBarView(state.topicIndex);
                  }
                },
                refreshCallBack: (
                  List<StoreCurrencyShopsGroupShopsBrandShops> allSelectedShops,
                  List<String> allSelectedBrandIds,
                  String currencyValue,
                  StoreSelectedGroupType groupType,
                ) {
                  state.selectedShops.value = allSelectedShops;
                  if (state.tabs.isNotEmpty) {
                    refreshTabBarView(state.topicIndex);
                  }
                },
              ),
            ),
            body: Stack(children: [
              LoadStateLayout(
                state: state.loadState.value,
                ifTransparent: true,
                successWidget: _createTabControllerWidget(),
                reloadCallback: () {
                  // 重新加载所有数据
                  logic.loadAllData();
                },
                errorCode: state.errorCode,
                errorMessage: state.errorMessage,
              ),
              if (RSAccountManager()
                      .userInfoEntity
                      ?.permission
                      ?.featureToggles
                      ?.any((element) => element == RSConfig.aiSwitch) ??
                  false)
                Positioned(
                  bottom: kBottomNavigationBarHeight + (Screen.bottomBar > 0 ? Screen.bottomBar : 60),
                  right: 0,
                  child: const AIButton(),
                ),
            ]),
          ),
        ],
      );
    });
  }

  void refreshTabBarView(int index) {
    // 强制刷新特定的 AnalyticsTabBarPage
    final customKey = _tabKeys[index];
    final page = customKey.currentState;
    page?.refresh(
      RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
      List.from(state.currentCustomDateTime),
      List.from(state.compareDateRangeTypes),
      List.from(state.compareDateTimeRanges),
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
        shopIds: RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
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
            ifTransparent: true,
            tabs: state.tabs,
            type: RSTabControllerWidgetType.colorBackground,
            isEnableEditingFunction: true,
            tabListenerCallback: (int index) {
              state.topicIndex = index;

              refreshTabBarView(index);
            },
            tabBarViews: tmpWidget,
            editingImageName: Assets.imageTopicSetting,
            editCallBack: () {
              Get.toNamed(
                AppRoutes.analyticsEditingPage,
                arguments: {"entity": state.topicTemplateEntity.value, "topicIndex": 0},
              )?.then((result) {
                if (result != null && result) {
                  setState(() {
                    logic.loadAllData();
                  });
                }
              });
            }),
      ],
    );
  }
}
