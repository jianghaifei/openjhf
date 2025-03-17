import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../function/login/account_manager/account_manager.dart';
import 'exception.dart';

/// TODO 参考文章：https://juejin.cn/post/7061806192980410382

Future request(Function() block, {bool showLoading = false, bool Function(ApiException)? onError}) async {
  try {
    await loading(block, isShowLoading: showLoading);
  } catch (e) {
    handleException(ApiException.from(e), onError: onError, isShowLoading: showLoading);
  }
  return;
}

bool handleException(ApiException exception, {bool Function(ApiException)? onError, bool isShowLoading = false}) {
  if (onError?.call(exception) == true) {
    return true;
  }
  if (exception.code != "000") {
    if (isShowLoading) {
      EasyLoading.showError("${exception.code}\n${exception.message}");
    }

    if (exception.code == "401") {
      RSAccountManager().logout();
    }

    return true;
  }
  if (isShowLoading) {
    EasyLoading.showError(exception.message ?? ApiException.unknownException);
  }

  return false;
}

Future loading(Function block, {bool isShowLoading = true}) async {
  if (isShowLoading) {
    showLoading();
  }

  try {
    await block();
  } catch (e) {
    rethrow;
  } finally {
    if (isShowLoading) {
      dismissLoading();
    }
  }
  return;
}

void showLoading() async {
  await EasyLoading.show();
}

void dismissLoading() async {
  await EasyLoading.dismiss();
}
