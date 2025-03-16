import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup_child.dart';

class RSDropPopupRoute extends PopupRoute {
  final RSPopupChild child;
  final Offset? offsetLT, offsetRB;
  final Duration duration;
  final bool cancelable;
  final bool outsideTouchCancelable;
  final bool darkEnable;
  final List<RRect>? highlights;

  RSDropPopupRoute({
    required this.child,
    this.offsetLT,
    this.offsetRB,
    this.cancelable = true,
    this.outsideTouchCancelable = true,
    this.darkEnable = true,
    this.duration = const Duration(milliseconds: 200),
    this.highlights,
  });

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return PopRouteWidget(
      offsetLT: offsetLT,
      offsetRB: offsetRB,
      duration: duration,
      cancelable: cancelable,
      outsideTouchCancelable: outsideTouchCancelable,
      darkEnable: darkEnable,
      highlights: highlights,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => duration;

  static pop(BuildContext context) {
    _PopRouteWidgetState.of(context)?.dismissPopupRoute();
    Navigator.of(context).pop();
  }

  static setHighlights(BuildContext context, List<RRect> highlights) {
    _PopRouteWidgetState.of(context)?.highlights = highlights;
  }
}

class PopRouteWidget extends StatefulWidget {
  final RSPopupChild child;
  final Offset? offsetLT, offsetRB;
  final Duration duration;
  final bool cancelable;
  final bool outsideTouchCancelable;
  final bool darkEnable;
  final List<RRect>? highlights;

  const PopRouteWidget({
    super.key,
    required this.child,
    this.offsetLT,
    this.offsetRB,
    required this.duration,
    required this.cancelable,
    required this.outsideTouchCancelable,
    required this.darkEnable,
    required this.highlights,
  });

  @override
  State<PopRouteWidget> createState() => _PopRouteWidgetState();
}

class _PopRouteWidgetState extends State<PopRouteWidget> with SingleTickerProviderStateMixin {
  late Animation<double> alphaAnim;
  late AnimationController alphaController;
  List<RRect> _highlights = [];

  static final GlobalKey popRouteWidgetStateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    highlights = widget.highlights ?? [];
    alphaController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    alphaAnim = Tween<double>(begin: 0, end: 127).animate(alphaController);
    alphaController.forward();
  }

  static _PopRouteWidgetState? of(BuildContext context) {
    return _PopRouteWidgetState.popRouteWidgetStateKey.currentContext?.findAncestorStateOfType<_PopRouteWidgetState>();
  }

  dismissPopupRoute() {
    alphaController.reverse();
    widget.child.dismiss();
  }

  set highlights(List<RRect> value) {
    setState(() {
      _highlights = value;
    });
  }

  @override
  void dispose() {
    alphaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      key: popRouteWidgetStateKey,
      canPop: true,
      onPopInvoked: (didPop) {
        if (widget.cancelable) {
          dismissPopupRoute();
        }
        return;
      },
      child: GestureDetector(
        onTap: () {
          if (widget.outsideTouchCancelable) {
            dismissPopupRoute();
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: <Widget>[
            widget.darkEnable
                ? AnimatedBuilder(
                    animation: alphaController,
                    builder: (_, __) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: widget.offsetLT?.dx ?? 0,
                          top: widget.offsetLT?.dy ?? 0,
                          right: widget.offsetRB?.dx ?? 0,
                          bottom: widget.offsetRB?.dy ?? 0,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(alphaAnim.value.toInt()),
                            BlendMode.modulate,
                          ),
                          child: Stack(
                            children: _buildDark(),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            widget.child,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDark() {
    List<Widget> widgets = [];
    widgets.add(Container(
      color: Colors.black,
    ));
    for (RRect highlight in _highlights) {
      widgets.add(Positioned(
        left: highlight.left,
        top: highlight.top,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: highlight.tlRadius,
                topRight: highlight.trRadius,
                bottomLeft: highlight.blRadius,
                bottomRight: highlight.brRadius,
              )),
          width: highlight.width,
          height: highlight.height,
        ),
      ));
    }
    return widgets;
  }
}
