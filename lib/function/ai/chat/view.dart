import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_report_project/generated/l10n.dart';
import '../../../widget/ai/ai_chat.dart';
import 'controller.dart';
import 'state.dart';
import '../../../router/ai_routes.dart';

class AIChatPage extends StatefulWidget {
  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  late final AIChatController controller;
  late final AIChatState state;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AIChatController());
    state = controller.state;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      backgroundColor: const Color(0xFFD4E6FF),
      body: Obx(() {
        return AIChat(
          messages: state.messages.value,
          isReplying: state.isReplying.value,
          onSendPressed: controller.sendMessage,
          onNewSession: controller.newSession,
          onLike: controller.Like,
          onDislike: controller.Dislike,
          onAttachQuestion: controller.attachQuestion,
          isLatestMessage: controller.isLatestMessage,
        );
      }),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F5FF), Color(0xFFDAE4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        S.current.rs_ai_chat_title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/image/ai_chat_history.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Get.toNamed(AIRoutes.aiChatHistory);
          },
        ),
      ],
    );
  }
}
