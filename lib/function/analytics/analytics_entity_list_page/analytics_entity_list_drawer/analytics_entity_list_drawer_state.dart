import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AnalyticsEntityListDrawerState {
  var minimumController = TextEditingController();
  var maximumController = TextEditingController();

  // 是否显示Range
  bool ifShowRange = false;

  var currentSymbol = ''.obs;

  AnalyticsEntityListDrawerState() {
    ///Initialize variables
  }
}
