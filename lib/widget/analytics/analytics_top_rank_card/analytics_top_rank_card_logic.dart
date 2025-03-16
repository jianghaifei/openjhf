import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../router/app_routes.dart';
import '../../../utils/analytics_tools.dart';
import '../../../utils/date_util.dart';
import '../../../utils/logger/logger_helper.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../utils/utils.dart';
import '../../card_load_state_layout.dart';
import '../stores_pk/stores_pk_state.dart';
import 'analytics_top_rank_card_state.dart';

class AnalyticsTopRankCardLogic extends GetxController {
  final AnalyticsTopRankCardState state = AnalyticsTopRankCardState();

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
      state.metadata.value = cardMetadata.cardMetadata!;

      await loadPKTableQuery();
    } else {
      state.loadState.value = CardLoadState.stateError;
    }
  }

  Future<void> loadPKTableQuery() async {
    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      Map<String, dynamic> params = {
        "shopIds": state.shopIds ?? RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
        "date": RSDateUtil.dateRangeToListString(RSAccountManager().timeRange),
        "dateType": state.customDateToolEnum.name,
        // "page": {"pageNo": 1, "pageSize": 10},
      };

      /// 对比类型&对比时间范围
      if ((state.compareDateTimeRanges != null && state.compareDateTimeRanges!.isNotEmpty) &&
          (state.compareDateRangeTypes != null && state.compareDateRangeTypes!.isNotEmpty)) {
        params.addAll(
            AnalyticsTools.returnCompareDateRangeParams(state.compareDateRangeTypes!, state.compareDateTimeRanges!));
      }

      /// cardType
      params["cardType"] = RSUtils.enumToString(state.metadata.value.cardType);

      /// metrics
      var metrics = [];
      state.metadata.value.metrics?.forEach((element) {
        Map<String, dynamic> metricsParams = {};
        metricsParams["code"] = element.metricCode;
        metricsParams["reportId"] = element.reportId;
        metrics.add(metricsParams);
      });

      if (metrics.isNotEmpty) {
        params["metrics"] = metrics;
      }

      /// dims
      var dims = [];
      state.metadata.value.dims?.forEach((element) {
        Map<String, dynamic> dimsParams = {};
        dimsParams["code"] = element.dimCode;
        dimsParams["reportId"] = element.reportId;
        dims.add(dimsParams);
      });

      if (dims.isNotEmpty) {
        params["dims"] = dims;
      }

      StorePKTableEntity? entity = await requestClient.request(
        RSServerUrl.storesPKTableQuery,
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
        state.resultStorePKTableEntity.value = entity;
      }
    });
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
      arguments["displayTime"] = state.displayTime;
      arguments["compareDateRangeTypes"] = state.compareDateRangeTypes;
    }

    AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
  }

  Future<void> jumpEditPage() async {
    return await request(() async {
      MetricsEditInfoMetricsCard? entity = await requestClient.request(
        RSServerUrl.cardEditInfo,
        method: RequestType.post,
        data: {
          "tabId": state.tabId,
          "cardType": RSUtils.enumToString(TopicCardType.DATA_CHART_RANK),
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

  Future<void> jumpStoresPKPage() async {
    await request(() async {
      StorePKEntity? entity = await requestClient.request(
        RSServerUrl.dataPKTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          return false;
        },
      );

      if (entity != null) {
        Get.toNamed(AppRoutes.storesPKPage, arguments: {
          "customDateToolEnum": state.customDateToolEnum,
          "compareDateRangeTypes": RSAccountManager().getCompareDateRangeTypeStrings(),
          "pkTemplate": entity,
          "PKPageType": PKPageType.pkPage,
          "cardMetadata": state.metadata.value,
          "shopIds": state.shopIds,
        });
      }
    }, showLoading: true);
  }

  double getDataGridSubviewHeight(int count) {
    int rowsCount = min(state.resultStorePKTableEntity.value.table?.rows?.length ?? 0, state.showMaxLength);

    var rowHeight = getSingleRowHeight(count) * rowsCount + 36; // 头部高度
    return rowHeight;
  }

  double getSingleRowHeight(int count) {
    switch (count) {
      case 0:
        return 65.0;
      case 1:
        return 65.0;
      case 2:
        return 85.0;
      case 3:
        return 95.0;
      case 4:
        return 110.0;
      default:
        return 110.0;
    }
  }
}
