import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../widget/analytics/analytics_dining_table_card/analytics_dining_table_card_view.dart';
import '../../../widget/analytics/analytics_group_sales_card/analytics_group_sales_card_view.dart';
import '../../../widget/analytics/analytics_hourly_sales_card/analytics_hourly_sales_card_view.dart';
import '../../../widget/analytics/analytics_model_card/analytics_model_card_view.dart';
import '../../../widget/analytics/analytics_sales_card/analytics_sales_card_view.dart';
import '../../../widget/analytics/analytics_top_rank_card/analytics_top_rank_card_view.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../../widget/load_state_layout.dart';
import '../../../widget/popup_widget/screen.dart';
import '../../login/account_manager/account_manager.dart';
import 'analytics_tab_bar_logic.dart';

class AnalyticsTabBarPage extends StatefulWidget {
  const AnalyticsTabBarPage({
    super.key,
    required this.navsTabs,
    this.isEditingState = false,
    this.shopIds,
    this.displayTime,
    this.compareDateRangeTypes,
    this.compareDateTimeRanges,
    this.customDateToolEnum = CustomDateToolEnum.DAY,
    this.tabIndex,
  });

  final TopicTemplateTemplatesNavsTabs? navsTabs;
  final bool isEditingState;

  // 外部传入自定义的时间——影响范围：当前页面
  final List<String>? shopIds;
  final List<DateTime>? displayTime;
  final List<CompareDateRangeType>? compareDateRangeTypes;
  final List<List<DateTime>>? compareDateTimeRanges;
  final CustomDateToolEnum customDateToolEnum;

  final int? tabIndex;

  @override
  State<AnalyticsTabBarPage> createState() => AnalyticsTabBarPageState();
}

class AnalyticsTabBarPageState extends State<AnalyticsTabBarPage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put(AnalyticsTabBarLogic());
  final state = Get.find<AnalyticsTabBarLogic>().state;

  // 外部传入自定义的时间——影响范围：当前页面
  List<String>? myShopIds;
  List<DateTime>? myDisplayTime;
  List<CompareDateRangeType>? myCompareDateRangeTypes;
  List<List<DateTime>>? myCompareDateTimeRanges;
  CustomDateToolEnum myCustomDateToolEnum = CustomDateToolEnum.DAY;

  bool firstInitState = true;

  /// 刷新组件
  EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );

  List<Widget> listWidget = [];

  TopicTemplateTemplatesNavsTabs? get navsTabs => widget.navsTabs;

  final ValueNotifier<List<DateTime>> displayTimeNotifier = ValueNotifier([]);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsTabBarLogic>();
    super.dispose();
  }

  /// 外部传入刷新数据
  void refresh(
    List<String>? shopIds,
    List<DateTime>? displayTime,
    List<CompareDateRangeType>? compareDateRangeTypes,
    List<List<DateTime>>? compareDateTimeRanges,
    CustomDateToolEnum customDateToolEnum,
  ) {
    if ((!logic.areDateListsEqual(displayTime, myDisplayTime) ||
            !logic.areShopIdListsEqual(shopIds, myShopIds) ||
            !logic.areCompareDateRangeTypeListsEqual(compareDateRangeTypes, myCompareDateRangeTypes)) &&
        !firstInitState) {
      setState(() {
        myShopIds = shopIds;
        myDisplayTime = displayTime;
        myCompareDateRangeTypes = compareDateRangeTypes;
        myCompareDateTimeRanges = compareDateTimeRanges;
        myCustomDateToolEnum = customDateToolEnum;
      });
    } else {
      if (firstInitState) {
        firstInitState = false;
        setState(() {
          myShopIds = shopIds;
          myDisplayTime = displayTime;
          myCompareDateRangeTypes = compareDateRangeTypes;
          myCompareDateTimeRanges = compareDateTimeRanges;
          myCustomDateToolEnum = customDateToolEnum;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myShopIds = widget.shopIds;
    myDisplayTime = widget.displayTime;
    myCompareDateRangeTypes = widget.compareDateRangeTypes;
    myCompareDateTimeRanges = widget.compareDateTimeRanges;
    myCustomDateToolEnum = widget.customDateToolEnum;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: RSColor.color_0xFFF3F3F3,
      child: _createBody(),
    );
  }

  Widget _createBody() {
    // 作用于首页 首次加载时，会触发页面请求两次接口的问题
    if (widget.tabIndex != null && widget.tabIndex != 0 && firstInitState) {
      return LoadStateLayout(successWidget: Container(), reloadCallback: () {});
    } else {
      firstInitState = false;
    }

    listWidget = [];

    int widgetIndex = 0;

    widget.navsTabs?.cards?.forEach((element) {
      if (element.cardMetadata?.cardType != null) {
        switch (element.cardMetadata?.cardType) {
          case TopicCardType.DATA_KEY_METRICS:
            listWidget.add(AnalyticsSalesCardPage(
              cardViewType: AnalyticsSalesCardViewType.normal,
              pageEditing: widget.isEditingState,
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;
            break;
          case TopicCardType.DATA_KEY_METRICS_2:
            listWidget.add(AnalyticsSalesCardPage(
              cardViewType: AnalyticsSalesCardViewType.two,
              pageEditing: widget.isEditingState,
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;
            break;
          case TopicCardType.DATA_KEY_METRICS_3:
            listWidget.add(AnalyticsSalesCardPage(
              cardViewType: AnalyticsSalesCardViewType.three,
              pageEditing: widget.isEditingState,
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;
            break;

          case TopicCardType.DATA_CHART_PERIOD:
            listWidget.add(AnalyticsHourlySalesCardPage(
              pageEditing: widget.isEditingState,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;

            break;
          case TopicCardType.DATA_CHART_GROUP:
            listWidget.add(AnalyticsGroupSalesCardPage(
              pageEditing: widget.isEditingState,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;

            break;
          case TopicCardType.DATA_CHART_RANK:
            listWidget.add(AnalyticsTopRankCardPage(
              pageEditing: widget.isEditingState,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              tabId: widget.navsTabs?.tabId,
              tabName: widget.navsTabs?.tabName,
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;

            break;
          case TopicCardType.DATA_LOSS_METRICS:
            listWidget.add(AnalyticsModelCardPage(
              pageEditing: widget.isEditingState,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;

            break;
          case TopicCardType.DATA_REAL_TIME_TABLE:
            listWidget.add(AnalyticsDiningTableCardPage(
              pageEditing: widget.isEditingState,
              deleteWidgetCallback: (cardIndex) {
                removeCardWidget(cardIndex);
              },
              cardTemplateData: element,
              cardIndex: widgetIndex,
              shopIds: myShopIds,
              displayTime: myDisplayTime,
              compareDateRangeTypes: myCompareDateRangeTypes,
              compareDateTimeRanges: myCompareDateTimeRanges,
              customDateToolEnum: myCustomDateToolEnum,
            ));
            widgetIndex++;

            break;
          default:
            break;
        }
      }
    });

    if (widget.isEditingState) {
      return _createListWidget();
    } else {
      return EasyRefresh.builder(
        triggerAxis: Axis.vertical,
        controller: refreshController,
        header: const CupertinoHeader(hapticFeedback: true),
        onRefresh: () async {
          setState(() {
            refreshController.finishRefresh(IndicatorResult.success);
          });
          return IndicatorResult.success;
        },
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return _createListWidget(physics: physics);
        },
      );
    }
  }

  void removeCardWidget(int cardIndex) {
    setState(() {
      listWidget.removeAt(cardIndex);
      widget.navsTabs?.cards?.removeAt(cardIndex);
    });
  }

  Widget _createListWidget({ScrollPhysics? physics}) {
    if (widget.isEditingState) {
      return ReorderableListView.builder(
          padding: EdgeInsets.symmetric(vertical: 6),
          itemCount: listWidget.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              key: ValueKey("${index + 1}"),
              child: listWidget[index],
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            // List UI修改
            listWidget.insert(newIndex, listWidget.removeAt(oldIndex));

            // 元数据修改
            widget.navsTabs?.cards?.insert(newIndex, widget.navsTabs!.cards!.removeAt(oldIndex));
          });
    } else {
      return ListView(
        physics: physics,
        // https://www.6hu.cc/archives/41451.html（键盘的弹出或许会导致运用 MediaQuery.of(context) 的当地触发 rebuild）
        padding: EdgeInsets.only(top: 6, bottom: 6 + kBottomNavigationBarHeight + Screen.bottomBar),
        children: listWidget,
      );
    }
  }
}
