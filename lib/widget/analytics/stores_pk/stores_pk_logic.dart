import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../utils/date_util.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../card_load_state_layout.dart';
import 'stores_pk_state.dart';

class StoresPKLogic extends GetxController {
  final StoresPKState state = StoresPKState();

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

  Future<void> loadShopPKTableQuery() async {
    if (state.pageType.value == PKPageType.storePKPage) {
      // resultMetadataMetrics 先赋值
      getMetricsIfDefaultTrueIndexList();
    }

    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      Map<String, dynamic> params = {
        "shopIds": state.shopIds ?? RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
        "cardType": state.pageType.value == PKPageType.storePKPage
            ? "DATA_SHOP_PK"
            : state.resultStorePKEntity.value.cardMetadata?.cardType ?? '',
        "date": RSDateUtil.dateRangeToListString(state.currentCustomDateTime),
        "dateType": state.customDateToolEnum.name,
      };

      /// 对比类型&对比时间范围
      if (state.compareDateTimeRanges.isNotEmpty && state.compareDateRangeTypes.isNotEmpty) {
        params.addAll(
            AnalyticsTools.returnCompareDateRangeParams(state.compareDateRangeTypes, state.compareDateTimeRanges));
      }

      /// metrics
      var metrics = [];

      /// dims
      var dims = [];

      if (state.pageType.value == PKPageType.storePKPage) {
        // 店铺PK页
        for (var metric in state.selectedMetrics) {
          Map<String, dynamic> metricsParams = {};
          metricsParams["code"] = metric.metricCode;
          metricsParams["reportId"] = metric.reportId;
          metrics.add(metricsParams);
        }

        if (metrics.isNotEmpty) {
          params["metrics"] = metrics;
        }

        state.resultStorePKEntity.value.cardMetadata?.cardGroup?[state.tabIndex.value].metadata?.first.dims
            ?.forEach((element) {
          Map<String, dynamic> dimsParams = {};
          dimsParams["code"] = element.dimCode;
          dimsParams["reportId"] = element.reportId;
          dims.add(dimsParams);
        });
        if (dims.isNotEmpty) {
          params["dims"] = dims;
        }
      } else {
        // PK页
        for (var metric in state.selectedMetrics) {
          Map<String, dynamic> metricsParams = {};
          metricsParams["code"] = metric.metricCode;
          metricsParams["reportId"] = metric.reportId;
          metrics.add(metricsParams);
        }

        if (metrics.isNotEmpty) {
          params["metrics"] = metrics;
        }

        for (var dim in state.selectedDims) {
          Map<String, dynamic> dimsParams = {};
          dimsParams["code"] = dim.dimCode;
          dimsParams["reportId"] = dim.reportId;
          dims.add(dimsParams);
        }
        if (dims.isNotEmpty) {
          params["dims"] = dims;
        }
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

  List<StorePKCardMetadataCardGroupMetadataMetrics>? getCurrentMetrics() {
    List<StorePKCardMetadataCardGroupMetadataMetrics>? metrics;

    if (state.pageType.value == PKPageType.storePKPage) {
      metrics = state.resultStorePKEntity.value.cardMetadata?.cardGroup?[state.tabIndex.value].metadata?.first.metrics;
    } else {
      var arrays = state.resultStorePKEntity.value.cardMetadata?.cardGroup
          ?.firstWhere((group) => group.groupCode == state.selectedGroupCode.value)
          .metadata
          ?.first
          .metrics;

      // 过滤出包含相同reportId的metric
      metrics = arrays
          ?.where((metric) => metric.reportId!.any((item) => state.selectedDims.first.reportId!.contains(item)))
          .toList();
    }
    return metrics;
  }

  /// 获取默认选中指标下标，isChangeMetricsValue：是否修改selectedMetrics数据源
  List<int> getMetricsIfDefaultTrueIndexList({bool isChangeMetricsValue = true}) {
    var metrics = getCurrentMetrics();

    List<int> trueIndices = [];
    if (isChangeMetricsValue) {
      trueIndices =
          metrics?.asMap().entries.where((entry) => entry.value.ifDefault == true).map((entry) => entry.key).toList() ??
              [];
    } else {
      // 使用集合来存储 选中的指标数组 中的 metricCode
      Set<String?> metricCodesB = state.selectedMetrics.map((metric) => metric.metricCode).toSet();

      trueIndices = metrics
              ?.asMap()
              .entries
              .where((entry) => metricCodesB.contains(entry.value.metricCode))
              .map((entry) => entry.key)
              .toList() ??
          [];
    }

    if (trueIndices.isNotEmpty) {
      if (isChangeMetricsValue) {
        state.selectedMetrics.value = trueIndices.map((index) => metrics![index]).toList();
      }
    } else {
      trueIndices = [0];
      if (isChangeMetricsValue) {
        state.selectedMetrics.value = [metrics!.first];
      }
    }
    return trueIndices;
  }

  /// 修改指标的选中状态
  Future<void> changeMetricsIfDefaultTrueIndexList(List<int> trueIndices) async {
    var metrics = getCurrentMetrics();

    if (metrics != null) {
      // 创建一个Set来快速查找下标
      Set<int> indexSet = trueIndices.toSet();

      var tmp = <StorePKCardMetadataCardGroupMetadataMetrics>[];
      // 遍历模型数组并更新ifDefault
      for (var metric in metrics) {
        // 获取当前模型的下标
        int index = metrics.indexOf(metric);

        // 如果下标在indexSet中，则将ifDefault设置为true，否则设置为false
        metric.ifDefault = indexSet.contains(index);
        if (metric.ifDefault) {
          tmp.add(metric);
        }
      }

      state.selectedMetrics.value = tmp;
    }
  }

  Future<void> changeMetricsIfDefaultTrueIndex(int index) async {
    var metrics = getCurrentMetrics();

    if (index < state.selectedMetrics.length) {
      var tmpMetric = state.selectedMetrics[index];
      metrics?.forEach((element) {
        if (element.metricCode == tmpMetric.metricCode) {
          element.ifDefault = !tmpMetric.ifDefault;
        }
      });

      state.selectedMetrics.removeAt(index);
    }
  }

  void firstFindMetricsAndDims() {
    state.selectedGroupCode.value = state.cardMetadata.value.groupCode ?? '';
    if (state.selectedGroupCode.value.isEmpty) {
      EasyLoading.showError("GroupCode is empty");
      Get.back();
    }
    var cardMetrics = state.cardMetadata.value.metrics;
    var cardDims = state.cardMetadata.value.dims;
    state.resultStorePKEntity.value.cardMetadata?.cardGroup?.forEach((group) {
      if (state.selectedGroupCode.value == group.groupCode) {
        var metadata = group.metadata?.first;
        cardMetrics?.forEach((cardMetric) {
          metadata?.metrics?.forEach((metric) {
            if (cardMetric.metricCode == metric.metricCode) {
              state.selectedMetrics.add(metric);
            }
          });
        });

        if (state.pageType.value == PKPageType.lossMetricsPage) {
          var firstDim = group.metadata?.first.dims?.firstWhere((element) => element.ifDefault);

          if (firstDim != null && state.selectedDims.isEmpty) {
            state.selectedDims.add(firstDim);
          }
        } else {
          cardDims?.forEach((cardDim) {
            metadata?.dims?.forEach((dim) {
              if (cardDim.dimCode == dim.dimCode) {
                state.selectedDims.add(dim);
              }
            });
          });
        }
      }
    });
  }
}
