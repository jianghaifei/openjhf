import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/rs_color.dart';
import '../generated/assets.dart';

///四种视图状态
enum CardLoadState {
  stateLoading,
  stateSuccess,
  stateError,
}

class CardLoadStateLayout extends StatefulWidget {
  const CardLoadStateLayout(
      {super.key,
      required this.state,
      required this.successWidget,
      required this.reloadCallback,
      this.errorCode,
      this.errorMessage,
      this.loadingTitle});

  final CardLoadState state; //页面状态
  final String? loadingTitle;
  final Widget successWidget; //成功视图
  final VoidCallback reloadCallback;
  final String? errorCode; //请求错误码
  final String? errorMessage; //请求错误信息

  @override
  State<CardLoadStateLayout> createState() => _CardLoadStateLayoutState();
}

class _CardLoadStateLayoutState extends State<CardLoadStateLayout> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    animation = ColorTween(
      begin: RSColor.color_0xFF5C57E6.withOpacity(0.4),
      end: RSColor.color_0xFF5C57E6,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.w),
      child: _buildWidget(),
    );
  }

  ///根据不同状态来显示不同的视图
  Widget? _buildWidget() {
    switch (widget.state) {
      case CardLoadState.stateSuccess:
        return widget.successWidget;
      case CardLoadState.stateError:
        return _errorView();
      case CardLoadState.stateLoading:
        return _loadingView();
      default:
        return null;
    }
  }

  Widget _loadingView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientCircularProgressIndicator(
              colors: [
                RSColor.color_0xFF5C57E6,
                RSColor.color_0xFF5C57E6.withOpacity(0.5),
                Colors.white,
              ],
            ),
            if (widget.loadingTitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.loadingTitle ?? '',
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _errorView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.errorCode != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                widget.errorCode ?? '',
                style: const TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Text(
                widget.errorMessage ?? '',
                style: const TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          InkWell(
            onTap: () => widget.reloadCallback(),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                Assets.imageRefresh,
                color: RSColor.color_0xFF5C57E6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientCircularProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final double value; // Current value, ranging from 0.0 to 1.0
  final List<Color> colors;

  const GradientCircularProgressIndicator({
    super.key,
    this.strokeWidth = 4.0,
    this.value = 1,
    this.colors = const [Colors.blue, Colors.red],
  });

  @override
  State<GradientCircularProgressIndicator> createState() => _GradientCircularProgressIndicatorState();
}

class _GradientCircularProgressIndicatorState extends State<GradientCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    debugPrint("GradientCircularProgressIndicator dispose");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2.0 * math.pi,
          child: SizedBox(
            width: 28,
            height: 28,
            child: CustomPaint(
              painter: _GradientCircularProgressPainter(
                strokeWidth: widget.strokeWidth,
                colors: widget.colors,
                value: widget.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final double value; // Current value
  final List<Color> colors;

  _GradientCircularProgressPainter({
    required this.strokeWidth,
    required this.value,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create stops array based on the number of colors
    List<double> stops = List.generate(colors.length, (index) => index / (colors.length - 1));

    // Use a sweep gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    paint.shader = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      colors: colors,
      stops: stops,
      transform: const GradientRotation(math.pi * 1.5),
    ).createShader(rect);

    // Draw the arc around a full circle
    double angle = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
