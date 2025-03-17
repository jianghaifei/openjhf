import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AIChatState {
  final RxList<types.Message> messages = <types.Message>[
    
  ].obs;
  final Rx<bool> isReplying = false.obs;
}
