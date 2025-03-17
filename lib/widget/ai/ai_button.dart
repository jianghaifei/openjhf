import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../router/ai_routes.dart';

class AIButton extends StatefulWidget {
  const AIButton({super.key});

  @override
  State<AIButton> createState() => _AIButtonState();
}

class _AIButtonState extends State<AIButton> {
  final bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // _checkVisibility();

    // _isVisible = widget.isVisible;
  }

  // Future<void> _checkVisibility() async {
  //   var envString = SpUtil.getString(RSAppCompileEnv.appCompileEnvKey);
  //   if (envString == 'sea' || envString == 'eu' || envString == 'us' || envString == 'cn') {
  //     setState(() {
  //       _isVisible = false;
  //     });
  //   } else {
  //     setState(() {
  //       _isVisible = true;
  //     });
  //   }
  //
  //   // 这里可以调用接口获取是否显示
  //   // Example: var response = await someApiRequest();
  //   // setState(() {
  //   //   _isVisible = response.shouldDisplay;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(AIRoutes.aiChat);
      },
      child: Container(width: 50, height: 43, child: _buildRobot()),
    );
  }

  Widget _buildRobot() {
    return Image.asset(
      'assets/image/ai_chat_robot_2.png',
      width: 50,
      height: 43,
    );
  }
}
