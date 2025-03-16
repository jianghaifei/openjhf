import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../model/chart_data/rs_chart_data.dart';
import '../../../../model/target_manage/target_manage_overview_entity.dart';
import 'target_analysis_group_state.dart';

class TargetAnalysisGroupLogic extends GetxController {
  final TargetAnalysisGroupState state = TargetAnalysisGroupState();

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

  void setChartData(TargetManageOverviewShopAchievement? shopAchievement) {
    List<RSChartData> listFlSpot = [];

    if (shopAchievement == null ||
        shopAchievement.reportData == null ||
        shopAchievement.reportData?.rows == null ||
        shopAchievement.reportData!.rows!.isEmpty) {
      listFlSpot.add(RSChartData("one", "one", 100, RSColor.chartColors.last));
    } else {
      int index = 0;
      shopAchievement.reportData?.rows?.forEach((element) {
        var tmpMetric = element.metrics?.first;
        if (index < RSColor.chartColors.length) {
          listFlSpot.add(RSChartData(tmpMetric?.code ?? "$index", tmpMetric?.code ?? "$index",
              tmpMetric?.proportion ?? 0.0, RSColor.chartColors[index]));
        } else {
          listFlSpot.add(RSChartData(tmpMetric?.code ?? "$index", tmpMetric?.code ?? "$index",
              tmpMetric?.proportion ?? 0.0, RSColor.chartColors.last));
        }

        index++;
      });
    }

    state.allChartData.value = listFlSpot;
    // 更新chart
    state.chartSeriesController?.updateDataSource();
  }
}
