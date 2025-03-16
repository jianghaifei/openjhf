import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import 'custom_date_tool_widget_logic.dart';

class CustomDateToolWidgetState {
  /// 启用最大日期
  bool enableMaxDate = true;

  var currentDateToolEnumType = CustomDateToolEnum.DAY.obs;

  /// 选中快捷时间下标
  int? selectedQuickDateIndex;

  /// 自定义时间范围
  // var currentCustomTimeRange = false.obs;

  /// 时间范围
  List<String> timeRange = [];

  /// 对比时间范围标题
  var compareDateRangeTypesTitle = ''.obs;
  var compareDateRangeTypes = <CompareDateRangeType>[].obs;

  /// 是否最新日期
  var isLast = false.obs;

  /// 开始时间
  var startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  /// 结束时间
  var endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  CustomDateToolWidgetState() {
    ///Initialize variables
  }
}
