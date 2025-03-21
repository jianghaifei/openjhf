import 'package:flutter/material.dart';

class FixedIndicator extends Decoration {
  final BoxPainter _painter;

  FixedIndicator({required Color color, required double width, required bool isScrollable})
      : _painter = _FixedPainter(color, width, isScrollable);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _FixedPainter extends BoxPainter {
  final Paint _paint;
  final double width;
  final bool isScrollable;

  _FixedPainter(Color color, this.width, this.isScrollable)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    double xPosition = offset.dx + (configuration.size!.width - width) / 2;
    Rect rect = Rect.fromLTWH(
      xPosition,
      configuration.size!.height - (isScrollable ? 0 : 3), // 3是指示器的厚度
      width,
      3, // 指示器的厚度
    );

    RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    canvas.drawRRect(rRect, _paint);
  }
}

class BubbleTabIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final double indicatorRadius;
  @override
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry insets;
  final TabBarIndicatorSize tabBarIndicatorSize;

  const BubbleTabIndicator({
    this.indicatorHeight = 20.0,
    this.indicatorColor = Colors.red,
    this.indicatorRadius = 100.0,
    this.tabBarIndicatorSize = TabBarIndicatorSize.label,
    this.padding = const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
    this.insets = const EdgeInsets.symmetric(horizontal: 5.0),
  });

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is BubbleTabIndicator) {
      return BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(a.padding, padding, t)!,
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is BubbleTabIndicator) {
      return BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(padding, b.padding, t)!,
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(this, onChanged);
  }
}

class _BubblePainter extends BoxPainter {
  _BubblePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final BubbleTabIndicator decoration;

  double get indicatorHeight => decoration.indicatorHeight;

  Color get indicatorColor => decoration.indicatorColor;

  double get indicatorRadius => decoration.indicatorRadius;

  EdgeInsetsGeometry get padding => decoration.padding;

  EdgeInsetsGeometry get insets => decoration.insets;

  TabBarIndicatorSize get tabBarIndicatorSize => decoration.tabBarIndicatorSize;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    Rect indicator = padding.resolve(textDirection).inflateRect(rect);

    if (tabBarIndicatorSize == TabBarIndicatorSize.tab) {
      indicator = insets.resolve(textDirection).deflateRect(rect);
    }

    return Rect.fromLTWH(
      indicator.left,
      indicator.top,
      indicator.width,
      indicator.height,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = Offset(offset.dx, (configuration.size!.height / 2) - indicatorHeight / 2) &
        Size(configuration.size!.width, indicatorHeight);
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    final Paint paint = Paint();
    paint.color = indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)), paint);
  }
}
