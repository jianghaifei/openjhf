import '../../../function/login/account_manager/account_manager.dart';

class CompareToSettingState {
  List<int> selectedIndexList = [];

  List<int> intersectingElements = [];

  List<CompareDateRangeType> compareToDateRangeTypes = [];

  List<DateTime> dateTimeRange = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  ];

  CompareToSettingState() {
    ///Initialize variables
  }
}
