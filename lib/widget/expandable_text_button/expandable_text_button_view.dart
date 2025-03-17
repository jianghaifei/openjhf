import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_state.dart';
import 'package:get/get.dart';

import 'expandable_text_button_logic.dart';

class ExpandableTextButtonPage extends StatefulWidget {
  const ExpandableTextButtonPage({
    super.key,
    required this.textWidget,
    required this.iconWidget,
    required this.onPressed,
    this.spacingWidth = 4,
  });

  final Widget textWidget;
  final Widget? iconWidget;
  final Future<void> Function() onPressed;
  final double spacingWidth;

  @override
  State<ExpandableTextButtonPage> createState() => _ExpandableTextButtonPageState();
}

class _ExpandableTextButtonPageState extends State<ExpandableTextButtonPage> with SingleTickerProviderStateMixin {
  // final logic = Get.put(ExpandableTextButtonLogic());
  // final state = Get.find<ExpandableTextButtonLogic>().state;
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  late ExpandableTextButtonLogic logic;
  late ExpandableTextButtonState state;

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => ExpandableTextButtonLogic(), tag: tag);

    logic = Get.find<ExpandableTextButtonLogic>(tag: tag);
    state = Get.find<ExpandableTextButtonLogic>(tag: tag).state;

    state.animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    Get.delete<ExpandableTextButtonLogic>();
    final animationController = state.animationController;
    if (animationController != null) {
      animationController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleButtonPress() async {
    logic.toggle(); // 切换箭头状态

    // 调用传入的 onPressed 回调
    await widget.onPressed();

    logic.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleButtonPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.textWidget,
          SizedBox(width: widget.spacingWidth), // 设置文字和箭头之间的间距
          if (widget.iconWidget != null)
            RotationTransition(
              turns: Tween<double>(begin: 0, end: 0.5).animate(state.animationController ??
                  AnimationController(
                    duration: const Duration(milliseconds: 300),
                    vsync: this,
                  )),
              child: widget.iconWidget,
            ),
        ],
      ),
    );
  }
}
