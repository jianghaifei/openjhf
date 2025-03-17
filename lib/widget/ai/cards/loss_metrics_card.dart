import 'package:flutter/material.dart';
import 'report_card.dart';
import '../../analytics/analytics_model_card/analytics_model_card_view.dart';
import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';
import '../ai_chat_theme.dart';

class AIChatLossMetricsCard extends AIChatReportCard {
  const AIChatLossMetricsCard({
    super.key,
    required super.data,
  });

  @override
  Widget buildBody(BuildContext context) {
    return AnalyticsModelCardPage(
      margin: EdgeInsets.only(top: AIChatTheme.cardVerticalPadding),
      borderRadius: BorderRadius.zero,
      alwaysLoadData: false,
      from: 'ai_chat',
      pageEditing: false,
      cardTemplateData: TopicTemplateTemplatesNavsTabsCards.fromJson(data),
      cardIndex: 9999,
      shopIds: shopIds,
      displayTime: displayTime,
      compareDateRangeTypes: compareDateRangeTypes,
      compareDateTimeRanges: compareDateTimeRanges,
      customDateToolEnum: customDateToolEnum!,
    );
  }
}
