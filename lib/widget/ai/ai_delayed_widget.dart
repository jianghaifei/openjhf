import 'package:flutter/material.dart';

class AIChatDelayedWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration animationDuration;

  const AIChatDelayedWidget({
    Key? key,
    required this.child,
    required this.delay,
    this.animationDuration = const Duration(milliseconds: 300), 
  }) : super(key: key);

  @override
  _AIChatDelayedWidgetState createState() => _AIChatDelayedWidgetState();
}

class _AIChatDelayedWidgetState extends State<AIChatDelayedWidget> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: widget.animationDuration,
      child: widget.child,
    );
  }
}
