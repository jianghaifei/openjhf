import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ResetCallback = void Function();
typedef DoneCallback = void Function(String value);

class DebugNetworkDialog {
  void showDebugNetworkDialog(BuildContext context,
      {String? title,
      String? placeholderText,
      String? contentText,
      required ResetCallback resetCallback,
      required DoneCallback doneCallback}) {
    TextEditingController textEditingController = TextEditingController();

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title ?? "输入IP"),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: textEditingController,
                    placeholder: placeholderText ?? "请输入",
                    clearButtonMode: OverlayVisibilityMode.editing,
                    placeholderStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400, color: CupertinoColors.lightBackgroundGray),
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('取消')),
              CupertinoDialogAction(
                  onPressed: () {
                    resetCallback.call();
                    Navigator.pop(context);
                  },
                  child: const Text("重置", style: TextStyle(color: Colors.purple))),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    doneCallback.call(textEditingController.text);
                  },
                  child: const Text(
                    "确定",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }
}
