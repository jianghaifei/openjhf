import 'package:flutter/material.dart';
import 'base_card.dart';
import '../utils/help.dart';
import '../ai_chat_theme.dart';

class AIChatTextCard extends AIChatBaseCard {
  String get text => cardMetadata['text'] ?? '';

  double get fontSize => toDouble(cardMetadata['fontSize'], defaultValue: 14.0);

  Color get textColor {
    var textColorValue = cardMetadata['textColor'];
    if (textColorValue is String) {
      return Color(int.parse(textColorValue, radix: 16));
    } else if (textColorValue is int) {
      return Color(textColorValue);
    } else {
      return isMe ? Colors.white : const Color(0xFF13115B);
    }
  }

  FontWeight get fontWeight {
    var fontWeightValue = cardMetadata['fontWeight'] ?? 'normal';
    return getFontWeightFromString(fontWeightValue);
  }

  FontStyle get fontStyle {
    var fontWeightValue = cardMetadata['fontStyle'] ?? 'normal';
    return getFontStyleFromString(fontWeightValue);
  }

  double get paddingTop => toDouble(cardMetadata['paddingTop'],
      defaultValue: AIChatTheme.cardVerticalPadding);

  double get paddingBottom =>
      toDouble(cardMetadata['paddingBottom'], defaultValue: 0.0);

  const AIChatTextCard({super.key, required super.data});

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: AIChatTheme.cardHorizontalPadding,
          right: AIChatTheme.cardHorizontalPadding,
          top: paddingTop,
          bottom: paddingBottom),
      child: SelectableText(
        text,
        style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle),
      ),
    );
  }
}
