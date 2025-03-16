import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../model/chart_data/rs_chart_data.dart';

class TargetAnalysisGroupState {
  /// chart数据源
  var allChartData = <RSChartData>[].obs;

  /// Chart Controller
  CircularSeriesController? chartSeriesController;

  TargetAnalysisGroupState() {
    ///Initialize variables
  }
}
