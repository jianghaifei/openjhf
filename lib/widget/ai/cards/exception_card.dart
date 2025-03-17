import 'package:flutter/material.dart';
import 'package:flutter_report_project/generated/l10n.dart';
import 'base_card.dart';
import '../utils/help.dart';
import '../ai_chat_theme.dart';

class AIChatExceptionCard extends AIChatBaseCard {
  final String exceptionMessage;
  final String question;
  final Function(String)? onSend;
  AIChatExceptionCard(
      {super.key,
      required super.data,
      this.exceptionMessage = '',
      this.question = '',
      this.onSend});

  double get paddingTop => toDouble(cardMetadata['paddingTop'],
      defaultValue: AIChatTheme.cardVerticalPadding);

  double get paddingBottom =>
      toDouble(cardMetadata['paddingBottom'], defaultValue: 0.0);

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: AIChatTheme.cardHorizontalPadding,
          right: AIChatTheme.cardHorizontalPadding,
          top: paddingTop,
          bottom: paddingBottom),
      child: Column(
        //spacing: 8.0, 
        //runSpacing: 4.0, 
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(exceptionMessage),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0)
            ),
            onPressed: () {
              onSend?.call(question);
            },
            child: Text(
              S.current.rs_click_to_retry,
              style: const TextStyle(
                color: Color(0xFF8580FC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
