import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../utils/date_util.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../utils/utils.dart';
import '../../card_load_state_layout.dart';
import 'stores_pk_state.dart';

class StoresPKLogic extends GetxController {
  final StoresPKState state = StoresPKState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    if (state.pageType.value == PKPageType.storePKPage) {
      // resultMetadataMetrics 先赋值
      getMetricsIfDefaultTrueIndexList();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  // 根据指标code查询过滤器数据
  Future<void> requestFilterComponent() async {
    state.loadState.value = CardLoadState.stateLoading;

    List<String>? metricCodes = state.selectedMetrics.map((e) => e.metricCode ?? '').toList();

    var params = {
      'componentMetrics': metricCodes,
    };

    await request(() async {
      AnalyticsEntityFilterComponentEntity? filterComponentEntity = await requestClient
          .request(RSServerUrl.filtersByMetrics, method: RequestType.post, data: params, onResponse: (response) {},
              onError: (error) {
        return false;
      });

      if (filterComponentEntity != null) {
        // 如果返回数据即默认选中
        filterComponentEntity.filters?.forEach((element) {
          element.options?.forEach((option) {
            if (option.ifDefault) {
              option.ifDefault = false;
              option.isSelected = true;
            }
          });
        });

        state.filterComponentEntity.value = filterComponentEntity;
        debugPrint("filter: ${filterComponentEntity.filters?.map((element) => element.displayName ?? '*').toList()}");
      }

      // 配置Range实体模型
      setRangeFilterEntity();
      // 查询PK数据
      loadShopPKTableQuery();
      // 检查是否拥有过滤条件
      checkIsHaveFilterConditions();
    });
  }

  // 查询PK数据
  Future<void> loadShopPKTableQuery({bool showLoading = false}) async {
    if (state.pageType.value == PKPageType.storePKPage) {
      // resultMetadataMetrics 先赋值
      getMetricsIfDefaultTrueIndexList();
    }

    if (showLoading) {
      state.loadState.value = CardLoadState.stateLoading;
    }

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

      var filterParams = collectFilterParams();
      if (filterParams.isNotEmpty) {
        params["filters"] = filterParams;
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
  Future<List<int>> getMetricsIfDefaultTrueIndexList({bool isChangeMetricsValue = true}) async {
    var metrics = getCurrentMetrics();

    List<int> trueIndices = [];
    if (isChangeMetricsValue) {
      trueIndices =
          metrics?.asMap().entries.where((entry) => entry.value.ifDefault == true).map((entry) => entry.key).toList() ??
              [];
    } else {
      // 使用集合来存储 选中的指标数组 中的 metricCode
      Set<String?> metricCodesB = state.selectedMetrics.map((metric) => metric.metricCode).toSet();

      // 依照selectedMetrics中的元素顺序，遍历出 metrics中的元素下标
      for (var metric in state.selectedMetrics) {
        if (metricCodesB.contains(metric.metricCode)) {
          trueIndices.add(metrics!.indexOf(metric));
        }
      }
    }

    if (trueIndices.isNotEmpty) {
      if ((state.selectedMetrics.isEmpty || state.tabIndex.value != state.recordTabIndex) && isChangeMetricsValue) {
        state.selectedMetrics.value = trueIndices.map((index) => metrics![index]).toList();
        state.recordTabIndex = state.tabIndex.value;
      }
    } else {
      trueIndices = [0];
      if ((state.selectedMetrics.isEmpty || state.tabIndex.value != state.recordTabIndex) && isChangeMetricsValue) {
        state.selectedMetrics.value = [metrics!.first];
        state.recordTabIndex = state.tabIndex.value;
      }
    }

    // if (state.selectedMetrics.isNotEmpty) {
    //   await requestFilterComponent();
    // }

    return trueIndices;
  }

  /// 修改指标的选中状态
  Future<void> changeMetricsIfDefaultTrueIndexList(List<int> trueIndices) async {
    var metrics = getCurrentMetrics();

    if (metrics != null) {
      // 将metrics的ifDefault设置为false
      for (var metric in metrics) {
        metric.ifDefault = false;
      }

      var tmp = <StorePKCardMetadataCardGroupMetadataMetrics>[];

      // 根据下标修改指标的选中状态，并赋值
      for (var index in trueIndices) {
        metrics[index].ifDefault = true;
        tmp.add(metrics[index]);
      }

      state.selectedMetrics.value = tmp;
      debugPrint("selectedMetrics = $tmp");
    }
  }

  Future<void> changeMetricsIfDefaultTrueIndex(String? metricCode) async {
    if (metricCode == null) {
      return;
    }
    var metrics = getCurrentMetrics();

    // 根据metricCode修改指标的选中状态，并赋值
    if (metrics != null) {
      for (var metric in metrics) {
        if (metric.metricCode == metricCode) {
          metric.ifDefault = !metric.ifDefault;
        }
      }

      // 遍历selectedMetrics，快速匹配metricCode
      state.selectedMetrics.removeWhere((metric) => metric.metricCode == metricCode);
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

  // 根据选中指标顺序调整数据模型的head数据源顺序
  void sortTableHead() {
    var table = state.resultStorePKTableEntity.value.table;
    if (table != null) {
      var header = table.header;
      if (header != null) {
        var tmp = <StorePKTableEntityTableHeader>[];

        for (var metric in state.selectedMetrics) {
          // 数据表中第一列是店铺名称，所以不进行排序，直接加入数组
          for (var element in header) {
            if (tmp.isEmpty) {
              tmp.add(element);
            }
            if (element.code == metric.metricCode) {
              tmp.add(element);
            }
          }
        }
        table.header = tmp;
      }

      state.resultStorePKTableEntity.update((val) {
        val?.table = table;
      });
    }
  }

  /// 设置filter最大最小值
  void setMinAndMaxNumbers(List<double?> numbers, List<String> filterTypeString) {
    debugPrint("limitNumbers = $numbers, filterTypeString = $filterTypeString");

    state.filterMinAndMax.value = numbers;

    state.filterNumericalValueTypeString.value = filterTypeString;
  }

  /// 配置Range实体模型
  void setRangeFilterEntity() {
    state.filterComponentEntity.value.filters?.forEach((element) {
      // 数值筛选
      if (element.componentType == EntityComponentType.NUM_FILTER) {
        state.rangeFilterEntity.value = element;

        // 有默认值
        if (element.filterType != null && element.options != null) {
          // 数值筛选不依赖是否选中，需要重置为false
          element.options?.forEach((option) {
            option.isSelected = false;
          });
          state.filterNumericalValueTypeString.value = [AnalyticsTools().returnFilterTypeString(element.filterType!)];

          element.options?.first.value?.forEach((element) {
            state.filterMinAndMax.add(double.tryParse(element));
          });
        }
      }
    });
  }

  // 检查是否拥有过滤条件
  void checkIsHaveFilterConditions() {
    state.selectedFilters.clear();
    state.isHaveFilterConditions.value = false;

    // state.filters?.forEach((filter) {
    //   var filterMap = {
    //     "fieldCode": filter.fieldCode,
    //     "filterType": filter.filterType?.name,
    //     "options": [
    //       {
    //         "displayName": filter.displayName,
    //         "value": filter.filterValue,
    //       }
    //     ]
    //   };
    //   var tmpModel = AnalyticsEntityFilterComponentFilters.fromJson(filterMap);
    //   state.selectedFilters.add(tmpModel);
    //
    //   debugPrint("tmpModel = $tmpModel");
    // });

    // 过滤 isSelected == true 的 options
    state.filterComponentEntity.value.filters?.forEach((filter) {
      var selectedOptions = filter.options?.where((option) => option.isSelected).toList();

      if ((filter.componentType == EntityComponentType.NUM_FILTER &&
              filter.options != null &&
              filter.options!.isNotEmpty) ||
          selectedOptions != null && selectedOptions.isNotEmpty) {
        var tmpModel = AnalyticsEntityFilterComponentFilters.fromJson(filter.toJson());
        if (selectedOptions != null && selectedOptions.isNotEmpty) {
          tmpModel.options = selectedOptions;
        }

        state.selectedFilters.add(tmpModel);
        state.isHaveFilterConditions.value = true;
      }
    });

    if (state.filterMinAndMax.isNotEmpty) {
      state.isHaveFilterConditions.value = true;
    }
  }

  int findSelectedFiltersIndex(int index) {
    if (state.selectedFilters.isEmpty || state.selectedFilters.length <= index) {
      return -1;
    }

    var selectedFilter = state.selectedFilters[index];
    if (state.filterComponentEntity.value.filters != null) {
      int index = state.filterComponentEntity.value.filters!.indexWhere(
          (filter) => filter.fieldCode == selectedFilter.fieldCode && filter.filterType == selectedFilter.filterType);
      return index;
    }

    return -1;
  }

  List collectFilterParams() {
    var filterParams = [];

    // 金额Range
    if (state.filterMinAndMax.isNotEmpty) {
      var rangeParams = {
        "fieldCode": state.rangeFilterEntity.value.fieldCode,
        "filterType":
            RSUtils.enumToString(AnalyticsTools().returnFilterType(state.filterNumericalValueTypeString.first)),
        "filterValue": state.filterMinAndMax.toList(),
      };
      filterParams.add(rangeParams);
    }

    // 多元素合并操作
    state.filterComponentEntity.value.filters?.forEach((element) {
      element.options?.forEach((option) {
        if (option.isSelected) {
          var optionParams = {
            "fieldCode": element.fieldCode,
            "filterType": RSUtils.enumToString(element.filterType),
            "filterValue": List.from(option.value!),
          };

          bool isContain = false;

          for (var tmpElement in filterParams) {
            // 需判断当前实体相同的才做合并操作
            if (tmpElement["fieldCode"] == element.fieldCode) {
              isContain = true;
            }
          }

          if (!isContain) {
            filterParams.add(optionParams);
          } else {
            for (var tmpFilter in List.from(filterParams)) {
              if (tmpFilter is Map<String, dynamic>) {
                // 需判断当前实体相同的才做合并操作
                if (tmpFilter["fieldCode"] == element.fieldCode) {
                  List listFilterValue = tmpFilter["filterValue"];
                  tmpFilter["filterValue"] = (listFilterValue + option.value!).toSet().toList(); //listFilterValue;
                }
              }
            }
          }
        }
      });
    });
    return filterParams;
  }
}
