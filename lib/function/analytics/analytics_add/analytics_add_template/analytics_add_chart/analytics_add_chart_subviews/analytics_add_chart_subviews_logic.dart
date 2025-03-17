import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:get/get.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../model/business_topic/topic_template_entity.dart';
import '../../../../../../router/app_routes.dart';
import '../../../../../../utils/logger/logger_helper.dart';
import '../../../../analytics_editing/analytics_editing_logic.dart';
import 'analytics_add_chart_subviews_state.dart';

class AnalyticsAddChartSubviewsLogic extends GetxController {
  final AnalyticsAddChartSubviewsState state = AnalyticsAddChartSubviewsState();

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

  void setEditPageData(
      int cardIndex, TopicTemplateTemplatesNavsTabsCards? cardTemplateData, MetricsEditInfoMetricsCard? custom) {
    if (cardTemplateData != null) {
      state.cardIndex = cardIndex;

      state.cardTemplateData = cardTemplateData;
      // Name
      state.nameTextController.text = cardTemplateData.cardName ?? '';

      // Chart type
      final chartType = cardTemplateData.cardMetadata?.chartType;
      if (chartType != null && chartType.isNotEmpty) {
        var firstChartType = chartType.first;

        int? chartIndex = custom?.chartType?.indexWhere((element) => element.code == firstChartType.code);
        if (chartIndex != null && chartIndex != -1) {
          state.selectedChartLabelIndex.value = chartIndex;
        }

        // Advanced Chart type
        if (chartType.length > 1) {
          var lastChartType = chartType.last;

          int? lastChartIndex =
              custom?.advancedInfo?.chartType?.indexWhere((element) => element.code == lastChartType.code);
          if (lastChartIndex != null && lastChartIndex != -1) {
            state.selectedChartLabelChangeIndex.value = lastChartIndex;
          }
        }
      }

      // Metrics
      final metrics = cardTemplateData.cardMetadata?.metrics;
      if (metrics != null && metrics.isNotEmpty) {
        var basicMetric = metrics.first;

        int? basicMetricIndex = custom?.metrics?.indexWhere((element) => element.metricCode == basicMetric.metricCode);
        if (basicMetricIndex != null && basicMetricIndex != -1) {
          state.selectedBasicMetricIndex.value = basicMetricIndex;
          state.recordSelectedBasicMetric.value = custom!.metrics![basicMetricIndex];
        }

        // Advanced Metrics
        if (metrics.length > 1) {
          List<int> advancedMetricIndex = [];
          List<MetricsEditInfoMetrics>? advancedMetrics = [];

          for (int i = 1; i < metrics.length; i++) {
            var tmpMetric = metrics[i];

            int? findIndex = custom?.metrics?.indexWhere((element) => element.metricCode == tmpMetric.metricCode);
            if (findIndex != null && findIndex != -1) {
              advancedMetricIndex.add(findIndex);
              advancedMetrics.add(custom!.metrics![findIndex]);
            }
          }

          if (advancedMetricIndex.isNotEmpty) {
            state.selectedAllMetricsFormIndex.value = advancedMetricIndex;
            state.recordSelectedAllMetrics.value = advancedMetrics;
          }
        }

        // 循环将所有cardTemplateData.cardMetadata?.metrics.dimOptions赋值给custom.metrics.dimsOptions
        for (var metric in metrics) {
          custom?.metrics?.forEach((customMetric) {
            if (customMetric.metricCode == metric.metricCode) {
              customMetric.dimOptions = metric.dimOptions;
            }
          });
        }
      }

      // Dims
      final dims = cardTemplateData.cardMetadata?.dims;
      if (dims != null && dims.isNotEmpty) {
        var basicDim = dims.first;

        int? basicDimIndex = custom?.dims?.indexWhere((element) => element.dimCode == basicDim.dimCode);
        if (basicDimIndex != null && basicDimIndex != -1) {
          state.selectedBasicDimIndex.value = basicDimIndex;
          state.recordSelectedBasicDim.value = custom!.dims![basicDimIndex];
        }

        // Advanced Dims
        if (dims.length > 1) {
          List<int> advancedDimIndex = [];
          List<MetricsEditInfoDims>? advancedDims = [];

          for (int i = 1; i < dims.length; i++) {
            var tmpMetric = dims[i];

            int? findIndex = custom?.dims?.indexWhere((element) => element.dimCode == tmpMetric.dimCode);
            if (findIndex != null && findIndex != -1) {
              advancedDimIndex.add(findIndex);
              advancedDims.add(custom!.dims![findIndex]);
            }
          }

          if (advancedDimIndex.isNotEmpty) {
            state.selectedAllDimsFormIndex.value = advancedDimIndex;
            state.recordSelectedAllDims.value = advancedDims;
          }
        }

        // 循环将所有cardTemplateData.cardMetadata?.dims.metricsOptions赋值给custom.dims.metricsOptions
        for (var dim in dims) {
          custom?.dims?.forEach((customDim) {
            if (customDim.dimCode == dim.dimCode) {
              customDim.metricOptions = dim.metricOptions;
            }
          });
        }
      }

      // Compared to
      final compareInfo = cardTemplateData.cardMetadata?.compareInfo;
      if (compareInfo != null && compareInfo.compareType != null) {
        state.formComparedToIsCheck.value = true;

        int? comparedToIndex = custom?.compareType?.indexWhere((element) => element.code == compareInfo.compareType);
        if (comparedToIndex != null && comparedToIndex != -1) {
          state.selectedComparedToFormIndex.value = comparedToIndex;
        }

        if (compareInfo.compareType == AddMetricsCompareType.METRICS) {
          // 对比指标
          List<int> sameIndexes = [];

          var customMetrics = custom?.metrics;
          var compareMetrics = compareInfo.metrics;
          if (customMetrics != null && compareMetrics != null) {
            for (int i = 0; i < compareMetrics.length; i++) {
              var compareMetricElement = compareMetrics[i];

              for (var customMetricElement in customMetrics) {
                if (compareMetricElement.metricCode == customMetricElement.metricCode) {
                  var customMetricIndex = customMetrics.indexOf(customMetricElement);
                  sameIndexes.add(customMetricIndex);
                }
              }
            }
          }

          if (sameIndexes.isNotEmpty) {
            state.selectedComparedToMetricsFormIndex.value = sameIndexes.first;
          }
        }
      }

      // 展示条数
      if (custom?.cardType?.code == TopicCardType.DATA_CHART_RANK) {
        // 当前是排行类型
        final pageSize = cardTemplateData.cardMetadata?.pageSize;
        if (pageSize != null) {
          int? findIndex = custom?.pageSize?.indexWhere((element) => element.value == pageSize);
          if (findIndex != null && findIndex != -1) {
            state.selectedDisplayCountIndex.value = findIndex;
          }
        }
      } else {
        final pageSize = cardTemplateData.cardMetadata?.chartType?.first.pageSize;
        if (pageSize != null) {
          int? findIndex = custom?.chartType?.first.pageSize?.indexWhere((element) => element.value == pageSize);
          if (findIndex != null && findIndex != -1) {
            state.selectedChartLabelDisplayCountIndex.value = findIndex;
          }
        }
      }

      // Filter
      final filter = cardTemplateData.cardMetadata?.filterInfo?.filters?.first;
      final filterOptions = getFilterOptions();

      if (filter != null && filterOptions != null) {
        for (int i = 0; i < filterOptions.length; i++) {
          var option = filterOptions[i];
          if (option.fieldCode == filter.fieldCode) {
            state.selectedFilterIndex.value = i;
            state.recordSelectedFilter.value = option;
            state.recordSelectedFilter.value.bindOptionsValue = filter.filterValue;
            debugPrint("state.recordSelectedFilter.value:${state.recordSelectedFilter.value}");
          }
        }
      }
    }
  }

  bool validateForm(TopicCardType? subviewsType) {
    // Name
    if (state.nameTextController.text.isEmpty) {
      state.nameErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_name} ${S.current.rs_cannot_be_empty}');
      return false;
    } else {
      state.nameErrorTip.value = false;
    }

    // Chart type
    if ((subviewsType == TopicCardType.DATA_CHART_PERIOD || subviewsType == TopicCardType.DATA_CHART_GROUP) &&
        state.selectedChartLabelIndex.value == -1) {
      state.chartLabelErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_chart_type} ${S.current.rs_cannot_be_empty}');
      return false;
    } else {
      state.chartLabelErrorTip.value = false;
    }

    // Metrics
    if (subviewsType != TopicCardType.DATA_CHART_RANK && state.selectedBasicMetricIndex.value == -1) {
      state.basicMetricErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_metric} ${S.current.rs_cannot_be_empty}');
      return false;
    } else {
      state.basicMetricErrorTip.value = false;
    }

    // Dims
    if (subviewsType == TopicCardType.DATA_CHART_RANK && state.selectedBasicDimIndex.value == -1) {
      state.basicDimErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_dim} ${S.current.rs_cannot_be_empty}');
      return false;
    } else {
      state.basicDimErrorTip.value = false;
    }

    // Compared to
    if (subviewsType == TopicCardType.DATA_CHART_PERIOD) {
      if (state.formComparedToIsCheck.value) {
        if (state.selectedComparedToFormIndex.value == -1) {
          state.comparedToErrorTip.value = true;
          EasyLoading.showToast('${S.current.rs_compare_to} ${S.current.rs_cannot_be_empty}');
          return false;
        } else {
          state.comparedToMetricsErrorTip.value = false;

          var compareTypeCode = state.chartEntity?.compareType?[state.selectedComparedToFormIndex.value].code;
          if (compareTypeCode == AddMetricsCompareType.METRICS) {
            // Compared to Metrics
            if (state.selectedComparedToMetricsFormIndex.value == -1) {
              state.comparedToMetricsErrorTip.value = true;
              EasyLoading.showToast('${S.current.rs_compared_metric} ${S.current.rs_cannot_be_empty}');
              return false;
            } else {
              state.comparedToMetricsErrorTip.value = false;
            }
          } else if (compareTypeCode == AddMetricsCompareType.PREVIOUS) {
            // Compared to Previous
            if (state.selectedComparedToFormIndex.value == -1) {
              state.comparedToMetricsErrorTip.value = true;
              EasyLoading.showToast('${S.current.rs_compared_metric} ${S.current.rs_cannot_be_empty}');
              return false;
            } else {
              state.comparedToMetricsErrorTip.value = false;
            }
          }
        }
      }
    }

    // 展示条数
    if (subviewsType == TopicCardType.DATA_CHART_RANK) {
      if (state.selectedDisplayCountIndex.value == -1) {
        state.displayCountErrorTip.value = true;
        EasyLoading.showToast('${S.current.rs_display_quantity} ${S.current.rs_cannot_be_empty}');
        return false;
      } else {
        state.displayCountErrorTip.value = false;
      }
    }

    return true;
  }

  void backEditingPage(MetricsEditInfoMetricsCard? editInfo) {
    if (!validateForm(editInfo?.cardType?.code)) {
      return;
    }
    TopicTemplateTemplatesNavsTabsCards card = TopicTemplateTemplatesNavsTabsCards();
    card.cardMetadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata();
    card.cardMetadata?.metrics = <TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>[];
    card.cardMetadata?.dims = <TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>[];

    // cardName
    card.cardName = state.nameTextController.text;

    // ---- cardMetadata ----

    // cardType
    card.cardMetadata?.cardType = editInfo?.cardType?.code;

    // chartType
    if (editInfo?.cardType?.code != TopicCardType.DATA_CHART_RANK) {
      card.cardMetadata?.chartType = <TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>[];

      var chartType1 = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
      chartType1.code = editInfo?.chartType?[state.selectedChartLabelIndex.value].code;
      chartType1.pageSize = editInfo?.chartType?[state.selectedChartLabelIndex.value]
          .pageSize?[state.selectedChartLabelDisplayCountIndex.value].value;
      card.cardMetadata?.chartType?.add(chartType1);

      if (state.selectedChartLabelChangeIndex.value != -1) {
        var chartType2 = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
        chartType2.code = editInfo?.advancedInfo?.chartType?[state.selectedChartLabelChangeIndex.value].code;
        card.cardMetadata?.chartType?.add(chartType2);
      }
    }

    if (state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_RANK) {
      // Dims
      if (state.selectedBasicDimIndex.value != -1) {
        var tmpDim = editInfo?.dims?[state.selectedBasicDimIndex.value];
        tmpDim?.ifDefault = true;
        if (tmpDim != null) {
          card.cardMetadata?.dims?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(tmpDim.toJson()));

          tmpDim.metricOptions?.forEach((metricOption) {
            // Metrics
            editInfo?.metrics?.forEach((metric) {
              if (metric.metricCode == metricOption) {
                // card.cardMetadata.metrics去重添加
                if (card.cardMetadata!.metrics!.where((item) => item.metricCode == metric.metricCode).isEmpty) {
                  card.cardMetadata?.metrics
                      ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));
                }
              }
            });
          });
        }
      }

      // 展示条数
      if (state.selectedDisplayCountIndex.value != -1) {
        var tmpDisplayCount = editInfo?.pageSize?[state.selectedDisplayCountIndex.value].value;
        card.cardMetadata?.pageSize = tmpDisplayCount;
      }
    } else {
      // Metrics
      if (state.selectedBasicMetricIndex.value != -1) {
        var tmpMetric = editInfo?.metrics?[state.selectedBasicMetricIndex.value];
        tmpMetric?.ifDefault = true;
        if (tmpMetric != null) {
          card.cardMetadata?.metrics
              ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(tmpMetric.toJson()));
        }

        var tmpMetricList = state.selectedAllMetricsFormIndex.map((index) => editInfo?.metrics?[index]).toList();
        if (tmpMetricList.isNotEmpty) {
          for (var metric in tmpMetricList) {
            if (metric != null) {
              metric.ifDefault = true;
              card.cardMetadata?.metrics
                  ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));
            }
          }
        }
      }

      // Dims
      editInfo?.metrics?.forEach((metric) {
        if (metric.dimOptions != null) {
          metric.dimOptions?.forEach((dimOption) {
            editInfo.dims?.forEach((dim) {
              if (dimOption == dim.dimCode) {
                // card.cardMetadata.dims去重添加
                if (card.cardMetadata!.dims!.where((item) => item.dimCode == dim.dimCode).isEmpty) {
                  card.cardMetadata?.dims
                      ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(dim.toJson()));
                }
              }
            });
          });
        }
      });
    }

    // CompareInfo
    if (editInfo?.cardType?.code == TopicCardType.DATA_CHART_PERIOD) {
      if (state.formComparedToIsCheck.value && state.selectedComparedToFormIndex.value != -1) {
        var compareType = editInfo?.compareType?[state.selectedComparedToFormIndex.value];
        if (compareType != null) {
          card.cardMetadata?.compareInfo = TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo();
          card.cardMetadata?.compareInfo?.compareType = compareType.code;
          if (compareType.code == AddMetricsCompareType.METRICS) {
            if (state.selectedComparedToMetricsFormIndex.value != -1) {
              var compareMetric = editInfo?.metrics?[state.selectedComparedToMetricsFormIndex.value];
              if (compareMetric != null) {
                card.cardMetadata?.compareInfo?.metrics =
                    <TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>[];
                card.cardMetadata?.compareInfo?.metrics?.add(
                    TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics.fromJson(compareMetric.toJson()));
              }
            }
          }
        }
        // CompareInfo compareType
        card.cardMetadata?.compareInfo?.compareType =
            editInfo?.compareType?[state.selectedComparedToFormIndex.value].code;
      }
    }

    // FilterInfo
    if (state.selectedFilterIndex.value != -1) {
      card.cardMetadata?.filterInfo = TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfo();
      card.cardMetadata?.filterInfo?.filters = <TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters>[];

      TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters filterInfoFilter =
          TopicTemplateTemplatesNavsTabsCardsCardMetadataFilterInfoFilters();
      filterInfoFilter.fieldCode = state.recordSelectedFilter.value.fieldCode;
      filterInfoFilter.filterType = state.recordSelectedFilter.value.filterType;
      filterInfoFilter.filterValue = state.recordSelectedFilter.value.bindOptionsValue;

      card.cardMetadata?.filterInfo?.filters?.add(filterInfoFilter);
    }

    // Ranking-compareInfo
    // if (editInfo?.cardType?.code == TopicCardType.DATA_CHART_RANK && state.formComparedToIsCheck.value) {
    //   card.cardMetadata?.compareInfo?.compareType = editInfo?.compareType?.first.code;
    // }

    final AnalyticsEditingLogic logic = Get.find<AnalyticsEditingLogic>();
    if (state.cardTemplateData != null) {
      logic.updateCardData(card, state.cardIndex);
    } else {
      logic.addCardData(card);
    }

    logger.d("backEditingPage", StackTrace.current);

    Get.until((route) => Get.currentRoute == AppRoutes.analyticsEditingPage);
  }

  List<MetricsEditInfoMetricFilterConfiguratorFilterOptions>? getFilterOptions() {
    // 获取所有选中的Metrics
    final allSelectedMetrics = <MetricsEditInfoMetrics>[];

    if (state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_RANK) {
      // Dims
      if (state.selectedBasicDimIndex.value != -1) {
        var tmpDim = state.chartEntity?.dims?[state.selectedBasicDimIndex.value];
        tmpDim?.ifDefault = true;
        if (tmpDim != null) {
          tmpDim.metricOptions?.forEach((metricOption) {
            // Metrics
            state.chartEntity?.metrics?.forEach((metric) {
              if (metric.metricCode == metricOption) {
                allSelectedMetrics.add(metric);
              }
            });
          });
        }
      }
    } else {
      allSelectedMetrics.add(state.recordSelectedBasicMetric.value);

      if (state.recordSelectedAllMetrics.isNotEmpty) {
        allSelectedMetrics.addAll(state.recordSelectedAllMetrics);
      }
    }

    final metricFilterConfigurator = state.chartEntity?.metricFilterConfigurator;

    if (metricFilterConfigurator != null) {
      // 获取所有MetricCode和选中Metrics相同的元素
      List<MetricsEditInfoMetricFilterConfigurator>? filterConfigurator =
          metricFilterConfigurator.where((metricFilterConfigurator) {
        for (var metric in allSelectedMetrics) {
          if (metricFilterConfigurator.metricCode == metric.metricCode) {
            return true;
          }
        }
        return false;
      }).toList();

      if (filterConfigurator.isNotEmpty) {
        // 遍历filterConfigurator，获取FieldCode相交集的元素

        List<List<MetricsEditInfoMetricFilterConfiguratorFilterOptions>> filterOptions = [];

        for (var element in filterConfigurator) {
          if (element.filterOptions != null && element.filterOptions!.isNotEmpty) {
            filterOptions.add(element.filterOptions!);
          }
        }

        if (filterOptions.isNotEmpty) {
          // 将第一个数据源的 fieldCode 提取到集合
          Set<String?> intersection = filterOptions[0].map((option) => option.fieldCode).toSet();

          // 对其余的数据源进行交集操作
          for (int i = 1; i < filterOptions.length; i++) {
            Set<String?> currentSet = filterOptions[i].map((option) => option.fieldCode).toSet();
            intersection = intersection.intersection(currentSet);
          }

          // 输出交集对应的 FilterOption 模型元素
          List<MetricsEditInfoMetricFilterConfiguratorFilterOptions> result = [];
          Set<String?> addedFieldCodes = {}; // 用于存储已添加的 fieldCode

          if (intersection.isNotEmpty) {
            for (var dataSource in filterOptions) {
              for (var option in dataSource) {
                if (intersection.contains(option.fieldCode) && !addedFieldCodes.contains(option.fieldCode)) {
                  result.add(MetricsEditInfoMetricFilterConfiguratorFilterOptions.fromJson(option.toJson()));
                  addedFieldCodes.add(option.fieldCode); // 记录已添加的 fieldCode
                }
              }
            }
          }

          // 打印结果
          for (var option in result) {
            debugPrint('FieldCode: ${option.fieldCode}, DisplayName: ${option.displayName}');
          }

          return result;
        }
      }
    }
    return null;
  }

  // 清空Filter相关记录
  void clearFilter() {
    state.selectedFilterIndex.value = -1;
    state.recordSelectedFilter.value = MetricsEditInfoMetricFilterConfiguratorFilterOptions();
  }
}
