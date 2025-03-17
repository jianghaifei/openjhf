import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'rs_popup_child.dart';

/// 弹窗容器
class RSCustomDropDownPage extends StatefulWidget with RSPopupChild {
  RSCustomDropDownPage({
    super.key,
    required this.paddingTop,
    this.customWidget,
    this.maxHeight,
  });

  /// 距上
  final double paddingTop;

  final Widget? customWidget;

  final double? maxHeight;

  final RSPopController controller = RSPopController();

  @override
  State<RSCustomDropDownPage> createState() => _RSCustomDropDownPageState();

  @override
  dismiss() {
    controller.dismiss();
  }
}

class _RSCustomDropDownPageState extends State<RSCustomDropDownPage> with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    widget.controller._bindState(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(_controller);
    _controller.forward();
  }

  dismiss() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(top: widget.paddingTop),
        child: ClipRect(
          child: SlideTransition(
            position: _animation,
            child: Container(
                width: 1.sw,
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight ?? 1.sh * 0.4,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                    )),
                child: widget.customWidget),
          ),
        ),
      ),
    );
  }
}

class RSPopController {
  late _RSCustomDropDownPageState state;

  _bindState(_RSCustomDropDownPageState state) {
    this.state = state;
  }

  dismiss() {
    state.dismiss();
  }
}
