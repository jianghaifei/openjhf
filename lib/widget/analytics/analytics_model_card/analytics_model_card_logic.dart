import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/analytics/analytics_editing/analytics_editing_logic.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../router/app_routes.dart';
import '../../../utils/analytics_tools.dart';
import '../../../utils/date_util.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../utils/utils.dart';
import '../../card_load_state_layout.dart';
import '../stores_pk/stores_pk_state.dart';
import 'analytics_model_card_state.dart';

class AnalyticsModelCardLogic extends GetxController {
  final AnalyticsModelCardState state = AnalyticsModelCardState();

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
        if (!element.ifHidden) {
          Map<String, dynamic> metricsParams = {};

          metricsParams["code"] = element.metricCode;
          metricsParams["name"] = element.metricName;
          metricsParams["reportId"] = element.reportId;
          metrics.add(metricsParams);
        }
      });

      if (metrics.isNotEmpty) {
        params["metrics"] = metrics;
      }

      /// compareType
      if (metadata?.compareInfo?.compareType != null) {
        params["compareType"] = RSUtils.enumToString(metadata?.compareInfo?.compareType);
      }

      ModuleMetricsCardEntity? entity = await requestClient.request(
        RSServerUrl.lossMetrics,
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

        // state.resultMetricsCardEntity.value.table?.rows?.forEach((element) {
        //   if (element != null && element is Map<String, dynamic>) {
        //     Map<String, dynamic> rowsData = element;
        //
        //     state.resultMetricsCardEntity.value.table?.header?.forEach((headerElement) {
        //       if (rowsData.containsKey(headerElement.code)) {
        //         ModuleMetricsCardTableRowsSubElement? rowsSubElement =
        //             ModuleMetricsCardTableRowsSubElement.fromJson(rowsData[headerElement.code]);
        //         element = rowsSubElement;
        //       }
        //     });
        //   }
        // });

        // debugPrint("resultMetricsCardEntity = ${state.resultMetricsCardEntity.value.toString()}");

        setChartData();
      }
    }, showLoading: false);
  }

  void setChartData() {
    state.allChartData.clear();
    state.allChartDayCompData.clear();
    state.allChartWeekCompData.clear();
    state.allChartMonthCompData.clear();
    state.allChartYearCompData.clear();

    var chartData = state.resultMetricsCardEntity.value.chart;

    if (chartData != null && chartData.isNotEmpty) {
      int index = 0;
      for (var chartElement in chartData) {
        int colorIndex = 0;

        if (chartElement.axisY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartData.add(RSChartData(S.current.rs_current, chartElement.axisX?.dimDisplayValue ?? "$index",
              tmpY, RSColor.getChartColor(colorIndex)));
          colorIndex++;
        }

        if (chartElement.axisDayCompY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisDayCompY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartDayCompData.add(RSChartData(S.current.rs_date_tool_yesterday,
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(colorIndex)));
          colorIndex++;
        }

        if (chartElement.axisWeekCompY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisWeekCompY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartWeekCompData.add(RSChartData(S.current.rs_date_tool_last_week,
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(colorIndex)));
          colorIndex++;
        }

        if (chartElement.axisMonthCompY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisMonthCompY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartMonthCompData.add(RSChartData(S.current.rs_date_tool_last_month,
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(colorIndex)));
          colorIndex++;
        }

        if (chartElement.axisYearCompY?.first != null) {
          var tmpY = num.tryParse(chartElement.axisYearCompY?.first.metricValue ?? "0") ?? 0.00;
          state.allChartYearCompData.add(RSChartData(S.current.rs_date_tool_last_year,
              chartElement.axisX?.dimDisplayValue ?? "$index", tmpY, RSColor.getChartColor(colorIndex)));
          colorIndex++;
        }

        index++;
      }

      state.loadState.value = CardLoadState.stateSuccess;

      // 更新chart
      state.chartSeriesController?.updateDataSource();
    }
  }

  void getTestData(TopicTemplateTemplatesNavsTabsCards? cardMetadata) {
    if (cardMetadata != null) {
      state.cardTemplateData.value = cardMetadata;

      List<RSChartData> listFlSpot = [];

      state.cardTemplateData.value.cardMetadata?.metrics?.forEach((metric) {
        if (!metric.ifHidden) {
          // listFlSpot.add(RSChartData(
          //     metric.metricName ?? '', Random().nextInt(901) + 100, MetricOrDimDataType.NUMERIC_FLOAT,
          //     x2: metric.metricName ?? '', y2: Random().nextInt(901) + 100));
        }
      });
      state.allChartData.value = listFlSpot;
      state.loadState.value = CardLoadState.stateSuccess;

      // 更新chart
      state.chartSeriesController?.updateDataSource();
    }
  }

  ModuleMetricsCardChartAxisY? getYMetricValue(int index) {
    var tmp = state.resultMetricsCardEntity.value.chart?[index].axisY?.first;
    return tmp;
  }

  Future<void> jumpStoresPKPage() async {
    await request(() async {
      StorePKEntity? entity = await requestClient.request(
        RSServerUrl.lossMetricsTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          return false;
        },
      );

      Map<String, dynamic> arguments = {
        "compareDateRangeTypes": RSAccountManager().getCompareDateRangeTypeStrings(),
        "pkTemplate": entity,
        "PKPageType": PKPageType.lossMetricsPage,
        "cardMetadata": state.cardTemplateData.value.cardMetadata,
        "shopIds": state.shopIds,
      };

      if (state.displayTime != null && state.displayTime!.isNotEmpty) {
        arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.displayTime!);
        arguments["customDateToolEnum"] = state.customDateToolEnum;
      }

      if (entity != null) {
        Get.toNamed(AppRoutes.storesPKPage, arguments: arguments);
      }
    }, showLoading: true);
  }

  void chartTypeStatusChanged(int value) {
    state.chartTypeStatus.value = value;
  }

  /// 是否显示对比图
  bool getIsShowCompareLine() {
    if (state.resultMetricsCardEntity.value.chart != null && state.resultMetricsCardEntity.value.chart!.isNotEmpty) {
      var chartCompareDayMetric = state.resultMetricsCardEntity.value.chart?.first.axisDayCompY;
      var chartCompareWeekMetric = state.resultMetricsCardEntity.value.chart?.first.axisWeekCompY;
      var chartCompareMonthMetric = state.resultMetricsCardEntity.value.chart?.first.axisMonthCompY;
      var chartCompareYearMetric = state.resultMetricsCardEntity.value.chart?.first.axisYearCompY;

      if ((chartCompareDayMetric != null && chartCompareDayMetric.isNotEmpty) ||
          (chartCompareWeekMetric != null && chartCompareWeekMetric.isNotEmpty) ||
          (chartCompareMonthMetric != null && chartCompareMonthMetric.isNotEmpty) ||
          (chartCompareYearMetric != null && chartCompareYearMetric.isNotEmpty)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  int getCompareLineCount() {
    int count = 0;
    if (state.resultMetricsCardEntity.value.chart != null && state.resultMetricsCardEntity.value.chart!.isNotEmpty) {
      var chartCompareDayMetric = state.resultMetricsCardEntity.value.chart?.first.axisDayCompY;
      var chartCompareWeekMetric = state.resultMetricsCardEntity.value.chart?.first.axisWeekCompY;
      var chartCompareMonthMetric = state.resultMetricsCardEntity.value.chart?.first.axisMonthCompY;
      var chartCompareYearMetric = state.resultMetricsCardEntity.value.chart?.first.axisYearCompY;

      if (chartCompareDayMetric != null && chartCompareDayMetric.isNotEmpty) {
        count++;
      }
      if (chartCompareWeekMetric != null && chartCompareWeekMetric.isNotEmpty) {
        count++;
      }
      if (chartCompareMonthMetric != null && chartCompareMonthMetric.isNotEmpty) {
        count++;
      }
      if (chartCompareYearMetric != null && chartCompareYearMetric.isNotEmpty) {
        count++;
      }
      return count;
    } else {
      return count;
    }
  }

  double getChartBarWidth() {
    int count = getCompareLineCount();

    if ((state.resultMetricsCardEntity.value.chart?.length ?? 0) >= 3) {
      if (count >= 2) {
        return 0.2;
      } else {
        return 0.1;
      }
    } else if ((state.resultMetricsCardEntity.value.chart?.length ?? 0) >= 2) {
      if (count >= 2) {
        return 0.2;
      } else {
        return 0.1;
      }
    } else if ((state.resultMetricsCardEntity.value.chart?.length ?? 0) >= 1) {
      if (count >= 2) {
        return 0.1;
      } else {
        return 0.05;
      }
    } else {
      return 0.1;
    }
  }

  void editMetricsSequence() {
    final AnalyticsEditingLogic logic = Get.find<AnalyticsEditingLogic>();

    logic.updateCardData(state.cardTemplateData.value, state.cardIndex);
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
}
