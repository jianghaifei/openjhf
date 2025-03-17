import 'package:flutter/material.dart';
import 'package:flutter_report_project/generated/l10n.dart';
import 'base_card.dart';
import '../ai_chat_theme.dart';

class AIChatWelcomeCard extends AIChatBaseCard {
  final Function(String)? onSend;
  const AIChatWelcomeCard({super.key, required super.data, this.onSend});

  String get welcomeText => cardMetadata['welcomeText'] ?? '';
  List<dynamic> get questions => cardMetadata['questions'] ?? [];

  @override
  Widget buildBody(BuildContext context) {
    return Container(
        margin:
            const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            children: [
              Positioned(
                  top: 18,
                  left: 0,
                  right: 0,
                  child: _buildWelcomeBackground(context)), // 渐变背景背景
              Positioned(top: 0, left: 8, child: _buildRobot()), //机器人
              Positioned(
                  top: 25, left: 88, child: _buildWelcomeText(context)), //欢迎词
              _buildQuestions(context), //问题标题+问题
            ],
          )
        ]));
  }

  Widget _buildRobot() {
    return Image.asset(
      'assets/image/ai_chat_robot.png',
      width: 73,
      height: 61,
    );
  }

  Widget _buildWelcomeText(context) {
    return Container(
        width: MediaQuery.of(context).size.width - 32 - 90,
        height: 45,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              welcomeText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF155D97),
                fontStyle: FontStyle.italic,
              ),
            )));
  }

  Widget _buildWelcomeBackground(context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2EFF8), Color(0xFFC8E8F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/ai_chat_question.png',
              width: 18,
              height: 20,
            ),
            const SizedBox(width: 6),
            Text(
              S.current.rs_ai_chat_guess,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF24CBE5),
                fontStyle: FontStyle.italic,
              ),
            ),
            /*
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              onPressed: () {
                print("换一批");
              },
            ),*/
          ],
        ));
  }

  Widget _buildQuestions(context) {
    return Container(
        margin: const EdgeInsets.only(left: 0, top: 72, bottom: 0, right: 0),
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD6E8FD), Color(0xFFF2D9EF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: const Color(0xFFF8EFF8),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _buildTitleBar(context),
            Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 0, bottom: 16, right: 16),
                child: Column(
                  children: questions
                      .asMap()
                      .map((index, title) => MapEntry(
                            index,
                            _buildOptionItem(title, index == 0),
                          ))
                      .values
                      .toList(),
                ))
          ],
        ));
  }

  Widget _buildOptionItem(String title, bool isFirst) {
    return GestureDetector(
        onTap: () {
          onSend?.call(title);
        },
        child: Container(
          margin: EdgeInsets.only(top: isFirst ? 0 : 4, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF36338B),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF36338B)),
            ],
          ),
        ));
  }
}
