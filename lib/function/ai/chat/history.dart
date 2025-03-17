import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_report_project/generated/l10n.dart';
import 'controller.dart';
import 'state.dart';

class AIChatHistoryPage extends StatefulWidget {
  late final AIChatController controller;
  late final AIChatState state;
  AIChatHistoryPage({super.key}) {
    controller = Get.find<AIChatController>();
    state = controller.state;
  }

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<AIChatHistoryPage> {
  Map<String, List<Map<String, dynamic>>> groupedSessions = {};
  Set<String> selectedSessionKeys = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    List<Map<String, dynamic>> allSessions = widget.controller.getAllSessions();

    allSessions.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });

    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var session in allSessions) {
      String dateCategory = _getDateCategory(session['date']);
      if (!grouped.containsKey(dateCategory)) {
        grouped[dateCategory] = [];
      }
      grouped[dateCategory]?.add(session);
    }

    setState(() {
      groupedSessions = grouped;
    });
  }

  String _getDateCategory(String date) {
    DateTime sessionDate = DateTime.parse(date).toLocal();
    sessionDate =
        DateTime(sessionDate.year, sessionDate.month, sessionDate.day); 

    DateTime now = DateTime.now().toLocal();
    DateTime todayMidnight =
        DateTime(now.year, now.month, now.day); 
    DateTime yesterdayMidnight =
        todayMidnight.subtract(const Duration(days: 1));

    // 判断是否是今天
    if (sessionDate == todayMidnight) {
      return S.current.rs_date_tool_today;
    }
    // 判断是否是昨天
    else if (sessionDate == yesterdayMidnight) {
      return S.current.rs_date_tool_yesterday;
    }
    // 判断是否是 30 天内的日期
    else if (sessionDate.isBefore(todayMidnight) &&
        sessionDate.isAfter(todayMidnight.subtract(const Duration(days: 30)))) {
      return S.current.rs_thirty_days_within; 
    }
    // 30 天前
    else {
      return S.current.rs_thirty_days_ago;
    }
  }

  void _deleteSelectedSessions() {
    widget.controller.clearAllSessions();
    _loadSessions();
    setState(() {
      selectedSessionKeys.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.current.rs_ai_chat_history,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFE6EDFF),
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/image/delete.png',
                width: 24,
                height: 24,
              ),
              onPressed: _deleteSelectedSessions,
            ),
          ],
        ),
        body: Container(color: const Color(0xFFE6EDFF), child: _buildBody()));
  }

  Widget _buildBody() {
    return groupedSessions.isEmpty
        ? Center(child: Text(S.current.rs_ai_chat_history_no_data))
        : ListView(
            children: groupedSessions.entries.map((entry) {
              String dateCategory = entry.key;
              List<Map<String, dynamic>> sessions = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateCategory(dateCategory),
                  ...sessions.map((session) => _buildSession(session)),
                ],
              );
            }).toList(),
          );
  }

  Widget _buildDateCategory(dateCategory) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        dateCategory,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF8A8E99),
        ),
      ),
    );
  }

  Widget _buildSession(session) {
    return GestureDetector(
        onTap: () {
          widget.controller.toggleSession(session['key'] as String);
          Get.back();
        },
        onLongPressStart: (details) {
          _showContextMenu(details, session); // 传递长按位置
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    session['title'].replaceAll('\n', ' ') ?? 'Untitled',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.black),
              ],
            )));
  }

  void _showContextMenu(LongPressStartDetails details, session) {
    final screenHeight = MediaQuery.of(context).size.height;
    const menuHeight = 120.0;
    final showAbove = details.globalPosition.dy > screenHeight - menuHeight;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        showAbove
            ? details.globalPosition.dy - menuHeight
            : details.globalPosition.dy,
        details.globalPosition.dx + 1,
        showAbove
            ? details.globalPosition.dy
            : details.globalPosition.dy + menuHeight,
      ),
      items: [
        PopupMenuItem(
            height: 32,
            padding:
                const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 12),
            value: 'delete',
            child: Row(children: [
              Image.asset(
                'assets/image/delete.png',
                width: 16,
                height: 16,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                S.current.rs_delete,
                style: const TextStyle(color: Color(0xFF5C57E6)),
              )
            ])),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(value, session);
      }
    });
  }

  // 处理菜单项选择
  void _handleMenuSelection(String value, session) {
    switch (value) {
      case 'delete':
        _deleteSession(session);
        break;
      default:
        break;
    }
  }

// 删除会话
  void _deleteSession(session) {
    widget.controller.deleteSession(session['key'] as String);
    _loadSessions();
  }
}
