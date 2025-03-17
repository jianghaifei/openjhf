import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_report_project/generated/l10n.dart';
import 'package:flutter_report_project/utils/network/exception.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import './state.dart';

class AIChatController extends GetxController {
  static const _storageKey = 'ai_chat_history';
  final AIChatState state = AIChatState();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  // 异步初始化函数
  Future<void> _init() async {
    try {
      var messages = getCurrentSessionMessages();
      if (messages.isNotEmpty) {
        _loadMessages(messages);
      } else {
        final welcomeMessage = await createWelcomeMessage();
        state.messages.insert(0, welcomeMessage);
      }
    } catch (e, stackTrace) {
      debugPrint('初始化异常: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  // 加载消息
  void _loadMessages(List<dynamic> messages) {
    state.messages.addAll(
      messages.map((message) {
        return types.CustomMessage.fromJson(message as Map<String, dynamic>);
      }).toList(),
    );
  }

  // 创建欢迎信息
  Future<types.CustomMessage> createWelcomeMessage() async {
    Map<String, dynamic> response = await requestClient.request(
      RSServerUrl.aiWelcome,
      method: RequestType.post,
      data: {},
    );
    String welcomeText = response['readme'] as String;
    List<String> questions =
        (response['questions'] is List) ? (response['questions'] as List).whereType<String>().toList() : [];
    int createdAt = DateTime.now().millisecondsSinceEpoch;

    return types.CustomMessage(
      author: const types.User(id: 'bot'),
      //createdAt: createdAt,
      id: createdAt.toString(),
      metadata: {
        'isMe': false,
        'body': [
          {
            'cardMetadata': {"cardType": "welcome", "welcomeText": welcomeText, "questions": questions}
          },
        ],
      },
    );
  }

  // 创建用户消息
  types.CustomMessage createUserMessage(String text) {
    return types.CustomMessage(
      author: const types.User(id: 'user'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      metadata: {
        'isMe': true,
        'body': [
          {
            "cardId": 1,
            'cardMetadata': {"cardType": "text", "text": text}
          },
        ],
      },
    );
  }

  // 创建加载消息
  types.CustomMessage createLoadingMessage() {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    return types.CustomMessage(
      author: const types.User(id: 'bot'),
      createdAt: createdAt,
      id: createdAt.toString(),
      metadata: const {
        'isMe': false,
        'body': [
          {
            'cardMetadata': {"cardType": "loading"}
          },
        ],
      },
    );
  }

  // 发送消息
  Future<void> sendMessage(String text) async {
    if (text.isNotEmpty) {
      final message = createUserMessage(text);
      state.messages.insert(0, message);
      saveMessages(question: text);
      await Future.delayed(const Duration(microseconds: 100));
      await addBotReply(message, text);
    }
  }

  void saveMessages({String? question}) {
    // 获取当前会话的键和会话数据
    String? currentSessionKey;
    try {
      currentSessionKey = SpUtil.getString(_storageKey);
    } catch (e) {
      SpUtil.remove(_storageKey);
    }

    Map<String, dynamic>? currentSession =
        currentSessionKey != null ? SpUtil.getObject(currentSessionKey) as Map<String, dynamic>? : {};

    // 获取当前时间并格式化为可读时间戳
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());

    // 新会话的键值
    String sessionKey = '$_storageKey$formattedDate';

    // 如果当前会话键存在，则更新会话数据
    if (currentSessionKey != null && currentSession != null && currentSession.isNotEmpty) {
      SpUtil.putObject(currentSessionKey, {
        ...currentSession,
        'messages': state.messages.value,
      });
    } else {
      // 如果没有当前会话，则创建一个新会话
      SpUtil.putObject(sessionKey, {
        'title': question ?? 'Untitled',
        'date': formattedDate,
        'messages': state.messages.value,
      });
      // 更新当前会话的键
      SpUtil.putString(_storageKey, sessionKey);
    }
  }

  // clearAllSessions
  void clearAllSessions() {
    // 获取所有的会话键，避免 null 调用
    List<String> sessionKeys =
        SpUtil.getKeys()?.where((key) => key.startsWith(_storageKey) && key != _storageKey).toList() ?? [];

    // 删除所有会话
    for (var key in sessionKeys) {
      SpUtil.remove(key);
    }
  }

  // delete Session
  Future<void> deleteSession(String sessionKey) async {
    if (SpUtil.getString(_storageKey) != sessionKey) {
      SpUtil.remove(sessionKey);
    } else {
      SpUtil.remove(sessionKey);
      SpUtil.remove(_storageKey);
    }
  }

  // 获取所有会话
  List<Map<String, dynamic>> getAllSessions() {
    // 获取所有的会话键，避免 null 调用
    List<String> sessionKeys =
        SpUtil.getKeys()?.where((key) => key.startsWith(_storageKey) && key != _storageKey).toList() ?? [];

    // 获取所有会话数据
    List<Map<String, dynamic>> allSessions = [];
    for (var key in sessionKeys) {
      Map<String, dynamic> sessionData = SpUtil.getObject(key) as Map<String, dynamic>;
      sessionData['key'] = key;
      allSessions.add(sessionData);
    }

    return allSessions;
  }

  // 切换会话
  Future<void> toggleSession(String? sessionKey) async {
    if (sessionKey == null || sessionKey.isEmpty) {
      return;
    }
    SpUtil.putString(_storageKey, sessionKey);
    state.messages.clear();
    await _init();
  }

  // 获取当前会话消息
  List<dynamic> getCurrentSessionMessages() {
    String? currentSessionKey = SpUtil.getString(_storageKey);
    if (currentSessionKey != null && currentSessionKey.isNotEmpty) {
      Map<String, dynamic>? currentSession = SpUtil.getObject(currentSessionKey) as Map<String, dynamic>?;
      return currentSession?['messages'] ?? [];
    }
    return [];
  }

  // 添加机器人回复
  Future<void> addBotReply(types.CustomMessage questionMessage, String question) async {
    try {
      state.isReplying.value = true;
      final loadingMessage = createLoadingMessage();
      state.messages.insert(0, loadingMessage);
      //await Future.delayed(const Duration(seconds: 1));

      await fetchBotReply(loadingMessage.id, questionMessage, question);
    } catch (e) {
      print('Error fetching bot reply: $e');
    } finally {
      state.isReplying.value = false;
    }
  }

  // 获取机器人回复
  Future<void> fetchBotReply(String messageId, types.CustomMessage questionMessage, String question) async {
    try {
      Map<String, dynamic> response = await requestClient.request(
        RSServerUrl.aiReply,
        method: RequestType.post,
        data: {'query': question, 'chat_history': getHistoryAfterId(questionMessage.id, 5, false), 'conf_args': {}},
        timeout: const Duration(minutes: 5),
      );
      updateBotReply(messageId, response);
    } catch (e) {
      if (e is TimeoutException) {
        updateBotReplyWithException(messageId, S.current.rs_timeout, question);
      } else if (e is ApiException) {
        updateBotReplyWithException(messageId, e.message ?? '', question);
      } else {
        updateBotReplyWithException(messageId, e.toString(), question);
      }
    }
  }

  void updateBotReplyWithException(String messageId, String exceptionMessage, String question) {
    final index = state.messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final current = state.messages[index] as types.CustomMessage;
      state.messages[index] = current.copyWith(
        metadata: {
          'isMe': false,
          'body': [
            {
              'cardMetadata': {"cardType": "exception", 'exceptionMessage': exceptionMessage, 'question': question}
            },
          ]
        },
      );
      saveMessages();
    }
  }

  // 更新机器人回复
  void updateBotReply(String messageId, Map<String, dynamic> response) {
    final index = state.messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final current = state.messages[index] as types.CustomMessage;
      state.messages[index] = current.copyWith(
        metadata: {...response, 'isMe': false},
      );
      saveMessages();
    }
  }

  // 新建会话
  Future<void> newSession() async {
    state.messages.clear();
    SpUtil.remove(_storageKey);
    await _init();
  }

  // 获取历史消息
  List<Map<String, dynamic>> getHistoryAfterId(String messageId, int messageCount, bool includeMe) {
    int startIndex = state.messages.indexWhere((message) => message.id == messageId);

    if (startIndex == -1 || state.messages.isEmpty) {
      return [];
    }

    startIndex = includeMe ? startIndex : startIndex + 1;

    final messages =
        state.messages.sublist(startIndex, startIndex + messageCount.clamp(0, state.messages.length - startIndex - 1));

    final List<Map<String, dynamic>> result = [];

    messages.reversed.forEach((message) {
      final metadata = message.metadata ?? {};
      final body = metadata['body'] ?? [];
      final cardMetadata = body.isNotEmpty ? (body[0]['cardMetadata'] ?? {}) : {};
      final cardType = cardMetadata['cardType'];

      // 过滤掉环境、加载中、异常
      if (cardType != 'welcome' &&
          cardType != 'loading' &&
          cardType != 'exception' &&
          metadata['isMe'] as bool == false) {
        final sourceChat = metadata['source_chat'] ?? [];
        if (sourceChat is List) {
          result.addAll(sourceChat.whereType<Map<String, dynamic>>());
        }
      }
    });

    return result;
  }

  Future<void> feedback(messageId, String feedback) async {
    final index = state.messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final current = state.messages[index] as types.CustomMessage;
      final metadata = current.metadata ?? {};
      final currentFeedback = metadata['feedback'] ?? '';
      //if (currentFeedback == '') {
      state.messages[index] = current.copyWith(
        metadata: {...?current.metadata, 'feedback': feedback == currentFeedback ? '' : feedback},
      );
      if (currentFeedback != feedback) {
        requestClient.request(
          RSServerUrl.aiFeedback,
          method: RequestType.post,
          data: {"back_value": feedback == 'like' ? '1' : '0', "chat_list": getHistoryAfterId(current.id, 5, true)},
        );
      }
      saveMessages();
    }
    //}
  }

  // 点赞
  Future<void> Like(messageId) async {
    await feedback(messageId, 'like');
  }

  // 点踩
  Future<void> Dislike(messageId) async {
    await feedback(messageId, 'dislike');
  }

  // 附加问题
  void attachQuestion(String messageId, String question) {
    final index = state.messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final current = state.messages[index] as types.CustomMessage;
      state.messages[index] = current.copyWith(
        metadata: {...?current.metadata, 'isAsked': true},
      );
      sendMessage(question);
    }
  }

  // 判断是否是最新的消息
  bool isLatestMessage(String messageId) {
    final index = state.messages.indexWhere((message) => message.id == messageId);
    return index == 0;
  }
}
