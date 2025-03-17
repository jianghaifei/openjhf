import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_list_setting_options_entity.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/analytics_entity_list/analytics_entity_list_entity.dart';
import '../../../model/analytics_entity_list/evaluate_list_entity.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../router/app_routes.dart';
import 'analytics_entity_list_state.dart';

class AnalyticsEntityListLogic extends GetxController {
  final AnalyticsEntityListState state = AnalyticsEntityListState();

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

  void refreshData({bool showLoading = false}) async {
    logger.d("refreshData", StackTrace.current);

    // 重置页码
    state.currentPageNo = 1;

    requestListEntities(true, isShowLoading: showLoading);
  }

  void loadMoreData() {
    logger.d("loadMoreData", StackTrace.current);

    requestListEntities(false, isShowLoading: false);
  }

  /// 查询指标筛选组件数据
  Future<void> requestFilterComponent() async {
    await request(() async {
      var params = {
        "metricCode": state.filterMetricCode,
        "shopIds": state.shopIds ?? RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
        "entity": state.entity,
      };

      // 上一个列表页传入，用来让后端处理当前列表页Filter哪些是默认选中
      if (state.filterParams.isNotEmpty) {
        params["relationFilters"] = state.filterParams;
      }

      logger.d("查询指标筛选组件数据params:$params", StackTrace.current);

      AnalyticsEntityFilterComponentEntity? entity = await requestClient.request(RSServerUrl.getComponentList,
          method: RequestType.post, data: params, onResponse: (response) {}, onError: (error) {
        return false;
      });

      if (entity != null) {
        int elementIndex = 0;
        entity.orderBy?.forEach((element) {
          if (element.ifDefault) {
            state.selectedOrderByIndex.value = elementIndex;
          }
          elementIndex++;
        });

        // 从一级页带过来的默认选项
        entity.filters?.forEach((element) {
          if (element.fieldCode == state.dimsCode) {
            element.options?.forEach((option) {
              state.filters?.forEach((filter) {
                if (listEquals(option.value, filter.filterValue)) {
                  option.isSelected = true;
                }
              });

              // 此处删除会导致元数据删除，外部传值时需使用深拷贝
              state.filters?.removeWhere((filter) => listEquals(option.value, filter.filterValue));
            });
          } else {
            // 如果返回数据即默认选中
            element.options?.forEach((option) {
              if (option.ifDefault) {
                option.ifDefault = false;
                option.isSelected = true;
              }
            });
          }
        });

        state.filterComponentEntity.value = entity;
      }

      // 配置搜索/Range实体模型
      setSearchAndRangeFilterEntity();
      // 查询实体列表
      requestListEntities(true);

      checkIsHaveFilterConditions();
    }, showLoading: true);
  }

  /// 查询实体列表
  void requestListEntities(bool isRefresh, {bool isShowLoading = true}) async {
    var params = {
      "shopIds": state.shopIds ?? RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList(),
      "entity": state.entity,
      "metricCode": state.metricCode,
      "date": state.timeRange,
      "dateType": state.customDateToolEnum.name,
      "page": {"pageNo": isRefresh ? 1 : state.currentPageNo, "pageSize": state.pageSize},
      "orderBy": [
        {state.metricCode: state.isAscSort.value ? "ASC" : "DESC"},
      ]
    };

    // 上一个列表页传入
    if (state.lastEntity != null) {
      var relationInfoMap = {};

      relationInfoMap["entity"] = state.lastEntity;

      // 上一个列表页传入
      if (state.relationDims.isNotEmpty) {
        relationInfoMap["dims"] = state.relationDims;
      }

      // 上一个列表页传入
      if (state.relationMetrics.isNotEmpty) {
        relationInfoMap["metrics"] = state.relationMetrics;
      }

      params["relationInfo"] = relationInfoMap;
    }

    // 按xxx排序
    if (state.selectedOrderByIndex.value >= 0) {
      String? fieldCode = state.filterComponentEntity.value.orderBy?[state.selectedOrderByIndex.value].fieldCode;

      if (fieldCode != null) {
        var orderByParams = [
          {fieldCode: state.isAscSort.value ? "ASC" : "DESC"},
        ];

        params["orderBy"] = orderByParams;
      }
    }

    var filterParams = collectFilterParams();
    if (filterParams.isNotEmpty) {
      params["filters"] = filterParams;
    }

    logger.d("查询实体列表params:$params", StackTrace.current);

    await request(() async {
      if (state.entity == state.EVALUATION) {
        EvaluateListEntity? entity = await requestClient.request(
          RSServerUrl.listCommentEntities,
          method: RequestType.post,
          data: params,
          onResponse: (response) {
            // 页码自增
            state.currentPageNo++;
          },
          onError: (error) {
            if (isRefresh) {
              state.refreshController.finishRefresh(IndicatorResult.fail);
            } else {
              state.refreshController.finishLoad(IndicatorResult.fail);
            }
            return false;
          },
        );

        if (entity != null) {
          if (isRefresh) {
            state.evaluateListEntity.value = entity;
            state.refreshController.finishRefresh(IndicatorResult.success);
          } else {
            if (entity.list != null) {
              state.evaluateListEntity.update((val) {
                val?.list?.addAll(entity.list!);
              });

              state.refreshController.finishLoad(IndicatorResult.success);
            }
          }

          // 判断是否最后一页
          if (state.currentPageNo > int.parse("${entity.page?.pageCount ?? 0}")) {
            state.refreshController.finishLoad(IndicatorResult.noMore);
          }
        }
      } else {
        AnalyticsEntityListEntity? entity = await requestClient.request(
          RSServerUrl.listTopicEntities,
          method: RequestType.post,
          data: params,
          onResponse: (response) {
            // 页码自增
            state.currentPageNo++;
          },
          onError: (error) {
            if (isRefresh) {
              state.refreshController.finishRefresh(IndicatorResult.fail);
            } else {
              state.refreshController.finishLoad(IndicatorResult.fail);
            }
            return false;
          },
        );

        if (entity != null) {
          if (isRefresh) {
            state.listEntity.value = entity;
            state.refreshController.finishRefresh(IndicatorResult.success);
          } else {
            // 页码自增
            if (entity.list != null) {
              state.listEntity.update((val) {
                val?.list?.addAll(entity.list!);
              });

              state.refreshController.finishLoad(IndicatorResult.success);
            }
          }

          // 判断是否最后一页
          if (state.currentPageNo > int.parse("${entity.page?.pageCount ?? 0}")) {
            state.refreshController.finishLoad(IndicatorResult.noMore);
          }
        }
      }
    }, showLoading: isShowLoading);
  }

  List collectFilterParams() {
    var filterParams = [];

    // 输入框
    var searchText = state.searchTextFieldController.value.text;
    if (searchText.isNotEmpty) {
      var searchParams = {
        "fieldCode": state.searchFilterEntity.value.fieldCode,
        "filterType": RSUtils.enumToString(state.searchFilterEntity.value.filterType),
        "filterValue": [searchText],
        "entity": state.entity,
      };
      filterParams.add(searchParams);
    }

    // if (state.filterValueArray != null) {
    //   // 一级页点击其它进来
    //   var eqParams = {
    //     "fieldCode": state.dimsCode,
    //     "filterType": "NOT_IN",
    //     "filterValue": state.filterValueArray,
    //     "entity": state.entity,
    //   };
    //   filterParams.add(eqParams);
    // }
    // else {
    //   // 其他页面传递过来的值
    //   if (state.filterValue != null) {
    //     var eqParams = {
    //       "fieldCode": state.dimsCode,
    //       "filterType": "EQ",
    //       "filterValue": [state.filterValue],
    //       "entity": state.entity,
    //     };
    //     filterParams.add(eqParams);
    //   }
    // }

    // 首页过来传递的filters
    final filter = state.filters;
    if (filter != null && filter.isNotEmpty) {
      for (var element in filter) {
        var filterMap = {
          "fieldCode": element.fieldCode,
          "filterType": element.filterType?.name,
          "filterValue": element.filterValue,
          "entity": element.entity,
        };
        filterParams.add(filterMap);
      }
    }

    // 上一个列表页传入
    if (state.filterParams.isNotEmpty) {
      filterParams.addAll(state.filterParams);
    }

    // 金额Range
    if (state.filterMinAndMax.isNotEmpty) {
      var rangeParams = {
        "fieldCode": state.rangeFilterEntity.value.fieldCode,
        "filterType":
            RSUtils.enumToString(AnalyticsTools().returnFilterType(state.filterNumericalValueTypeString.first)),
        "filterValue": state.filterMinAndMax.toList(),
        "entity": state.entity,
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
            "entity": state.entity,
          };

          bool isContain = false;

          for (var tmpElement in filterParams) {
            // 需判断当前实体相同的才做合并操作
            if (tmpElement["fieldCode"] == element.fieldCode && tmpElement["entity"] == state.entity) {
              isContain = true;
            }
          }

          if (!isContain) {
            filterParams.add(optionParams);
          } else {
            for (var tmpFilter in List.from(filterParams)) {
              if (tmpFilter is Map<String, dynamic>) {
                // 需判断当前实体相同的才做合并操作
                if (tmpFilter["fieldCode"] == element.fieldCode && tmpFilter["entity"] == state.entity) {
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

  /// 跳转详情或者列表页
  Future<void> jumpOrderDetailOrListPage(AnalyticsEntityListList? itemEntity) async {
    logger.d("点击列表页Item, pageType ${itemEntity?.next?.pageType}", StackTrace.current);

    if (itemEntity?.next?.pageType == EntityJumpPageType.ENTITY_LIST) {
      // 列表页
      jumpNewEntityListPage(itemEntity);
    } else if (itemEntity?.next?.pageType == EntityJumpPageType.ENTITY_DETAIL) {
      // 详情页
      loadOrderDetail(itemEntity);
    }
  }

  /// 跳转新的列表页
  void jumpNewEntityListPage(AnalyticsEntityListList? itemEntity) {
    logger.d("跳转新的列表页", StackTrace.current);

    var nextDims = itemEntity?.next?.filtersPassingInfo?.dims;
    var filterParams = [];

    nextDims?.forEach((dimsElement) {
      itemEntity?.dims?.forEach((elementMap) {
        if (elementMap.code == dimsElement) {
          filterParams.add({
            "fieldCode": dimsElement,
            "filterType": "EQ",
            "filterValue": [elementMap.value],
            "entity": state.entity,
          });
        }
      });
    });

    var tmpFilterParams = collectFilterParams();
    if (tmpFilterParams.isNotEmpty) {
      filterParams.addAll(tmpFilterParams);
    }

    var relationDims = [];
    itemEntity?.dims?.forEach((dimsElement) {
      relationDims.add(dimsElement.code);
    });

    var relationMetrics = [];
    relationMetrics.add(itemEntity?.primaryField?.code);

    Map<String, dynamic> arguments = {
      "entity": itemEntity?.next?.entity,
      "shopIds": state.shopIds,
      "customDateToolEnum": state.customDateToolEnum,
      "lastEntity": state.entity,
      "entityTitle": itemEntity?.next?.entityTitle,
      "metricCode": itemEntity?.next?.metricCode,
      "filterMetricCode": itemEntity?.next?.metricCode,
      "dimsCode": state.dimsCode,
      // "filterValue": state.filterValue,
      "timeRange": state.timeRange,
      "filterParams": filterParams,
      "relationDims": relationDims,
      "relationMetrics": relationMetrics,
    };

    Get.toNamed(AppRoutes.analyticsEntityListPage, arguments: arguments, preventDuplicates: false);
  }

  /// 返回主键Dim实体
  AnalyticsEntityListListDims? returnPrimaryKey(AnalyticsEntityListList? entity) {
    AnalyticsEntityListListDims? primaryDim;

    entity?.dims?.forEach((element) {
      if (element.primaryKey) {
        primaryDim = element;
      }
    });

    return primaryDim;
  }

  /// 加载订单详情页数据
  void loadOrderDetail(AnalyticsEntityListList? listEntity) async {
    String primaryDimId = '';
    String primaryDimIdCode = '';

    if (listEntity != null) {
      var dim = returnPrimaryKey(listEntity);
      primaryDimId = dim?.value ?? '';
      primaryDimIdCode = dim?.code ?? '';
    }

    if (primaryDimId.isNotEmpty && primaryDimIdCode.isNotEmpty && listEntity?.next?.entity != null) {
      logger.d("跳转至订单详情页", StackTrace.current);

      Get.toNamed(AppRoutes.analyticsEntityDetailPage, arguments: {
        "dimId": primaryDimId,
        "dimIdCode": primaryDimIdCode,
        "entity": listEntity?.next?.entity,
      });
    } else {
      EasyLoading.showError("Missing parameter");
    }
  }

  /// 设置filter最大最小值
  void setMinAndMaxNumbers(List<double?> numbers, List<String> filterTypeString) {
    debugPrint("limitNumbers = $numbers, filterTypeString = $filterTypeString");

    state.filterMinAndMax.value = numbers;

    state.filterNumericalValueTypeString.value = filterTypeString;
  }

  /// 配置搜索/Range实体模型
  void setSearchAndRangeFilterEntity() {
    state.filterComponentEntity.value.filters?.forEach((element) {
      if (element.componentType == EntityComponentType.INPUT) {
        state.searchFilterEntity.value = element;
      }
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

  /// 检查是否拥有过滤条件
  void checkIsHaveFilterConditions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.selectedFilters.clear();
      state.isHaveFilterConditions.value = false;

      state.filters?.forEach((filter) {
        var filterMap = {
          "fieldCode": filter.fieldCode,
          "filterType": filter.filterType?.name,
          "options": [
            {
              "displayName": filter.displayName,
              "value": filter.filterValue,
            }
          ]
        };
        var tmpModel = AnalyticsEntityFilterComponentFilters.fromJson(filterMap);
        state.selectedFilters.add(tmpModel);

        debugPrint("tmpModel = $tmpModel");
      });

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

  /// 删除指定过滤条件
  void deleteFilterCondition(int index) {
    // if (state.filterValue != null && index == 0) {
    //   state.filterValue = null;
    // } else {
    //   bool stopLoop = false;
    //   state.filterComponentEntity.value.filters?.forEach((element) {
    //     if (stopLoop) {
    //       return;
    //     }
    //     element.options?.forEach((option) {
    //       if (stopLoop) {
    //         return;
    //       }
    //       if (!stopLoop && option.isSelected && option.displayName == state.filterConditions[index]) {
    //         state.filterConditions.removeAt(index);
    //         option.isSelected = false;
    //         stopLoop = true;
    //       }
    //     });
    //   });
    // }
    //
    // checkIsHaveFilterConditions();
    // refreshData(showLoading: true);
  }

  void loadEntitySettingOptions(Function(AnalyticsEntityListSettingOptionsEntity entity) callback) async {
    await request(() async {
      AnalyticsEntityListSettingOptionsEntity? settingOptionsEntity = await requestClient
          .request(RSServerUrl.getListEntityOptions, method: RequestType.post, data: {"entity": state.entity},
              onResponse: (response) {
        debugPrint("response = $response");
      }, onError: (error) {
        return false;
      });

      if (settingOptionsEntity != null) {
        callback.call(settingOptionsEntity);
      }
    }, showLoading: true);
  }

  Future<void> editOrderDetailBaseOptions(AnalyticsEntityListSettingOptionsEntity entity) async {
    await request(() async {
      var params = getRequestParams(entity);

      await requestClient.request(RSServerUrl.editListEntityOptions, method: RequestType.post, data: params,
          onResponse: (response) {
        debugPrint("response = $response");
      }, onError: (error) {
        return false;
      });
    });
  }

  Map<String, dynamic> getRequestParams(AnalyticsEntityListSettingOptionsEntity entity) {
    List<String?> baseIds = [];
    List<String?> showIds = [];
    entity.options?.forEach((element) {
      baseIds.add(element.code);
      if (element.show) {
        showIds.add(element.code);
      }
    });
    return {
      "baseIds": baseIds,
      "showIds": showIds,
      "entity": state.entity,
    };
  }

  bool getListIsEmpty() {
    if (state.entity == state.EVALUATION) {
      return state.evaluateListEntity.value.list == null || state.evaluateListEntity.value.list!.isEmpty;
    } else {
      return state.listEntity.value.list == null || state.listEntity.value.list!.isEmpty;
    }
  }
}
