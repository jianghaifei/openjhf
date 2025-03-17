import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef VerifySureCallback = void Function();

class DebugVerifyDialog {
  void showDebugVerifyDialog(BuildContext context,
      {String? title, String? placeholderText, required VerifySureCallback callback}) {
    TextEditingController textEditingController = TextEditingController();

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title ?? "Verify"),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: textEditingController,
                    placeholder: placeholderText ?? "please Enter Password",
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
                  child: const Text('Cancel')),
              CupertinoDialogAction(
                  onPressed: () {
                    if (textEditingController.text == 'Rs123456') {
                      Navigator.pop(context);
                      callback.call();
                    } else {
                      EasyLoading.showError("WRONG PASSWORD");
                    }
                  },
                  child: const Text("Sure")),
            ],
          );
        });
  }
}
