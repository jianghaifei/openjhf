import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../router/app_routes.dart';
import '../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../widget/bottom_sheet/reorderable_list_view/topic_edit_bottom_sheet/topic_edit_bottom_sheet_view.dart';
import '../../../widget/popup_widget/rs_alert/rs_alert_view.dart';
import '../../../widget/rs_app_bar.dart';
import '../../../widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import '../analytics_tab_bar/analytics_tab_bar_view.dart';
import 'analytics_editing_logic.dart';

class AnalyticsEditingPage extends StatefulWidget {
  const AnalyticsEditingPage({
    super.key,
  });

  @override
  State<AnalyticsEditingPage> createState() => _AnalyticsEditingPageState();
}

class _AnalyticsEditingPageState extends State<AnalyticsEditingPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final logic = Get.put(AnalyticsEditingLogic());
  final state = Get.find<AnalyticsEditingLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsEditingLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null && Get.arguments['entity'] is TopicTemplateEntity) {
      state.topicTemplateEntity.value = TopicTemplateEntity.fromJson(Get.arguments['entity'].toJson());
      state.topicIndex = Get.arguments['topicIndex'];
    } else {
      EasyLoading.showError('parameters missing');
      Get.back();
    }

    if (state.topicTemplateEntity.value.templates?.first.navs?.first.tabs == null) {
      return Get.back();
    }

    state.tabs.value = logic.getTabs()?.map((e) => e.tabName ?? '*').toList() ?? [];
  }

  void updateData() {
    for (var element in state.recordTabData) {
      if (element is AnalyticsTabBarPage) {
        AnalyticsTabBarPage subPage = element;
        state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.forEach((tabElement) {
          int index = state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.indexOf(tabElement) ?? 0;
          if (subPage.navsTabs != null && tabElement.tabId == subPage.navsTabs?.tabId) {
            // 是否隐藏
            subPage.navsTabs?.ifHidden =
                state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?[index].ifHidden ?? false;

            state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?[index] = subPage.navsTabs!;
          }
        });
      }
    }

    logic.saveTemplates(state.topicTemplateEntity.value, (bool loadState) {
      if (loadState) {
        Get.back(result: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
            title: S.current.rs_setting,
            appBarColor: RSColor.color_0xFFFFFFFF,
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: updateData,
                  child: Text(
                    S.current.rs_save,
                    style: const TextStyle(
                      color: RSColor.color_0xFF5C57E6,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            backDialog: _popDialog()),
        body: WillPopScope(
          onWillPop: () async {
            Get.dialog(_popDialog());
            return Future(() => false);
          },
          child: _createBody(),
        ),
      );
    });
  }

  Widget _popDialog() {
    return RSAlertPopup(
      title: S.current.rs_edit_page_back_tip,
      alertPopupType: RSAlertPopupType.normal,
      cancelCallback: () {},
      doneCallback: () {
        Get.back();
      },
    );
  }

  Widget _createBody() {
    return Container(
      color: RSColor.color_0xFFF3F3F3,
      child: _createTabControllerWidget(),
    );
  }

  Widget _createTabControllerWidget() {
    return Column(
      children: [
        RSTabControllerWidgetPage(
          key: GlobalKey(),
          tabs: state.tabs,
          initialIndex: state.topicIndex,
          type: RSTabControllerWidgetType.colorBackground,
          isEnableEditingFunction: true,
          tabListenerCallback: (int index) {
            state.topicIndex = index;
          },
          tabBarViews: List.generate(logic.getTabs()?.length ?? 0, (index) {
            var subWidget = AnalyticsTabBarPage(
              isEditingState: true,
              navsTabs: logic.getNavsTabs(index),
            );
            state.recordTabData.add(subWidget);

            return subWidget;
          }),
          editingImageName: Assets.imageTopicEdit,
          editCallBack: () {
            Get.bottomSheet(
              TopicEditBottomSheetPage(
                topicTemplateEntity: TopicTemplateEntity.fromJson(state.topicTemplateEntity.value.toJson()),
                applyCallback: (entity) {
                  state.topicTemplateEntity.value = entity;

                  state.recordTabData.clear();
                  state.tabs.value = logic.getTabs()?.map((e) => e.tabName ?? '*').toList() ?? [];
                  state.topicIndex = 0;
                },
              ),
              isScrollControlled: true,
            );
          },
        ),
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          alignment: Alignment.center,
          child: RSBottomButtonWidget.buildFixedWidthBottomButton("＋ ${S.current.rs_add}", (title) {
            Get.toNamed(AppRoutes.analyticsAddPage, arguments: logic.getAnalyticsAddPageArguments());
          }),
        ),
      ],
    );
  }
}
