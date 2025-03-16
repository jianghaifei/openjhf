import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:get/get.dart';

import '../../../../../../model/business_topic/topic_template_entity.dart';
import '../../../../../../router/app_routes.dart';
import '../../../../../../utils/logger/logger_helper.dart';
import '../../../../analytics_editing/analytics_editing_logic.dart';
import 'analytics_add_metric_card_step3_state.dart';

class AnalyticsAddMetricCardStep3Logic extends GetxController {
  final AnalyticsAddMetricCardStep3State state = AnalyticsAddMetricCardStep3State();

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

  void backEditingPage() {
    if (state.metricsCardEntity == null &&
        state.metricsCardEntity?.metrics == null &&
        state.metricsCardEntity!.metrics!.isEmpty) {
      return;
    }

    List<TopicTemplateTemplatesNavsTabsCards> cards = [];

    // ---- cardMetadata ----

    if (state.layoutType == 1) {
      // 一行一个
      state.metricsCardEntity?.metrics?.forEach((metric) {
        var card = _initCardsTemplate();
        // metrics
        metric.ifDefault = true;
        card.cardMetadata?.metrics
            ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));

        // cardType
        card.cardMetadata?.cardType = TopicCardType.DATA_KEY_METRICS;

        // chartType
        var chartType = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
        chartType.code = state.metricsCardEntity?.chartType?.first.code;
        card.cardMetadata?.chartType?.add(chartType);

        // dims
        var dimJson = state.metricsCardEntity?.dims?.first.toJson();
        if (state.metricsCardEntity?.dims != null && dimJson != null) {
          // 使用集合来判断是否有相同元素
          if (state.metricsCardEntity?.metrics?.first.reportId != null &&
              state.metricsCardEntity?.dims?.first.reportId != null) {
            var tmpMetricsReportId = state.metricsCardEntity?.metrics?.first.reportId ?? [];
            var tmpDimsReportId = state.metricsCardEntity?.dims?.first.reportId ?? [];
            if (tmpMetricsReportId.isNotEmpty && tmpDimsReportId.isNotEmpty) {
              var hasCommonElement = tmpMetricsReportId.toSet().intersection(tmpDimsReportId.toSet()).isNotEmpty;
              if (hasCommonElement) {
                var dim = TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(dimJson);
                card.cardMetadata?.dims?.add(dim);
              }
            }
          }
        }

        cards.add(card);
      });
    } else if (state.layoutType == 2) {
      // 一行两个
      var twoMetricsCards = _createCards(2);
      cards.addAll(twoMetricsCards);
    } else if (state.layoutType == 3) {
      // 一行三个
      var threeMetricsCards = _createCards(3);
      cards.addAll(threeMetricsCards);
    }

    final AnalyticsEditingLogic logic = Get.find<AnalyticsEditingLogic>();
    for (var card in cards) {
      logic.addCardData(card);
    }

    logger.d("backEditingPage", StackTrace.current);

    Get.until((route) => Get.currentRoute == AppRoutes.analyticsEditingPage);
  }

  TopicTemplateTemplatesNavsTabsCards _initCardsTemplate() {
    TopicTemplateTemplatesNavsTabsCards card = TopicTemplateTemplatesNavsTabsCards();
    card.cardMetadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata();
    // 本期暂时不对比
    card.cardMetadata?.compareInfo = TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo();
    card.cardMetadata?.compareInfo?.metrics = <TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>[];
    card.cardMetadata?.chartType = <TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>[];
    card.cardMetadata?.metrics = <TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>[];
    card.cardMetadata?.dims = <TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>[];

    return card;
  }

  List<TopicTemplateTemplatesNavsTabsCards> _createCards(int count) {
    int index = 0;
    List<TopicTemplateTemplatesNavsTabsCards> metricsCards = [];
    state.metricsCardEntity?.metrics?.forEach((metric) {
      if (index % count == 0) {
        var card = _initCardsTemplate();
        // metrics
        metric.ifDefault = true;
        card.cardMetadata?.metrics
            ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));

        // cardType
        card.cardMetadata?.cardType = count == 2 ? TopicCardType.DATA_KEY_METRICS_2 : TopicCardType.DATA_KEY_METRICS_3;

        // chartType
        var chartType = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
        chartType.code = state.metricsCardEntity?.chartType?.first.code;
        card.cardMetadata?.chartType?.add(chartType);

        // dims——2/3个指标卡时可以不赋值维度
        // var dimJson = state.metricsCardEntity?.dims?.first.toJson();
        // if (state.metricsCardEntity?.dims != null && dimJson != null) {
        //   var dim = TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(dimJson);
        //   card.cardMetadata?.dims?.add(dim);
        // }
        metricsCards.add(card);
      } else {
        // metrics
        metric.ifDefault = true;
        metricsCards.last.cardMetadata?.metrics
            ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));
      }

      index++;
    });
    return metricsCards;
  }
}
