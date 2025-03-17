import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_report_project/widget/ai/cards/org_chart_card.dart';
import 'cards/index.dart';
import 'ai_chat_theme.dart';
import 'ai_delayed_widget.dart';

class AIChatMessage extends StatelessWidget {
  final types.CustomMessage message;
  final Function(String)? onSend;
  final Function(String)? onLike;
  final Function(String)? onDislike;
  final Function(String, String)? onAttachQuestion;
  final bool Function(String)? isLatestMessage;

  String get messageId => message.id;

  bool get isMe => (message.metadata?['isMe'] ?? false) as bool;

  List<dynamic> get messageBody => message.metadata?['body'] ?? [];

  Map<String, dynamic> get fistCardMetaData {
    if (messageBody.isNotEmpty) {
      return messageBody[0]['cardMetadata'] ?? {};
    }
    return {};
  }

  bool get isWelcome {
    return messageBody.isNotEmpty &&
        messageBody[0]['cardMetadata']?['cardType'] == 'welcome';
  }

  String get cardType => messageBody.isNotEmpty
      ? (messageBody[0]['cardMetadata']?['cardType'])
      : 'unknown';

  String get feedback => message.metadata?['feedback'] ?? '';

  List<dynamic> get questions => message.metadata?['questions'] ?? [];

  const AIChatMessage(
      {super.key,
      required this.message,
      this.onSend,
      this.onLike,
      this.onDislike,
      this.onAttachQuestion,
      this.isLatestMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: isWelcome
            ? _buildWelcomeMessage()
            : isMe
                ? _buildUserMessage(context)
                : _buildBotMessage());
  }

  Widget _buildWelcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < messageBody.length; i++)
          _renderMessage(messageBody[i], isMe: false, key: ValueKey(i)),
      ],
    );
  }

  Widget _buildUserMessage(context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width - 32) * 0.85,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: AIChatTheme.cardVerticalPadding),
        decoration: BoxDecoration(
          color: AIChatTheme.userMessageBgColor,
          borderRadius: BorderRadius.only(
            topLeft: AIChatTheme.messageRadius,
            topRight: Radius.zero,
            bottomLeft: AIChatTheme.messageRadius,
            bottomRight: AIChatTheme.messageRadius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < messageBody.length; i++)
              _renderMessage(messageBody[i], isMe: true, key: ValueKey(i)),
          ],
        ),
      ),
    );
  }

  Widget _buildBotMessage() {
    bool delayQuestions = messageBody.any((message) =>
        (message['cardMetadata']?['cardType'] ?? '').contains('DATA_'));

    final messageWidgets = messageBody.asMap().entries.map((entry) {
      return _renderMessage(entry.value, isMe: false, key: ValueKey(entry.key));
    }).toList();

    if (cardType != 'loading') {
      messageWidgets.add(_buildFeedbackRow());
    }

    List<Widget> questionList = [];
    if (questions.isNotEmpty && isLatestMessage?.call(messageId) == true) {
      questionList.addAll(
        questions.map((question) => _buildQuestionTile(question)).toList(),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.only(bottom: AIChatTheme.cardVerticalPadding),
          decoration: BoxDecoration(
            color: AIChatTheme.robotMessageBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: AIChatTheme.messageRadius,
              bottomLeft: AIChatTheme.messageRadius,
              bottomRight: AIChatTheme.messageRadius,
            ),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messageWidgets,
          )),
      if (questionList.isNotEmpty)
        AIChatDelayedWidget(
          delay: Duration(milliseconds: delayQuestions ? 1000 * 2 : 300),
          child: Column(
            children: questionList,
          ),
        )
    ]);
  }

  Widget _buildFeedbackRow() {
    List<Widget> children = [];
    children.addAll([
      _buildFeedbackButton(
          'like', feedback == 'like', onLike, EdgeInsets.only(right: 8)),
      _buildFeedbackButton('dislike', feedback == 'dislike', onDislike,
          EdgeInsets.only(left: 8)),
    ]);
    /*
    if (feedback.isEmpty) {
      children.addAll([
        _buildFeedbackButton('like', feedback == 'like', onLike),
        SizedBox(width: AIChatTheme.cardHorizontalPadding),
        _buildFeedbackButton('dislike', feedback == 'dislike', onDislike),
      ]);
    } else if (feedback == 'like') {
      children.addAll([
        _buildFeedbackButton('like', feedback == 'like', onLike),
      ]);
    } else if (feedback == 'dislike') {
      children.addAll([
        _buildFeedbackButton('dislike', feedback == 'dislike', onDislike),
      ]);
    }
    */

    return Padding(
      padding: EdgeInsets.only(
          left: AIChatTheme.cardHorizontalPadding,
          right: AIChatTheme.cardHorizontalPadding,
          top: AIChatTheme.cardVerticalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildFeedbackButton(String type, bool isActive,
      Function(String)? callback, EdgeInsetsGeometry padding) {
    return InkWell(
      onTap: () => callback?.call(messageId),
      child: Container(
          padding: padding,
          child: Image.asset(
            'assets/image/$type${isActive ? '_active' : ''}.png',
            width: 20,
            height: 20,
          )),
    );
  }

  Widget _buildQuestionTile(String question) {
    return GestureDetector(
      onTap: () => onSend?.call(question),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: AIChatTheme.messageRadius,
                bottomLeft: AIChatTheme.messageRadius,
                bottomRight: AIChatTheme.messageRadius,
              ),
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/image/ai_chat_robot.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  question,
                  style: const TextStyle(color: Color(0xFF13115B)),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _renderMessage(Map<String, dynamic> part,
      {required bool isMe, required Key key}) {
    try {
      final cardType = part['cardMetadata']['cardType'];
      final renderers = {
        'text': (data) => AIChatTextCard(data: data, key: key),
        'image': (data) => AIChatImageCard(data: data, key: key),
        'loading': (data) => AIChatLoadingCard(data: data, key: key),
        'welcome': (data) =>
            AIChatWelcomeCard(data: data, onSend: onSend, key: key),
        'table': (data) => AIChatTableCard(data: data, key: key),
        'exception': (data) => AIChatExceptionCard(
            data: data,
            exceptionMessage: fistCardMetaData['exceptionMessage'],
            question: fistCardMetaData['question'],
            onSend: onSend,
            key: key),
        'orgChart': (data) => AIChatOrgChartCard(data: data, key: key),
        'markdown': (data) => AIChatMarkdownCard(data: data, key: key),
        'DATA_KEY_METRICS': (data) => AIChatMetricsCard(data: data, key: key),
        'DATA_KEY_METRICS_2': (data) =>
            AIChatMetricsTwoCard(data: data, key: key),
        'DATA_KEY_METRICS_3': (data) =>
            AIChatMetricsThreeCard(data: data, key: key),
        'DATA_CHART_PERIOD': (data) =>
            AIChatChartPeriodCard(data: data, key: key),
        'DATA_CHART_GROUP': (data) =>
            AIChatChartGroupCard(data: data, key: key),
        'DATA_CHART_RANK': (data) => AIChatChartRankCard(data: data, key: key),
        'DATA_LOSS_METRICS': (data) =>
            AIChatLossMetricsCard(data: data, key: key),
      };

      final mutablePart = {...part, 'isMe': isMe};
      return renderers[cardType]?.call(mutablePart) ??
          Text('未知消息类型: $cardType', key: key);
    } catch (e, stackTrace) {
      debugPrint('Error rendering message: $e');
      debugPrint('Stack trace: $stackTrace');
      return SelectableText(
        '消息加载失败: $e',
        key: key,
        style: const TextStyle(color: Colors.red),
      );
    }
  }
}
