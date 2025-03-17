import 'package:flutter_report_project/utils/network/request.dart';
import 'package:get/get.dart';

import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../model/dining_table/dining_table_shops_template_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../../utils/date_util.dart';
import '../../../../utils/network/request_client.dart';
import '../../../../utils/network/server_url.dart';
import '../../../card_load_state_layout.dart';
import 'dining_table_shop_list_state.dart';

class DiningTableShopListLogic extends GetxController {
  final DiningTableShopListState state = DiningTableShopListState();

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

  /// 设置当前时间标题
  void setCurrentTimeTitle() {
    state.currentTimeTitle.value = RSDateUtil.timeToString(DateTime.now(), dateFormat: 'yyyy/MM/dd HH:mm');
  }

  /// 桌台-获取门店列表模板
  Future<void> loadDiningTableShopsListTemplate() async {
    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      DiningTableShopsTemplateEntity? templateEntity = await requestClient.request(
        RSServerUrl.diningTableShopsListTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          state.errorCode = error.code;
          state.errorMessage = error.message;
          return false;
        },
      );
      if (templateEntity != null) {
        state.templateEntity.value = templateEntity;

        // 查找默认指标和维度
        firstFindMetricsAndDims();
        // 桌台-获取门店列表
        loadDiningTableShopsList();
      }
    });
  }

  /// 桌台-获取门店列表
  Future<void> loadDiningTableShopsList() async {
    List<String> shopIds = state.selectedShops.map((e) => e.shopId ?? "").toList();
    state.loadState.value = CardLoadState.stateLoading;

    await request(() async {
      setCurrentTimeTitle();

      Map<String, dynamic> params = {
        "shopIds": shopIds,
        "date": RSDateUtil.dateRangeToListString(state.displayTime ?? RSAccountManager().timeRange),
      };

      /// metrics
      var metrics = [];
      for (var metric in state.selectedMetrics) {
        Map<String, dynamic> metricsParams = {};
        metricsParams["code"] = metric.metricCode;
        metricsParams["reportId"] = metric.reportId;
        metrics.add(metricsParams);
      }

      if (metrics.isNotEmpty) {
        params["metrics"] = metrics;
      }

      /// dims
      var dims = [];
      for (var dim in state.selectedDims) {
        Map<String, dynamic> dimsParams = {};
        dimsParams["code"] = dim.dimCode;
        dimsParams["reportId"] = dim.reportId;
        dims.add(dimsParams);
      }
      if (dims.isNotEmpty) {
        params["dims"] = dims;
      }

      StorePKTableEntity? storePKTableEntity = await requestClient.request(
        RSServerUrl.diningTableShopsList,
        method: RequestType.post,
        data: params,
        headers: {"Currency-Type": state.selectedCurrencyValue.value},
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
      if (storePKTableEntity != null) {
        state.storePKTableEntity.value = storePKTableEntity;
      }
    });
  }

  /// 获取默认选中指标下标，isChangeMetricsValue：是否修改selectedMetrics数据源
  List<int> getMetricsIfDefaultTrueIndexList({bool isChangeMetricsValue = true}) {
    var metrics = state.templateEntity.value.cardMetadata?.metrics;

    var trueIndices =
        metrics?.asMap().entries.where((entry) => entry.value.ifDefault == true).map((entry) => entry.key).toList() ??
            [];

    // 默认取第一个
    if (trueIndices.isEmpty) {
      trueIndices = [0];
      if (isChangeMetricsValue) {
        state.selectedMetrics.value = [metrics!.first];
      }
    } else {
      if (isChangeMetricsValue) {
        state.selectedMetrics.value = trueIndices.map((index) => metrics![index]).toList();
      }
    }

    return trueIndices;
  }

  /// 修改指标的选中状态——多个
  Future<void> changeMetricsIfDefaultTrueIndexList(List<int> trueIndices) async {
    var metrics = state.templateEntity.value.cardMetadata?.metrics;

    if (metrics != null) {
      // 创建一个Set来快速查找下标
      Set<int> indexSet = trueIndices.toSet();

      var tmp = <DiningTableShopsTemplateCardMetadataMetrics>[];
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

  /// 修改指标的选中状态——单个
  Future<void> changeMetricsIfDefaultTrueIndex(int index) async {
    var metrics = state.templateEntity.value.cardMetadata?.metrics;

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

  /// 查找默认指标和维度
  void firstFindMetricsAndDims() {
    // state.selectedGroupCode.value = state.cardMetadata.value.groupCode ?? '';
    // var cardMetrics = state.cardMetadata.value.metrics;
    // var cardDims = state.cardMetadata.value.dims;
    // state.resultStorePKEntity.value.cardMetadata?.cardGroup?.forEach((group) {
    //   if (state.selectedGroupCode.value == group.groupCode) {
    //     var metadata = group.metadata?.first;
    //     cardMetrics?.forEach((cardMetric) {
    //       metadata?.metrics?.forEach((metric) {
    //         if (cardMetric.metricCode == metric.metricCode) {
    //           state.selectedMetrics.add(metric);
    //         }
    //       });
    //     });
    //
    //     cardDims?.forEach((cardDim) {
    //       metadata?.dims?.forEach((dim) {
    //         if (cardDim.dimCode == dim.dimCode) {
    //           state.selectedDims.add(dim);
    //         }
    //       });
    //     });
    //   }
    // });
    state.templateEntity.value.cardMetadata?.metrics?.forEach((metric) {
      if (metric.ifDefault) {
        state.selectedMetrics.add(metric);
      }
    });

    state.templateEntity.value.cardMetadata?.dims?.forEach((dim) {
      if (dim.ifDefault) {
        state.selectedDims.add(dim);
      }
    });
  }
}
