import 'dart:math';

import 'package:flutter_report_project/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../utils/analytics_tools.dart';
import '../../../utils/date_util.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../utils/utils.dart';
import '../../card_load_state_layout.dart';
import 'analytics_dining_table_card_state.dart';

class AnalyticsDiningTableCardLogic extends GetxController {
  final AnalyticsDiningTableCardState state = AnalyticsDiningTableCardState();

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
        // 不传page，代表获取全部
        // "page": {"pageNo": 1, "pageSize": 10},
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
        RSServerUrl.diningTableShopsList,
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
  void getTestData(TopicTemplateTemplatesNavsTabsCards? cardTemplateData, int cardIndex) {
    if (cardTemplateData != null) {
      state.cardTemplateData.value = cardTemplateData;
      state.cardIndex = cardIndex;
    }
    // 更新chart
    state.loadState.value = CardLoadState.stateSuccess;
  }

  /// 去往桌台列表页
  Future<void> jumpDiningTableListPage() async {
    Get.toNamed(AppRoutes.diningTableShopListPage, arguments: {"displayTime": state.displayTime});
    // await request(() async {
    //   StorePKEntity? entity = await requestClient.request(
    //     RSServerUrl.dataPKTemplate,
    //     method: RequestType.post,
    //     data: {},
    //     onResponse: (response) {},
    //     onError: (error) {
    //       return false;
    //     },
    //   );
    //
    //   if (entity != null) {
    //     Get.toNamed(AppRoutes.storesPKPage, arguments: {
    //       "customDateToolEnum": state.customDateToolEnum,
    //       "compareDateRangeTypes": RSAccountManager().getCompareDateRangeTypeStrings(),
    //       "pkTemplate": entity,
    //       "PKPageType": PKPageType.pkPage,
    //       "cardMetadata": state.metadata.value,
    //     });
    //   }
    // }, showLoading: true);
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
