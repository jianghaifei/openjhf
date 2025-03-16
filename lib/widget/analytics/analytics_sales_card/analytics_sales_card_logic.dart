import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/business_topic/metrics_card/module_metrics_card_entity.dart';
import 'package:flutter_report_project/router/app_routes.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../utils/date_util.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../card_load_state_layout.dart';
import 'analytics_sales_card_state.dart';

class AnalyticsSalesCardLogic extends GetxController {
  final AnalyticsSalesCardState state = AnalyticsSalesCardState();

  @override
  void onReady() {
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  Future<void> loadData(TopicTemplateTemplatesNavsTabsCards? cardMetadata) async {
    if (cardMetadata != null) {
      state.cardTemplateData.value = cardMetadata;
      await getMetricsData(state.cardTemplateData.value.cardMetadata);
    } else {
      state.loadState.value = CardLoadState.stateError;
    }
  }

  Future<void> getMetricsData(TopicTemplateTemplatesNavsTabsCardsCardMetadata? metadata) async {
    await request(() async {
      state.loadState.value = CardLoadState.stateLoading;

      Map<String, dynamic> params = {
        "shopIds": state.shopIds ?? RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
        "date": RSDateUtil.dateRangeToListString(RSAccountManager().timeRange),
        "dateType": state.customDateToolEnum.name,
      };

      if (state.displayTime != null && state.displayTime!.isNotEmpty) {
        params['date'] = RSDateUtil.dateRangeToListString(state.displayTime!);
        if (state.compareDateTimeRanges != null &&
            state.compareDateTimeRanges!.isNotEmpty &&
            state.compareDateRangeTypes != null &&
            state.compareDateRangeTypes!.isNotEmpty) {
          params.addAll(
              AnalyticsTools.returnCompareDateRangeParams(state.compareDateRangeTypes!, state.compareDateTimeRanges!));
        }
      } else {
        /// compareDate
        if (RSAccountManager().dayCompareDate.isNotEmpty) {
          params["dayCompareDate"] = RSAccountManager().getDayCompareDate;
        }

        if (RSAccountManager().weekCompareDate.isNotEmpty) {
          params["weekCompareDate"] = RSAccountManager().getWeekCompareDate;
        }

        if (RSAccountManager().monthCompareDate.isNotEmpty) {
          params["monthCompareDate"] = RSAccountManager().getMonthCompareDate;
        }

        if (RSAccountManager().yearCompareDate.isNotEmpty) {
          params["yearCompareDate"] = RSAccountManager().getYearCompareDate;
        }
      }

      /// cardType
      params["cardType"] = RSUtils.enumToString(metadata?.cardType);

      /// metrics
      var metrics = [];
      metadata?.metrics?.forEach((element) {
        Map<String, dynamic> metricsParams = {};

        metricsParams["code"] = element.metricCode;
        metricsParams["name"] = element.metricName;
        metricsParams["reportId"] = element.reportId;

        metrics.add(metricsParams);
      });
      if (metrics.isNotEmpty) {
        params["metrics"] = metrics;
      }

      /// dims
      var dims = [];
      metadata?.dims?.forEach((element) {
        Map<String, dynamic> dimsParams = {};

        dimsParams["code"] = element.dimCode;
        dimsParams["reportId"] = element.reportId;

        dims.add(dimsParams);
      });
      if (dims.isNotEmpty) {
        params["dims"] = dims;
      }

      /// compareMetrics
      var compareMetrics = [];
      metadata?.compareInfo?.metrics?.forEach((element) {
        Map<String, dynamic> compareMetricsParams = {};

        compareMetricsParams["code"] = element.metricCode;
        compareMetricsParams["name"] = element.metricName;
        compareMetricsParams["reportId"] = element.reportId;

        compareMetrics.add(compareMetricsParams);
      });
      if (compareMetrics.isNotEmpty) {
        params["compareMetrics"] = compareMetrics;
      }

      /// compareType
      if (metadata?.compareInfo?.compareType != null) {
        params["compareType"] = RSUtils.enumToString(metadata?.compareInfo?.compareType);
      }

      ModuleMetricsCardEntity? entity = await requestClient.request(
        RSServerUrl.keyMetrics,
        method: RequestType.post,
        data: params,
        onResponse: (response) {
          state.loadState.value = CardLoadState.stateSuccess;
        },
        onError: (error) {
          state.errorCode = error.code;
          state.errorMessage = error.message;
          state.loadState.value = CardLoadState.stateError;
          return false;
        },
      );

      if (entity != null) {
        state.resultMetricsCardEntity.value = entity;
        state.showTarget.value = hasTargetValue();

        if (state.resultMetricsCardEntity.value.chart != null) {
          setChartData();
        }
      }
    }, showLoading: false);
  }

  void setChartData() {
    state.allChartData.clear();

    var chartData = state.resultMetricsCardEntity.value.chart;

    if (chartData != null && chartData.isNotEmpty) {
      int index = 0;
      for (var chartElement in chartData) {
        if (chartElement.axisY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartData.add(RSChartData(
              S.current.rs_current, chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(0)));
        }

        index++;
      }

      state.loadState.value = CardLoadState.stateSuccess;

      // 更新chart
      state.chartSeriesController?.updateDataSource();
    }
  }

  int getCompareLineCount(ModuleMetricsCardCompValue? compValue) {
    int count = 0;

    if (compValue != null) {
      var chartCompareDayMetric = compValue.dayCompare;
      var chartCompareWeekMetric = compValue.weekCompare;
      var chartCompareMonthMetric = compValue.monthCompare;
      var chartCompareYearMetric = compValue.yearCompare;

      if (chartCompareDayMetric != null) {
        count++;
      }
      if (chartCompareWeekMetric != null) {
        count++;
      }
      if (chartCompareMonthMetric != null) {
        count++;
      }
      if (chartCompareYearMetric != null) {
        count++;
      }

      if (count == 0) {
        state.lineHeight = 35;
      } else if (count == 1) {
        state.lineHeight = 35;
      } else if (count == 2) {
        state.lineHeight = 40;
      } else if (count == 3) {
        state.lineHeight = 50;
      } else if (count == 4) {
        state.lineHeight = 60;
      }

      return count;
    } else {
      state.lineHeight = 35;

      return count;
    }
  }

  /// 测试数据
  void getTestData(
      String? tabId, String? tabName, TopicTemplateTemplatesNavsTabsCards? cardTemplateData, int cardIndex) {
    state.tabId = tabId;
    state.tabName = tabName;
    if (cardTemplateData != null) {
      state.cardTemplateData.value = cardTemplateData;
      state.cardIndex = cardIndex;
    }

    List<RSChartData> listFlSpot = [];

    listFlSpot.add(RSChartData("x1", "x1", 32.5, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x2", "x2", 66.5, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x3", "x3", 43.5, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x4", "x4", 72.2, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x5", "x5", 100.5, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x6", "x6", 80.5, RSColor.getChartColor(0)));
    listFlSpot.add(RSChartData("x7", "x7", 110.5, RSColor.getChartColor(0)));

    state.allChartData.value = listFlSpot;

    state.loadState.value = CardLoadState.stateSuccess;

    // 更新chart
    state.chartSeriesController?.updateDataSource();
  }

  /// 跳转至实体列表页
  void jumpEntityListPage(ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
    if (drillDownInfo == null) {
      return;
    }
    Map<String, dynamic> arguments = {
      "shopIds": state.shopIds,
      "filterMetricCode": filterMetricCode,
    };

    if (state.displayTime != null && state.displayTime!.isNotEmpty) {
      arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.displayTime!);
      arguments["customDateToolEnum"] = state.customDateToolEnum;
    }

    AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
  }

  void jumpTargetAnalysisPage(String? metricCode) {
    if (metricCode == null) {
      EasyLoading.showError('MetricCode is null');
      return;
    }
    Map<String, dynamic> arguments = {
      "shopIds": state.shopIds,
      "metricCode": metricCode,
      "customDateToolEnum": state.customDateToolEnum,
    };

    if (state.displayTime != null && state.displayTime!.isNotEmpty) {
      arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.displayTime!);
    } else {
      arguments["timeRange"] = RSDateUtil.dateRangeToListString(RSAccountManager().timeRange);
    }

    Get.toNamed(AppRoutes.targetAnalysisPage, arguments: arguments);
  }

  /// 当前卡片是否有目标值数据
  bool hasTargetValue() {
    // 是否拥有
    bool hasTargetValue = false;

    state.resultMetricsCardEntity.value.metrics?.forEach((resultMetric) {
      if (resultMetric.achievement != null) {
        hasTargetValue = true;
      }
    });

    return hasTargetValue;
  }
}
