import 'package:get/get.dart';
import '../function/ai/index.dart';

class AIRoutes {
  static const String aiChat = '/ai_chat';
  static const String aiChatHistory = '/ai_chat/history';

  static final List<GetPage> routes = [
    GetPage(name: aiChat, page: () => AIChatPage()),
     GetPage(name: aiChatHistory, page: () => AIChatHistoryPage()),
  ];
}
