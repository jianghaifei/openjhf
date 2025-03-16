import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/metrics_card/module_group_metrics_entity.dart';
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
import '../../card_load_state_layout.dart';
import 'analytics_group_sales_card_state.dart';

enum GroupDataStyle {
  PIE,
  LIST,
}

class AnalyticsGroupSalesCardLogic extends GetxController {
  final AnalyticsGroupSalesCardState state = AnalyticsGroupSalesCardState();

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

  Future<void> loadData(
    TopicTemplateTemplatesNavsTabsCards? cardMetadata, {
    bool loadAllData = false,
  }) async {
    if (cardMetadata != null) {
      state.cardTemplateData.value = cardMetadata;
      state.metadata.value = cardMetadata.cardMetadata!;

      await getMetricsData(
        state.cardTemplateData.value.cardMetadata,
        state.chartTypeStatus.value == 0 ? GroupDataStyle.PIE : GroupDataStyle.LIST,
        loadAllData,
      );
    } else {
      state.loadState.value = CardLoadState.stateError;
    }
  }

  Future<void> getMetricsData(
    TopicTemplateTemplatesNavsTabsCardsCardMetadata? metadata,
    GroupDataStyle? dateType,
    bool loadAllData,
  ) async {
    await request(() async {
      if (!loadAllData) {
        state.loadState.value = CardLoadState.stateLoading;
      }

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
      var metric = getMetricsList()[state.selectedMetricsIndex.value];
      params["metrics"] = [
        {
          "code": metric.metricCode,
          "reportId": metric.reportId,
        }
      ];

      /// 排序
      params["orderBy"] = {metric.metricCode: "DESC"};

      /// dims
      var dim = getDimsList(state.selectedMetric.value)[state.selectedDimsIndex.value];
      params["dims"] = [
        {
          "code": dim.dimCode,
          "reportId": dim.reportId,
        }
      ];

      /// page
      int size = state.showMaxLength;
      if (dateType == GroupDataStyle.PIE) {
        size = state.showMaxLength - 1;
      } else {
        size = state.showMaxLength + 1;
      }

      /// page
      params["page"] = {
        "pageNo": 1,
        "pageSize": loadAllData ? 99999 : size,
      };

      /// chartType
      params["chartType"] = RSUtils.enumToString(dateType);

      ModuleGroupMetricsEntity? entity = await requestClient.request(
        RSServerUrl.groupMetrics,
        method: RequestType.post,
        data: params,
        onResponse: (response) {
          if (!loadAllData) {
            state.loadState.value = CardLoadState.stateSuccess;
          }
        },
        onError: (error) {
          state.errorCode = error.code;
          state.errorMessage = error.message;
          if (!loadAllData) {
            state.loadState.value = CardLoadState.stateError;
          }
          return false;
        },
      );

      if (entity != null) {
        state.resultModuleGroupMetricsEntity.value = entity;

        if (dateType == GroupDataStyle.PIE) {
          setChartData();
        }
      }
    }, showLoading: loadAllData);
  }

  void setChartData() {
    List<RSChartData> listFlSpot = [];

    if (state.resultModuleGroupMetricsEntity.value.reportData == null ||
        state.resultModuleGroupMetricsEntity.value.reportData?.rows == null ||
        state.resultModuleGroupMetricsEntity.value.reportData!.rows!.isEmpty) {
      listFlSpot.add(RSChartData("one", "one", 100, RSColor.chartColors.last));
    } else {
      int index = 0;
      state.resultModuleGroupMetricsEntity.value.reportData?.rows?.forEach((element) {
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

  void chartTypeStatusChanged(int value, TopicTemplateTemplatesNavsTabsCards? cardMetadata) {
    state.chartTypeStatus.value = value;

    loadData(cardMetadata);
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

    List<RSChartData> listFlSpot = [];

    listFlSpot.addAll([RSChartData("one", "one", 100, RSColor.chartColors.last)]);

    state.allChartData.value = listFlSpot;

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

    // if (filterValue != null) {
    //   if (isOther) {
    //     arguments["filterValueArray"] = findOtherFilterValue();
    //   } else {
    //     arguments["filterValue"] = filterValue;
    //   }
    // }

    AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
  }

  // List<String> findOtherFilterValue() {
  //   List<String> dimValue = [];
  //   state.resultModuleGroupMetricsEntity.value.reportData?.rows?.forEach((element) {
  //     if (element.dims != null && !element.dims!.first.isOther) {
  //       dimValue.add(element.dims?.first.value ?? '');
  //     }
  //   });
  //   return dimValue;
  // }

  Future<void> jumpEditPage() async {
    return await request(() async {
      MetricsEditInfoMetricsCard? entity = await requestClient.request(
        RSServerUrl.cardEditInfo,
        method: RequestType.post,
        data: {
          "tabId": state.tabId,
          "cardType": RSUtils.enumToString(TopicCardType.DATA_CHART_GROUP),
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
    }, showLoading: true);
  }
}
