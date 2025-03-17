import 'package:flutter/cupertino.dart';

import '../../config/rs_color.dart';
import '../../model/business_topic/business_topic_type_enum.dart';
import '../../model/business_topic/metrics_card/module_metrics_card_entity.dart';

class ChartTooltips {
  int colorIndex = -1;

  Widget createChartTooltipWidget(ModuleMetricsCardChartAxisY? yMetric) {
    return createChartGroupTooltipWidget(yMetric, ifMultiple: false);
  }

  Widget createChartGroupTooltipWidget(
    ModuleMetricsCardChartAxisY? yMetric, {
    ModuleMetricsCardChartAxisY? yCompareDayMetric,
    ModuleMetricsCardChartAxisY? yCompareWeekMetric,
    ModuleMetricsCardChartAxisY? yCompareMonthMetric,
    ModuleMetricsCardChartAxisY? yCompareYearMetric,
    bool ifMultiple = true,
  }) {
    bool showDimValue = true;
    if (yMetric?.dimDisplayValue != null &&
        (yMetric?.dimDisplayValue == yCompareDayMetric?.dimDisplayValue ||
            yMetric?.dimDisplayValue == yCompareWeekMetric?.dimDisplayValue ||
            yMetric?.dimDisplayValue == yCompareMonthMetric?.dimDisplayValue ||
            yMetric?.dimDisplayValue == yCompareYearMetric?.dimDisplayValue)) {
      showDimValue = false;
    }

    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        decoration: ShapeDecoration(
          color: RSColor.color_0xFFFFFFFF,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          shadows: [
            BoxShadow(
              color: RSColor.color_0xFFDCDCDC,
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!showDimValue)
              Text(
                yMetric?.dimDisplayValue ?? '',
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (!showDimValue)
              Text(
                yMetric?.metricName ?? '',
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            _createChartGroupTooltipSubWidget(
              yMetric?.dimDisplayValue,
              yMetric?.metricName,
              yMetric?.metricDisplayValue,
              yMetric?.metricDataType,
              yMetric?.extraDisplayInfo,
              showDimValue: showDimValue,
            ),
            if (ifMultiple && yCompareDayMetric != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _createChartGroupTooltipSubWidget(
                  yCompareDayMetric.dimDisplayValue,
                  yCompareDayMetric.metricName,
                  yCompareDayMetric.metricDisplayValue,
                  yCompareDayMetric.metricDataType,
                  yCompareDayMetric.extraDisplayInfo,
                  showDimValue: showDimValue,
                ),
              ),
            if (ifMultiple && yCompareWeekMetric != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _createChartGroupTooltipSubWidget(
                  yCompareWeekMetric.dimDisplayValue,
                  yCompareWeekMetric.metricName,
                  yCompareWeekMetric.metricDisplayValue,
                  yCompareWeekMetric.metricDataType,
                  yCompareWeekMetric.extraDisplayInfo,
                  showDimValue: showDimValue,
                ),
              ),
            if (ifMultiple && yCompareMonthMetric != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _createChartGroupTooltipSubWidget(
                  yCompareMonthMetric.dimDisplayValue,
                  yCompareMonthMetric.metricName,
                  yCompareMonthMetric.metricDisplayValue,
                  yCompareMonthMetric.metricDataType,
                  yCompareMonthMetric.extraDisplayInfo,
                  showDimValue: showDimValue,
                ),
              ),
            if (ifMultiple && yCompareYearMetric != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _createChartGroupTooltipSubWidget(
                  yCompareYearMetric.dimDisplayValue,
                  yCompareYearMetric.metricName,
                  yCompareYearMetric.metricDisplayValue,
                  yCompareYearMetric.metricDataType,
                  yCompareYearMetric.extraDisplayInfo,
                  showDimValue: showDimValue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _createChartGroupTooltipSubWidget(String? dimValue, String? metricName, String? metricValue,
      MetricOrDimDataType? metricDataType, String? extraDisplayInfo,
      {bool showDimValue = true}) {
    colorIndex++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dimValue != null)
          if (showDimValue)
            Text(
              dimValue,
              style: TextStyle(
                color: RSColor.color_0x40000000,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
        if (metricValue != null)
          Text(
            metricValue,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: ShapeDecoration(
                color: RSColor.getChartColor(colorIndex),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                extraDisplayInfo ?? metricName ?? '*',
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
