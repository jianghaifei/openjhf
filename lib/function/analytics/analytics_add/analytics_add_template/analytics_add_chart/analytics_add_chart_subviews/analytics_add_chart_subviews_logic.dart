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
    // if (state.selectedBasicDimIndex.value == -1) {
    //   state.basicDimErrorTip.value = true;
    //   EasyLoading.showToast('${S.current.rs_dim} ${S.current.rs_cannot_be_empty}');
    //   return false;
    // } else {
    //   state.basicDimErrorTip.value = false;
    // }

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
      // else {
      //   state.comparedToErrorTip.value = true;
      //   EasyLoading.showToast('${S.current.rs_compare_to} ${S.current.rs_cannot_be_empty}');
      //   return false;
      // }
    }

    return true;
  }

  void backEditingPage(MetricsEditInfoMetricsCard? editInfo) {
    if (!validateForm(editInfo?.cardType?.code)) {
      return;
    }
    TopicTemplateTemplatesNavsTabsCards card = TopicTemplateTemplatesNavsTabsCards();
    card.cardMetadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata();
    card.cardMetadata?.compareInfo = TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfo();
    card.cardMetadata?.compareInfo?.metrics = <TopicTemplateTemplatesNavsTabsCardsCardMetadataCompareInfoMetrics>[];
    card.cardMetadata?.chartType = <TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType>[];
    card.cardMetadata?.metrics = <TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics>[];
    card.cardMetadata?.dims = <TopicTemplateTemplatesNavsTabsCardsCardMetadataDims>[];

    // cardName
    card.cardName = state.nameTextController.text;

    // ---- cardMetadata ----

    // cardType
    card.cardMetadata?.cardType = editInfo?.cardType?.code;

    // chartType
    if (editInfo?.cardType?.code != TopicCardType.DATA_CHART_RANK) {
      var chartType1 = TopicTemplateTemplatesNavsTabsCardsCardMetadataChartType();
      chartType1.code = editInfo?.chartType?[state.selectedChartLabelIndex.value].code;
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
                card.cardMetadata?.metrics
                    ?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataMetrics.fromJson(metric.toJson()));
              }
            });
          });
        }
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
      editInfo?.dims?.forEach((dim) {
        card.cardMetadata?.dims?.add(TopicTemplateTemplatesNavsTabsCardsCardMetadataDims.fromJson(dim.toJson()));
      });
    }

    // CompareInfo
    if (editInfo?.cardType?.code == TopicCardType.DATA_CHART_PERIOD) {
      if (state.formComparedToIsCheck.value && state.selectedComparedToFormIndex.value != -1) {
        var compareType = editInfo?.compareType?[state.selectedComparedToFormIndex.value];
        if (compareType != null) {
          card.cardMetadata?.compareInfo?.compareType = compareType.code;
          if (compareType.code == AddMetricsCompareType.METRICS) {
            if (state.selectedComparedToMetricsFormIndex.value != -1) {
              var compareMetric = editInfo?.metrics?[state.selectedComparedToMetricsFormIndex.value];
              if (compareMetric != null) {
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

    // Ranking-compareInfo
    if (editInfo?.cardType?.code == TopicCardType.DATA_CHART_RANK && state.formComparedToIsCheck.value) {
      card.cardMetadata?.compareInfo?.compareType = editInfo?.compareType?.first.code;
    }

    final AnalyticsEditingLogic logic = Get.find<AnalyticsEditingLogic>();
    if (state.cardTemplateData != null) {
      logic.updateCardData(card, state.cardIndex);
    } else {
      logic.addCardData(card);
    }

    logger.d("backEditingPage", StackTrace.current);

    Get.until((route) => Get.currentRoute == AppRoutes.analyticsEditingPage);
  }
}
