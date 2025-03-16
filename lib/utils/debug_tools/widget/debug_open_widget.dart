import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../debug_tools_view.dart';
import 'debug_verify_dialog.dart';

class DebugOpenWidget extends StatelessWidget {
  const DebugOpenWidget({super.key, required this.child, required this.pageReturnsCallback});

  final Widget child;
  final VoidCallback pageReturnsCallback;

  static Timer? _timer;

  void _invalidateTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        _invalidateTimer();
        _timer ??= Timer.periodic(const Duration(seconds: openDebugToolsTriggerTime), (timer) {
          _invalidateTimer();
          DebugVerifyDialog().showDebugVerifyDialog(context, callback: () async {
            await Get.to(() => const DebugToolsPage());
            pageReturnsCallback.call();
          });
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        _invalidateTimer();
      },
      onLongPressUp: () {
        _invalidateTimer();
      },
      child: child,
    );
  }
}
