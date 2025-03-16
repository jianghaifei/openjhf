import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../config/rs_color.dart';

/// 水平渐变进度条
class HorizontalGradientProgressIndicator extends StatelessWidget {
  final double progress; // 进度值，范围从 0.0 到 1.0

  const HorizontalGradientProgressIndicator({super.key, required this.progress});

  final double radius = 2.5;

  @override
  Widget build(BuildContext context) {
    double progressValue = progress;
    if (progress > 1) {
      progressValue = 1;
    } else if (progress < 0) {
      progressValue = 0;
    }

    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), // 背景圆角
          color: RSColor.color_0xFFF3F3F3, // 背景颜色
        ),
        child: FractionallySizedBox(
          widthFactor: progressValue, // 进度值
          alignment: Alignment.centerLeft, // 对齐到左侧
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius), // Clip圆角
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius), // 进度条圆角
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5C57E6).withOpacity(0.1),
                    Color(0xFF5C57E6).withOpacity(0.4),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 波浪进度条
class CircleWaveProgressBar extends StatefulWidget {
  // 调用方式
  //     return Center(
  //       child: CircleWaveProgressBar(
  //         size: Size(50, 50),
  //         percentage: 0.38,
  //         textStyle: TextStyle(
  //           color: RSColor.color_0x90000000,
  //           fontSize: 20,
  //         ),
  //         heightController: CircleWaterController(),
  //       ),
  //     );

  /// 控件大小
  final Size size;

  /// 进度条百分比，double形式的百分比， 即0.2就是20%
  final double percentage;

  /// 中间显示的文字
  final String? centerText;

  /// 中间显示的文字
  final TextStyle textStyle;

  /// 水的颜色
  final Color waterColor;

  /// 圆圈的颜色
  final Color strokeCircleColor;

  /// 圆圈的宽度
  final double circleStrokeWidth;

  /// 进度控制器
  final CircleWaterController heightController;

  /// 波距
  final double waveDistance;

  /// 浪的速度
  final double flowSpeed;

  /// 浪高
  final double waveHeight;

  const CircleWaveProgressBar({
    super.key,
    required this.size,
    required this.percentage,
    required this.textStyle,
    this.centerText,
    this.waterColor = const Color(0xFF5C57E6),
    this.strokeCircleColor = const Color(0xFF5C57E6),
    this.circleStrokeWidth = 2.0,
    required this.heightController,
    this.waveDistance = 45.0,
    this.flowSpeed = 1,
    this.waveHeight = 15.0,
  });

  @override
  State<StatefulWidget> createState() {
    return CircleWaveProgressBarState();
  }
}

class CircleWaveProgressBarState extends State<CircleWaveProgressBar> with SingleTickerProviderStateMixin {
  double _moveForwardDark = 0.0;
  double _moveForwardLight = 0.0;
  double _waterHeight = 0.0;
  double _percentage = 0.0;
  late Animation<double> animation;
  late AnimationController animationController;
  late VoidCallback _voidCallback;
  final Random _random = Random();
  late Picture _lightWavePic;
  late Picture _darkWavePic;

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // double value = min(widget.size.width, widget.size.height);
    // 波距
    // double waveDistance = value * 0.8;
    // // 浪高
    // double waveHeight = value / 8;
    // // 浪的速度
    // double flowSpeed = 0.2 * value / 100;

    if (widget.percentage > 1) {
      _percentage = 1;
    } else if (widget.percentage < 0) {
      _percentage = 0;
    } else {
      _percentage = widget.percentage;
    }

    _waterHeight = (1 - _percentage) * widget.size.height;
    widget.heightController.bezierCurveState = this;
    WavePictureGenerator generator =
        WavePictureGenerator(widget.size, widget.waveDistance, widget.waveHeight, widget.waterColor);
    _lightWavePic = generator.drawLightWave();
    _darkWavePic = generator.drawDarkWave();
    animationController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      widgetsBinding.addPersistentFrameCallback((callback) {
        if (mounted) {
          setState(() {
            _moveForwardDark = _moveForwardDark - widget.flowSpeed - _random.nextDouble() - 2;
            if (_moveForwardDark <= -widget.waveDistance * 4) {
              _moveForwardDark = _moveForwardDark + widget.waveDistance * 4;
            }

            _moveForwardLight = _moveForwardLight - widget.flowSpeed - _random.nextDouble();
            if (_moveForwardLight <= -widget.waveDistance * 4) {
              _moveForwardLight = _moveForwardLight + widget.waveDistance * 4;
            }
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: WaterBezierCurvePainter(
        moveForward: _moveForwardDark,
        centerText: widget.centerText,
        textStyle: widget.textStyle,
        circleStrokeWidth: widget.circleStrokeWidth,
        strokeCircleColor: widget.strokeCircleColor.withOpacity(0.2),
        percentage: _percentage,
        moveForwardLight: _moveForwardLight,
        lightWavePic: _lightWavePic,
        darkWavePic: _darkWavePic,
        waterHeight: _waterHeight,
      ),
    );
  }

  void changeWaterHeight(double h) {
    initAnimation(_percentage, h);
    animationController.forward();
  }

  void initAnimation(double old, double newPercentage) {
    animation = Tween(begin: old, end: newPercentage).animate(animationController);

    animation.addListener(_voidCallback = () {
      setState(() {
        double value = animation.value;
        _percentage = value;
        double newHeight = (1 - _percentage) * widget.size.height;
        _waterHeight = newHeight;
      });
    });

    animation.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        animation.removeListener(_voidCallback);
        animationController.reset();
      } else if (animationStatus == AnimationStatus.forward) {}
    });
  }
}

class WavePictureGenerator {
  final Size size;
  final double _waveDistance;
  final double _waveHeight;
  final Color _waterColor;
  late PictureRecorder _recorder;
  late int _maxCount;
  late double waterHeight;
  late double _targetWidth;
  late double _targetHeight;

  WavePictureGenerator(this.size, this._waveDistance, this._waveHeight, this._waterColor) {
    double oneDistance = _waveDistance * 4;
    int count = (size.width / oneDistance).ceil() + 1;
    _targetWidth = count * oneDistance;
    _maxCount = count * 4 + 1;
    waterHeight = size.height / 2;
    _targetHeight = size.height + waterHeight;
  }

  Picture drawDarkWave() {
    return drawWaves(true);
  }

  Picture drawLightWave() {
    return drawWaves(false);
  }

  Picture drawWaves(bool isDarkWave) {
    _recorder = PictureRecorder();
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, _targetWidth, _targetHeight));
    Paint paint = Paint();
    if (isDarkWave) {
      paint.color = _waterColor;
    } else {
      paint.color = _waterColor.withOpacity(0.4);
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(createBezierPath(isDarkWave), paint);
    return _recorder.endRecording();
  }

  Path createBezierPath(bool isDarkWave) {
    Path path = Path();
    path.moveTo(0, waterHeight);

    double lastPoint = 0.0;
    int m = 0;
    double waves;
    for (int i = 0; i < _maxCount - 2; i = i + 2) {
      if (m % 2 == 0) {
        waves = waterHeight + _waveHeight;
      } else {
        waves = waterHeight - _waveHeight;
      }
      path.cubicTo(
          lastPoint, waterHeight, lastPoint + _waveDistance, waves, lastPoint + _waveDistance * 2, waterHeight);
      lastPoint = lastPoint + _waveDistance * 2;
      m++;
    }
    if (isDarkWave) {
      path.lineTo(lastPoint, _targetHeight);
      path.lineTo(0, _targetHeight);
    } else {
      double waveHeightMax = waterHeight + _waveHeight + 10.0;
      path.lineTo(lastPoint, waveHeightMax);
      path.lineTo(0, waveHeightMax);
    }
    path.close();
    return path;
  }
}

class WaterBezierCurvePainter extends CustomPainter {
  final double moveForward;
  final Color strokeCircleColor;
  final TextStyle textStyle;
  final String? centerText;
  final double circleStrokeWidth;
  final double percentage;
  final double moveForwardLight;

  final Picture darkWavePic;
  final Picture lightWavePic;
  final double waterHeight;
  final Paint _paints = Paint();

  WaterBezierCurvePainter({
    required this.moveForward,
    required this.strokeCircleColor,
    required this.textStyle,
    this.centerText,
    required this.circleStrokeWidth,
    required this.percentage,
    required this.moveForwardLight,
    required this.darkWavePic,
    required this.lightWavePic,
    required this.waterHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint layerPaint = Paint();

    double halfSizeHeight = size.height / 2;
    double halfSizeWidth = size.width / 2;
    double radius = min(size.width, size.height) / 2;

    //由于在绘制图片的时候在波浪上面有50%高度的空白部分，所以在这里必须减掉
    double targetHeight = waterHeight - halfSizeHeight;

    canvas.saveLayer(Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);
    //绘制淡颜色的海浪
    canvas.save();
    canvas.translate(moveForwardLight, targetHeight);
    canvas.drawPicture(lightWavePic);
    //绘制深颜色的海浪
    double moveDistance = moveForward - moveForwardLight;
    canvas.translate(moveDistance, 0.0);
    canvas.drawPicture(darkWavePic);
    canvas.restore();

    layerPaint.blendMode = BlendMode.dstIn;
    canvas.saveLayer(Rect.fromLTRB(0.0, 0.0, size.width, size.height), layerPaint);

    canvas.drawCircle(Offset(halfSizeWidth, halfSizeHeight), radius, _paints);
    canvas.restore();
    canvas.restore();

    _paints.style = PaintingStyle.stroke;
    _paints.color = strokeCircleColor;
    _paints.strokeWidth = circleStrokeWidth;
    canvas.drawCircle(Offset(halfSizeWidth, halfSizeHeight), radius, _paints);

    TextPainter textPainter = TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = TextSpan(
      text: centerText ?? "${(percentage * 100).toStringAsFixed(2)}%",
      style: textStyle,
    );
    textPainter.layout();
    double textStarPositionX = halfSizeWidth - textPainter.size.width / 2;
    double textStarPositionY = halfSizeHeight - textPainter.size.height / 2;
    textPainter.paint(canvas, Offset(textStarPositionX, textStarPositionY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleWaterController {
  late CircleWaveProgressBarState bezierCurveState;

  void changeWaterHeight(double h) {
    bezierCurveState.changeWaterHeight(h);
  }
}
