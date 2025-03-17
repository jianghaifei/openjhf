import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'base_card.dart';
import '../utils/help.dart';
import '../ai_chat_theme.dart';

class AIChatMarkdownCard extends AIChatBaseCard {
  String get text => cardMetadata['text'] ?? '';

  double get paddingTop => toDouble(cardMetadata['paddingTop'],
      defaultValue: AIChatTheme.cardVerticalPadding);

  double get paddingBottom =>
      toDouble(cardMetadata['paddingBottom'], defaultValue: 0.0);

  const AIChatMarkdownCard({super.key, required super.data});

  @override
  Widget buildBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: AIChatTheme.cardHorizontalPadding,
            right: AIChatTheme.cardHorizontalPadding,
            top: paddingTop,
            bottom: paddingBottom),
        child: MarkdownBody(
          data: text,
        ));
  }
}
