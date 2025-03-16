import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastManager {
  static void configLoading() {
    EasyLoading
        .instance
        // ..loadingStyle = EasyLoadingStyle.custom
        // ..maskType = EasyLoadingMaskType.custom
        // ..progressColor = Colors.white
        // ..maskColor = Colors.black.withOpacity(0.1)
        // ..backgroundColor = Colors.black12
        // ..indicatorColor = Colors.white
        // ..textColor = Colors.white
        .userInteractions = false;
    // ..animationStyle = EasyLoadingAnimationStyle.scale
    // ..indicatorType = EasyLoadingIndicatorType.fadingCircle;

    /**
     *      /// 例子一：
        EasyLoading.show(status: '测试啊啊啊啊');
        Future.delayed(const Duration(seconds: 5), () {
        EasyLoading.dismiss();
        });

        /// 例子二：
        EasyLoading.showToast('status');

        /// 例子三：
        _progress = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
        EasyLoading.showProgress(_progress, status: '${(_progress * 100).toStringAsFixed(0)}%');
        _progress += 0.03;

        if (_progress >= 1) {
        _timer?.cancel();
        EasyLoading.dismiss();
        }
        });
     */
  }
}
