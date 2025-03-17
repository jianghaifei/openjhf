import 'package:flutter/material.dart';
import 'base_card.dart';
import '../utils/help.dart';
import '../ai_chat_theme.dart';
import '../org_chart/index.dart';
import '../org_chart/node.dart';

class AIChatOrgChartCard extends AIChatBaseCard {
  AIChatOrgChartCard({super.key, required super.data});

  List<dynamic> get nodes => cardMetadata['nodes'] ?? [];

  double get paddingTop => toDouble(cardMetadata['paddingTop'],
      defaultValue: AIChatTheme.cardVerticalPadding);

  double get paddingBottom =>
      toDouble(cardMetadata['paddingBottom'], defaultValue: 0.0);

  @override
  Widget buildBody(BuildContext context) {
    List<AIChatOrgChartNode> ns = nodes
        .map((toElement) =>
            AIChatOrgChartNode.fromJson(toElement as Map<String, dynamic>))
        .toList();

    return Container(
        padding: EdgeInsets.only(
            left: AIChatTheme.cardHorizontalPadding,
            right: AIChatTheme.cardHorizontalPadding,
            top: paddingTop,
            bottom: paddingBottom),
        child: AIChatOrgChart(initialNodes: ns));
  }
}
