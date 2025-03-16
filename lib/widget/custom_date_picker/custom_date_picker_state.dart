import 'package:get/get.dart';

class CustomDatePickerState {
  var years = <int>[].obs;
  var weeks = <String>[].obs;

  var selectedYearIndex = 0.obs;
  var selectedWeekIndex = 0.obs;

  CustomDatePickerState() {
    ///Initialize variables
  }
}
