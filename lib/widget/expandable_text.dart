import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../config/rs_color.dart';

class RSExpandCollapseText extends StatefulWidget {
  const RSExpandCollapseText({
    super.key,
    required this.text,
    this.textStyle,
    this.endOfTextStyle,
    this.expandStr = "展开",
    this.collapseStr = "收起",
    this.maxLines = 5,
    this.isExpanding,
    this.onChangeExpandStatus,
    this.isResponseAllText,
  });

  final String text;
  final TextStyle? textStyle;
  final TextStyle? endOfTextStyle;
  final String expandStr; //展开
  final String collapseStr; //收起
  final int? maxLines; //默认5行
  final bool? isExpanding; //初始是否 展开还是收起
  final ValueChanged<bool>? onChangeExpandStatus; //通知外面当前展开还是收起的状态
  final bool? isResponseAllText; //是否所有文本都响应展开或收起操作

  @override
  State<RSExpandCollapseText> createState() => ExpandableTextState();
}

class ExpandableTextState extends State<RSExpandCollapseText> {
  bool isExpanding = true;

  @override
  void initState() {
    if (widget.isExpanding != null) {
      isExpanding = widget.isExpanding!;
    }
    super.initState();
  }

  //是否超出了最大行
  bool _isTextExceedMaxLines(String text, TextStyle textStyle, int maxLine, double maxWidth) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    if (textPainter.didExceedMaxLines) {
      return true;
    } else {
      return false;
    }
  }

  //时间复杂度O(n),这个还可以优化,
  String _willDisplayText(String text, double maxWidth) {
    for (var i = 0; i < text.length; i++) {
      String subStr = '${text.substring(0, i)}...${widget.expandStr}';
      if (_isTextExceedMaxLines(
              subStr,
              widget.textStyle ??
                  TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
              widget.maxLines!,
              maxWidth) ==
          false) {
        continue;
      } else {
        //肯定会有值
        return '${text.substring(0, i - 1)}...';
      }
    }
    return '';
  }

  void _changeStatus() {
    setState(() {
      isExpanding = !isExpanding;
      if (widget.onChangeExpandStatus != null) {
        widget.onChangeExpandStatus!(isExpanding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //是否超过规定行数
        bool isTextExceed = _isTextExceedMaxLines(
            widget.text,
            widget.textStyle ??
                TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
            widget.maxLines!,
            constraints.maxWidth);
        //超过规定行数了 要显示展开按钮
        if (isTextExceed) {
          if (isExpanding) {
            return GestureDetector(
              onTap: () {
                if (widget.isResponseAllText != null && widget.isResponseAllText! == true) {
                  _changeStatus();
                }
              },
              child: RichText(
                text: TextSpan(
                    text: _willDisplayText(widget.text, constraints.maxWidth),
                    style: widget.textStyle ??
                        TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                    children: [
                      TextSpan(
                          text: widget.expandStr,
                          style: widget.endOfTextStyle ??
                              TextStyle(
                                color: RSColor.color_0xFF5C57E6,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _changeStatus();
                            }),
                    ]),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                _changeStatus();
              },
              child: RichText(
                text: TextSpan(
                    text: widget.text,
                    style: widget.textStyle ??
                        TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                    children: [
                      TextSpan(
                          text: widget.collapseStr,
                          style: widget.endOfTextStyle ??
                              TextStyle(
                                color: RSColor.color_0xFF5C57E6,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _changeStatus();
                            }),
                    ]),
              ),
            );
          }
        } else {
          //不超过规定行数，直接全部显示
          return Text(
            widget.text,
            style: widget.textStyle,
          );
        }
      },
    );
  }
}
