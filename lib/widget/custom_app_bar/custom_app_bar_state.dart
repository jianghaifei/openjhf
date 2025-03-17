import '../../function/login/account_manager/account_manager.dart';
import 'custom_date_tool_widget/custom_date_tool_widget_logic.dart';

class CustomAppBarState {
  /// 自定义日期组件的枚举值：日/月
  CustomDateToolEnum customDateToolEnum = CustomDateToolEnum.DAY;

  List<CompareDateRangeType>? compareDateRangeTypes = [];
  List<List<DateTime>>? compareDateTimeRanges = [];

  CustomAppBarState() {
    ///Initialize variables
  }
}
