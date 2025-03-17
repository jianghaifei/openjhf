import 'package:flutter/material.dart';
import 'dart:math';
import 'ai_chat_theme.dart';

class AIChatCustomInputWidget extends StatefulWidget {
  final void Function(String text) onSend;
  final void Function() onNewSession;
  final bool isReplying;

  const AIChatCustomInputWidget(
      {required this.onSend,
      required this.onNewSession,
      Key? key,
      this.isReplying = false})
      : super(key: key);

  @override
  _AIChatCustomInputWidgetState createState() =>
      _AIChatCustomInputWidgetState();
}

class _AIChatCustomInputWidgetState extends State<AIChatCustomInputWidget> {
  final TextEditingController _controller = TextEditingController();
  //inal FocusNode _focusNode = FocusNode();
  int _currentLines = 1;

  double _calculateBorderRadius(int lines) {
    return 50 - (min(lines, 5) - 1) * 6.0;
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isReplying) {
      //_focusNode.requestFocus();
    }

    _controller.addListener(() {
      final lineCount = '\n'.allMatches(_controller.text).length + 1;
      if (lineCount != _currentLines) {
        setState(() {
          _currentLines = lineCount;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AIChatCustomInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    /*
    if (widget.isReplying != oldWidget.isReplying && !widget.isReplying) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }*/
  }

  @override
  void dispose() {
    //_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: AIChatTheme.horizontalMargin,
          top: 12,
          right: AIChatTheme.horizontalMargin,
          bottom: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          //colors: [Color(0xFFD4E4FF), Color(0xFFD7F3FF)], // 渐变的颜色
          colors: [Color(0xFFD4E6FF), Color(0xFFD4E6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight, // 渐变结束位置
        ),
      ),
      child: Row(
        children: [
          buildAddIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: buildInput(),
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: !widget.isReplying ? Colors.white : Color(0xFFFAFAFA),
        borderRadius: BorderRadius.all(
            Radius.circular(_calculateBorderRadius(_currentLines))),
      ),
      child: TextField(
        controller: _controller,
        //focusNode: _focusNode, 
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: buildSendIcon(),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        enabled: !widget.isReplying,
      ),
    );
  }

  Widget buildAddIcon() {
    return GestureDetector(
      onTap: () {
        if (!widget.isReplying) {
          widget.onNewSession();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/image/ai_chat_new.png',
          width: 30,
          height: 30,
          color: widget.isReplying ? Colors.grey : null,
        ),
      ),
    );
  }

  Widget buildSendIcon() {
    return GestureDetector(
      onTap: () {
        if (!widget.isReplying && _controller.text.trim().isNotEmpty) {
          widget.onSend(_controller.text.trim());
          _controller.clear();
        }
      },
      child: ColorFiltered(
        colorFilter: widget.isReplying
            ? const ColorFilter.mode(Color(0xFFFAFAFA), BlendMode.saturation)
            : ColorFilter.mode(Colors.transparent, BlendMode.saturation),
        child: Image.asset(
          'assets/image/ai_chat_send.png',
          width: 32,
          height: 32,
        ),
      ),
    );
  }
}
