import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'amount_limit_state.dart';

class AmountLimitLogic extends GetxController {
  final AmountLimitState state = AmountLimitState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  List<DropdownMenuItem<String>> createSymbolItems() {
    return state.listSymbols
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ))
        .toList();
  }
}
