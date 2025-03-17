import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../model/dining_table/dining_table_shops_template_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../../utils/analytics_tools.dart';
import '../../../../utils/date_util.dart';
import '../../../../utils/network/request.dart';
import '../../../../utils/network/request_client.dart';
import '../../../../utils/network/server_url.dart';
import '../../../../utils/utils.dart';
import '../../../card_load_state_layout.dart';
import 'dining_table_list_state.dart';

class DiningTableListLogic extends GetxController {
  final DiningTableListState state = DiningTableListState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    setCurrentTimeTitle();
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

  /// 桌台-获取桌台列表模板
  Future<void> loadDiningTableListTemplate() async {
    await request(() async {
      DiningTableShopsTemplateEntity? templateEntity = await requestClient.request(
        RSServerUrl.diningTableListTemplate,
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
        // 桌台-获取桌台列表
        // loadDiningTableList();
        // 查询指标筛选组件数据
        loadFilterComponent();
      }
    }, showLoading: true);
  }

  /// 查询指标筛选组件数据
  Future<void> loadFilterComponent() async {
    await request(() async {
      Map<String, dynamic> params = {
        "shopIds": state.shopId,
      };

      AnalyticsEntityFilterComponentEntity? filterComponentEntity = await requestClient.request(
        RSServerUrl.diningTableComponentList,
        method: RequestType.post,
        data: params,
        onResponse: (response) {},
        onError: (error) {
          state.errorCode = error.code;
          state.errorMessage = error.message;
          return false;
        },
      );
      if (filterComponentEntity != null) {
        int elementIndex = 0;
        filterComponentEntity.orderBy?.forEach((element) {
          if (element.ifDefault) {
            state.selectedOrderByIndex.value = elementIndex;
          }
          elementIndex++;
        });

        state.filterComponentEntity.value = filterComponentEntity;
      }

      // 配置搜索/Range实体模型
      setSearchAndRangeFilterEntity();
      // 桌台-获取桌台列表
      loadDiningTableList();
      // 检查是否拥有过滤条件
      checkIsHaveFilterConditions();
    }, showLoading: true);
  }

  /// 配置搜索/Range实体模型
  void setSearchAndRangeFilterEntity() {
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

  /// 收集过滤器参数
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
                  // listFilterValue.addAll(option.value!);
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

  /// 设置filter最大最小值
  void setMinAndMaxNumbers(List<double?> numbers, List<String> filterTypeString) {
    debugPrint("limitNumbers = $numbers, filterTypeString = $filterTypeString");

    state.filterMinAndMax.value = numbers;

    state.filterNumericalValueTypeString.value = filterTypeString;
  }

  /// 检查是否拥有过滤条件
  void checkIsHaveFilterConditions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.selectedFilters.clear();
      state.isHaveFilterConditions.value = false;

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
    });
  }

  /// 查找所选筛选条件索引
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

  /// 桌台-获取桌台列表
  Future<void> loadDiningTableList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.loadState.value = CardLoadState.stateLoading;
    });
    await request(() async {
      setCurrentTimeTitle();

      Map<String, dynamic> params = {
        "shopIds": state.shopId,
        "date": state.timeRange ?? RSDateUtil.dateRangeToListString(RSAccountManager().timeRange),
      };

      // metrics
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

      // dims
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

      // filter
      var filterParams = collectFilterParams();
      if (filterParams.isNotEmpty) {
        params["filters"] = filterParams;
      }

      StorePKTableEntity? storePKTableEntity = await requestClient.request(
        RSServerUrl.diningTableList,
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
