import 'package:get/get.dart';

class AmountLimitState {
  List<String> listSymbols = ["~", "≥", "≤", ">", "<", "=", "≠"];

  var currentSymbol = ''.obs;

  AmountLimitState() {
    ///Initialize variables
    currentSymbol.value = listSymbols.first;
  }
}
