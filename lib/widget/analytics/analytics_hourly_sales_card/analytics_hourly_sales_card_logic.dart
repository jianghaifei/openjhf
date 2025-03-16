import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/chart_data/rs_chart_data.dart';
import '../../../router/app_routes.dart';
import '../../../utils/analytics_tools.dart';
import '../../../utils/date_util.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../utils/utils.dart';
import '../../card_load_state_layout.dart';
import 'analytics_hourly_sales_card_state.dart';

class AnalyticsHourlySalesCardLogic extends GetxController {
  final AnalyticsHourlySalesCardState state = AnalyticsHourlySalesCardState();

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
      state.metadata.value = cardMetadata.cardMetadata!;

      await getMetricsData(cardMetadata.cardMetadata);
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
      var selectedMetric = getMetricsList()[state.selectedMetricsIndex.value];
      Map<String, dynamic> metricsParams = {};
      metricsParams["code"] = selectedMetric.metricCode;
      metricsParams["name"] = selectedMetric.metricName;
      metricsParams["reportId"] = selectedMetric.reportId;
      metrics.add(metricsParams);

      if (metrics.isNotEmpty) {
        params["metrics"] = metrics;
      }

      /// dims
      var dims = [];
      var selectedDim = getDimsList(state.selectedMetric.value)[state.selectedDimsIndex.value];
      Map<String, dynamic> dimsParams = {};
      dimsParams["code"] = selectedDim.dimCode;
      dimsParams["reportId"] = selectedDim.reportId;
      dims.add(dimsParams);

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
        RSServerUrl.periodMetrics,
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

        state.resultMetricsCardEntity.value.table?.rows?.forEach((element) {
          if (element != null && element is Map<String, dynamic>) {
            Map<String, dynamic> rowsData = element;

            state.resultMetricsCardEntity.value.table?.header?.forEach((headerElement) {
              if (rowsData.containsKey(headerElement.code)) {
                ModuleMetricsCardTableRowsSubElement? rowsSubElement =
                    ModuleMetricsCardTableRowsSubElement.fromJson(rowsData[headerElement.code]);
                element = rowsSubElement;
              }
            });
          }
        });

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

  /// 测试数据
  void getTestData(
      String? tabId, String? tabName, TopicTemplateTemplatesNavsTabsCards? cardTemplateData, int cardIndex) {
    state.tabId = tabId;
    state.tabName = tabName;
    if (cardTemplateData != null) {
      state.cardTemplateData.value = cardTemplateData;
      state.cardIndex = cardIndex;
    }

    state.loadState.value = CardLoadState.stateSuccess;
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

  ModuleMetricsCardChartAxisY? getYMetricValue(int index) {
    var tmp = state.resultMetricsCardEntity.value.chart?[index].axisY?.first;
    return tmp;
  }

  bool getAnalyticsChartTypeIfMultiple() {
    if (state.metadata.value.chartType != null && state.metadata.value.chartType!.isNotEmpty) {
      if (state.metadata.value.chartType!.length > 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics> getMetricsList() {
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics> metricsList = [];

    state.metadata.value.metrics?.forEach((element) {
      if (element.metricCode != null && element.metricName != null) {
        metricsList.add(element);
      }

      if (state.selectedMetric.value.metricCode == null || state.selectedMetric.value.metricName == null) {
        state.selectedMetric.value = element;
      }
    });

    return metricsList;
  }

  List<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims> getDimsList(
      TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics metric) {
    List<TopicTemplateTemplatesNavsTabsCardsCardMetadataDims> dimsList = [];

    metric.dimOptions?.forEach((bindingDim) {
      state.metadata.value.dims?.forEach((dim) {
        if (dim.dimCode == bindingDim) {
          dimsList.add(dim);
        }
      });
    });

    return dimsList;
  }

  void chartTypeStatusChanged(int value) {
    state.chartTypeStatus.value = value;
  }

  /// 跳转至实体列表页
  void jumpEntityListPage(ModuleMetricsCardDrillDownInfo? drillDownInfo, String timeRange, String? filterMetricCode) {
    if (drillDownInfo == null) {
      return;
    }
    Map<String, dynamic> arguments = {};

    arguments = {
      "timeRange": [timeRange, timeRange],
      "shopIds": state.shopIds,
      "filterMetricCode": filterMetricCode,
    };

    if (state.displayTime != null && state.displayTime!.isNotEmpty) {
      arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.displayTime!);
      arguments["customDateToolEnum"] = state.customDateToolEnum;
    }

    AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
  }

  Future<void> jumpEditPage() async {
    return await request(
      () async {
        MetricsEditInfoMetricsCard? entity = await requestClient.request(
          RSServerUrl.cardEditInfo,
          method: RequestType.post,
          data: {
            "tabId": state.tabId,
            "cardType": RSUtils.enumToString(TopicCardType.DATA_CHART_PERIOD),
            "cardId": state.cardTemplateData.value.cardId
          },
          onResponse: (response) {},
          onError: (error) {
            debugPrint('原始 error = ${error.message}');
            return false;
          },
        );

        if (entity != null) {
          state.analysisChart = entity;

          var arguments = {
            "tabName": state.tabName,
            "analysisChartEntity": [state.analysisChart],
            "cardTemplateData": state.cardTemplateData.value,
            "cardIndex": state.cardIndex,
          };
          Get.toNamed(AppRoutes.analyticsAddChartPage, arguments: arguments);
        }
      },
      showLoading: true,
    );
  }
}
