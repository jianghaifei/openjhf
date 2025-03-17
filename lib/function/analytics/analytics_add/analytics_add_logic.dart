import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/model/business_topic/edit/metrics_edit_info_entity.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:get/get.dart';

import '../../../model/business_topic/topic_template_entity.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../../utils/network/request_client.dart';
import 'analytics_add_state.dart';

class AnalyticsAddLogic extends GetxController {
  final AnalyticsAddState state = AnalyticsAddState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    logger.d("onReady", StackTrace.current);

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("tabId") && args.containsKey("navId")) {
        state.tabId = args["tabId"];
        state.navId = args["navId"];
        state.tabName = args["tabName"];
        state.tabsData = args["tabsData"];
        getTabEditInfo();
      } else {
        logger.d("id is null", StackTrace.current);
        EasyLoading.showError('id is null');
        Get.back();
      }
    } else {
      logger.d("id is null", StackTrace.current);
      EasyLoading.showError('id is null');
      Get.back();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    logger.d("onClose", StackTrace.current);
  }

  Future<void> getTabEditInfo() async {
    return await request(() async {
      MetricsEditInfoEntity? entity = await requestClient.request(
        RSServerUrl.tabEditInfo,
        method: RequestType.post,
        data: {"tabId": state.tabId},
        onResponse: (response) {},
        onError: (error) {
          debugPrint('原始 error = ${error.message}');
          return false;
        },
      );

      if (entity != null) {
        state.metricsEditInfoEntity = entity;

        setAddedMetricCodes();
      }
    }, showLoading: true);
  }

  /// 设置已添加的MetricCodes
  void setAddedMetricCodes() {
    state.recordKeyMetricsAddedMetricCodes.clear();

    // 添加卡片
    state.tabsData?.cards?.forEach((aCardsElement) {
      if (aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS ||
          aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS_2 ||
          aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS_3) {
        var bCustomMetrics = state.metricsEditInfoEntity?.metricsCard?.metrics;
        aCardsElement.cardMetadata?.metrics?.forEach((aCardsMetric) {
          if (bCustomMetrics != null && bCustomMetrics.isNotEmpty) {
            for (MetricsEditInfoMetrics bMetricElement in bCustomMetrics) {
              if (aCardsMetric.metricCode == bMetricElement.metricCode) {
                bMetricElement.ifDefault = true;
              }
            }
          }
        });
      }
    });

    // 删除指标卡片
    var bCustomMetrics = state.metricsEditInfoEntity?.metricsCard?.metrics;
    if (bCustomMetrics != null && bCustomMetrics.isNotEmpty) {
      for (MetricsEditInfoMetrics bMetricElement in bCustomMetrics) {
        bool found = false;
        var tmpCards = state.tabsData?.cards;
        if (tmpCards != null) {
          for (TopicTemplateTemplatesNavsTabsCards aCardsElement in tmpCards) {
            if (aCardsElement.cardMetadata?.metrics != null &&
                (aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS ||
                    aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS_2 ||
                    aCardsElement.cardMetadata?.cardType == TopicCardType.DATA_KEY_METRICS_3)) {
              for (var tmpMetric in aCardsElement.cardMetadata!.metrics!) {
                if (tmpMetric.metricCode == bMetricElement.metricCode) {
                  found = true;
                  break;
                }
              }
              if (found) {
                break;
              }
            }
          }
          if (!found) {
            bMetricElement.ifDefault = false;
          }
        }
      }
    }
  }

  /// Metric card
  Map<String, dynamic> getAnalyticsAddMetricsPageArguments() {
    return {
      "tabName": state.tabName,
      "metricsCardEntity": state.metricsEditInfoEntity?.metricsCard,
    };
  }

  /// Analysis model
  Map<String, dynamic> getAnalyticsAddAnalysisModelPageArguments() {
    return {
      "tabName": state.tabName,
      "tabsData": state.tabsData,
      "navId": state.navId,
      "sourceTabId": state.tabId,
      "customCardTemplate": state.metricsEditInfoEntity?.customCardTemplate,
    };
  }

  /// Analysis chart
  Map<String, dynamic> getAnalyticsChartPageArguments() {
    var analysisChartEntity = <MetricsEditInfoMetricsCard?>[];

    state.metricsEditInfoEntity?.analysisChart?.forEach((element) {
      if (element.cardType?.code == TopicCardType.DATA_CHART_PERIOD ||
          element.cardType?.code == TopicCardType.DATA_CHART_GROUP ||
          element.cardType?.code == TopicCardType.DATA_CHART_RANK) {
        analysisChartEntity.add(element);
      }
    });

    return {
      "tabName": state.tabName,
      "analysisChartEntity": analysisChartEntity,
    };
  }

  /// Template
  Map<String, dynamic> getAnalyticsAddTemplatePageArguments() {
    return {
      "tabName": state.tabName,
      "navId": state.navId,
      "sourceTabId": state.tabId,
      "templateList": state.metricsEditInfoEntity?.tabTemplate,
    };
  }

// Map<String, dynamic> getAnalyticsAddMetricsPageArguments() {
//   MetricsEditInfoMetricsCard? metricsEditInfoCustom;
//
//   state.metricsEditInfoEntity?.custom?.forEach((element) {
//     if (element.cardType?.code == TopicCardType.DATA_KEY_METRICS ||
//         element.cardType?.code == TopicCardType.DATA_KEY_METRICS_2 ||
//         element.cardType?.code == TopicCardType.DATA_KEY_METRICS_3) {
//       metricsEditInfoCustom = element;
//     }
//   });
//
//   return {
//     "tabName": state.tabName,
//     "metricsEditInfoCustom": metricsEditInfoCustom,
//   };
// }
}
