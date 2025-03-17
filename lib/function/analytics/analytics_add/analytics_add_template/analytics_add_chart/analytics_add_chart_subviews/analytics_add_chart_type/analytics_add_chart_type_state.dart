import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AnalyticsAddChartTypeState {
  /// 选中Chart type 下标
  var selectedChartLabelIndex = RxInt(-1);

  /// 选中Chart type Change 下标
  var selectedChartLabelChangeIndex = RxInt(-1);

  /// 选中Chart type Change Count 下标
  var selectedChartLabelDisplayCountIndex = RxInt(-1);

  AnalyticsAddChartTypeState() {
    ///Initialize variables
  }
}
