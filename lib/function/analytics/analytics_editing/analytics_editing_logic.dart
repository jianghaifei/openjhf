import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:get/get.dart';

import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../../utils/network/models/api_response_entity.dart';
import 'analytics_editing_state.dart';

class AnalyticsEditingLogic extends GetxController {
  final AnalyticsEditingState state = AnalyticsEditingState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  Future<void> saveTemplates(TopicTemplateEntity entity, Function(bool) loadState) async {
    await request(() async {
      await requestClient.request(
        RSServerUrl.saveEditUserTemplate,
        method: RequestType.post,
        data: entity.toJson(),
        onResponse: (ApiResponseEntity response) {
          Map<String, dynamic> dataDic = response.data;
          if (dataDic.containsKey("success")) {
            bool success = dataDic["success"];
            if (success) {
              loadState.call(true);
            } else {
              loadState.call(false);
            }
          } else {
            loadState.call(false);
          }
        },
        onError: (error) {
          debugPrint('原始 error = ${error.message}');
          loadState.call(false);
          return false;
        },
      );
    });
  }

  TopicTemplateTemplatesNavsTabs getNavsTabs(int tabIndex) {
    var entity = state.topicTemplateEntity.value.templates?.first.navs?.first.tabs
            ?.where((element) => !element.ifHidden && !(element.config?.locked ?? false))
            .toList()[tabIndex] ??
        TopicTemplateTemplatesNavsTabs();
    return entity;
  }

  List<TopicTemplateTemplatesNavsTabs>? getTabs() {
    var tmp = state.topicTemplateEntity.value.templates?.first.navs?.first.tabs
        ?.where((element) => !element.ifHidden && !(element.config?.locked ?? false))
        .toList();
    return tmp;
  }

  Map<String, dynamic> getAnalyticsAddPageArguments() {
    var currentNavsTabs = getNavsTabs(state.topicIndex);
    var navId = state.topicTemplateEntity.value.templates?.first.navs?.first.navId;
    var tabId = currentNavsTabs.tabId;
    var tabName = currentNavsTabs.tabName;
    var tabsData = currentNavsTabs;

    return {
      "navId": navId,
      "tabId": tabId,
      "tabName": tabName,
      "keyMetricsAddedMetricCodes": state.keyMetricsAddedMetricCodes,
      "tabsData": tabsData,
    };
  }

  void addCardData(TopicTemplateTemplatesNavsTabsCards cardData) {
    /// 核心指标卡
    if (cardData.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS) {
      cardData.cardMetadata?.metrics?.forEach((element) {
        // 记录增
        state.keyMetricsAddedMetricCodes.add(element.metricCode);
      });
    }

    var listTmp = getTabs();
    var tabId = listTmp?[state.topicIndex].tabId;

    state.topicTemplateEntity.update((val) {
      state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.forEach((element) {
        if (element.tabId == tabId) {
          // 增
          element.cards?.add(cardData);
        }
      });
    });
  }

  void updateCardData(TopicTemplateTemplatesNavsTabsCards cardData, int cardIndex) {
    var listTmp = getTabs();
    var tabId = listTmp?[state.topicIndex].tabId;

    state.topicTemplateEntity.update((val) {
      state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.forEach((element) {
        if (element.tabId == tabId) {
          int? cardsLength = element.cards?.length;
          if (cardsLength != null && cardIndex != -1 && cardIndex < cardsLength) {
            // 改
            element.cards?[cardIndex] = cardData;
          } else {
            EasyLoading.showError("出错了！");
          }
        }
      });
    });
  }
}
