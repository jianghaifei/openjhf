import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/models/date_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter/services.dart';
import 'ai_chat_message.dart';
import 'ai_chat_custom_input.dart';
import 'ai_chat_theme.dart';

class AIChat extends StatefulWidget {
  final List<types.Message> messages;
  final Function(String) onSendPressed;
  final Function() onNewSession;
  final Function(String) onLike;
  final Function(String) onDislike;
  final Function(String, String) onAttachQuestion;
  final bool Function(String) isLatestMessage;
  final bool isReplying;

  const AIChat({
    Key? key,
    required this.messages,
    required this.onSendPressed,
    required this.onNewSession,
    required this.onLike,
    required this.onDislike,
    required this.onAttachQuestion,
    required this.isLatestMessage,
    this.isReplying = false,
  }) : super(key: key);

  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final AutoScrollController _scrollController = AutoScrollController();
  
  @override
  void initState() {
    super.initState();
    print({
      "aaaaaaaaaaaaaaaaaaa":widget.messages
    });
  }

  void _handleSendPressed(String text) {
    widget.onSendPressed(text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _customMessageBuilder(types.CustomMessage message, {messageWidth}) {
    return AIChatMessage(
      message: message,
      onSend: _handleSendPressed,
      onLike: widget.onLike,
      onDislike: widget.onDislike,
      onAttachQuestion: widget.onAttachQuestion,
      isLatestMessage: widget.isLatestMessage,
    );
  }

  Widget _customDateHeaderBuilder(DateHeader dateHeader) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        bottom: 32,
        top: 16,
      ),
      child: Text(dateHeader.text,
          style: const TextStyle(
            color: neutral2,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.333,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF2F5FE), Color(0xFFDBE4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Chat(
        messages: widget.messages,
        onSendPressed: (partialMessage) =>
            _handleSendPressed(partialMessage.text),
        user: const types.User(id: 'user'),
        customMessageBuilder: _customMessageBuilder,
        dateHeaderBuilder: _customDateHeaderBuilder,
        customBottomWidget: AIChatCustomInputWidget(
          onSend: widget.onSendPressed,
          onNewSession: widget.onNewSession,
          isReplying: widget.isReplying,
        ),
        messageWidthRatio: 1,
        emptyState: Container(),
        theme: DefaultChatTheme(
          bubbleMargin:
              EdgeInsets.only(left: AIChatTheme.horizontalMargin, right: 0),
          messageMaxWidth: MediaQuery.of(context).size.width -
              AIChatTheme.horizontalMargin * 2,
          messageInsetsHorizontal: 0.0,
          messageBorderRadius: 0,
          primaryColor: Colors.transparent,
          secondaryColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        scrollController: _scrollController,
        onMessageTap: (BuildContext context, types.Message message) {
          FocusScope.of(context).unfocus();
        },
        //listBottomWidget:Expanded(child:Text('hello'))
      ),
    ));
  }
}
