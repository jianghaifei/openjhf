import 'package:flutter/material.dart';

class AIChatDotsLoading extends StatefulWidget {
  const AIChatDotsLoading({super.key});

  @override
  _AIChatDotsLoadingState createState() => _AIChatDotsLoadingState();
}

class _AIChatDotsLoadingState extends State<AIChatDotsLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _activeDotAnimation;
  late List<Animation<double>> _animations;

  final List<Color> _dotColors = [
    const Color(0xFF23E2FF),
    const Color(0xFF23A7FF),
    const Color(0xFF235EFF),
  ];

  @override
  void initState() {
    super.initState();

    // 创建一个无限循环的动画控制器
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    // 控制点的索引 (0, 1, 2, 0, 1, 2...)
    _activeDotAnimation = IntTween(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // 创建每个点的动画效果
    _animations = [
      Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 1 / 3, curve: Curves.easeInOut),
        ),
      ),
      Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(1 / 3, 2 / 3, curve: Curves.easeInOut),
        ),
      ),
      Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(2 / 3, 1.0, curve: Curves.easeInOut),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          margin: const EdgeInsets.only(left: 16, bottom: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FF),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double scale = 1.0;

                  if (_activeDotAnimation.value == index) {
                    scale = _animations[index].value;
                  }

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _dotColors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              );
            }),
          )),
      const Expanded(child: Text(''))
    ]);
  }
}
