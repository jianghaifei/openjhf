import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_sub_views_metric/analytics_add_chart_sub_views_metric_view.dart';
import 'package:flutter_report_project/function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_subviews_state.dart';
import 'package:flutter_report_project/widget/bottom_sheet/picker_tool_bottom_sheet/picker_tool_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../config/rs_color.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../model/business_topic/topic_template_entity.dart';
import '../../../../../../router/app_routes.dart';
import '../../../../../../widget/analytics/analytics_add_metrics_widget/analytics_add_metrics_widget_view.dart';
import '../../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../../widget/bottom_sheet/analytics_add_metrics_bottom_sheet_page/analytics_add_metrics_bottom_sheet_view.dart';
import '../../../../../../widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import '../../../../../../widget/chart_label/chart_label_view.dart';
import 'analytics_add_chart_subviews_logic.dart';

class AnalyticsAddChartSubviewsPage extends StatefulWidget {
  const AnalyticsAddChartSubviewsPage({
    super.key,
    required this.chartEntity,
    required this.tabName,
    required this.cardTemplateData,
    required this.cardIndex,
  });

  final String tabName;
  final int cardIndex;
  final MetricsEditInfoMetricsCard? chartEntity;
  final TopicTemplateTemplatesNavsTabsCards? cardTemplateData;

  @override
  State<AnalyticsAddChartSubviewsPage> createState() => _AnalyticsAddChartSubviewsPageState();
}

class _AnalyticsAddChartSubviewsPageState extends State<AnalyticsAddChartSubviewsPage>
    with AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  AnalyticsAddChartSubviewsLogic get logic => Get.find<AnalyticsAddChartSubviewsLogic>(tag: tag);

  AnalyticsAddChartSubviewsState get state => Get.find<AnalyticsAddChartSubviewsLogic>(tag: tag).state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AnalyticsAddChartSubviewsLogic>();
    super.dispose();
  }

  @override
  void initState() {
    Get.put(AnalyticsAddChartSubviewsLogic(), tag: tag);

    super.initState();
    if (widget.chartEntity != null) {
      state.chartEntity = MetricsEditInfoMetricsCard.fromJson(widget.chartEntity!.toJson());
    }

    if (widget.cardTemplateData != null) {
      logic.setEditPageData(widget.cardIndex, widget.cardTemplateData, state.chartEntity);
    }

    if (state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_PERIOD) {
      state.items.value = {
        S.current.rs_base_settings: [
          S.current.rs_name,
          S.current.rs_chart_type,
          S.current.rs_metric,
          // S.current.rs_dim,
          S.current.rs_compare_to,
        ],
        S.current.rs_advanced: [
          // S.current.rs_metrics_options,
          // S.current.rs_dims_options,
          S.current.rs_chart_optional,
        ],
      };
    } else if (state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_GROUP) {
      state.items.value = {
        S.current.rs_base_settings: [
          S.current.rs_name,
          S.current.rs_chart_type,
          S.current.rs_metric,
          // S.current.rs_dim,
        ],
        S.current.rs_advanced: [
          // S.current.rs_metrics_options,
          // S.current.rs_dims_options,
          S.current.rs_chart_optional,
        ],
      };
    } else {
      state.sections = [S.current.rs_base_settings];
      state.items.value = {
        S.current.rs_base_settings: [
          S.current.rs_name,
          // S.current.rs_metric,
          S.current.rs_dim,
        ],
        // S.current.rs_advanced: [
        // S.current.rs_metrics_options,
        // S.current.rs_dims_options,
        // S.current.rs_compare_to_prior,
        // ],
      };
    }

    // 动态添加可选指标选项
    if (state.items.containsKey(S.current.rs_advanced)) {
      if (state.selectedBasicMetricIndex.value != -1) {
        if (!state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
          state.items[S.current.rs_advanced]?.add(S.current.rs_metrics_options);
        }
      } else {
        if (state.items.containsKey(S.current.rs_advanced)) {
          if (state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
            state.items[S.current.rs_advanced]?.remove(S.current.rs_metrics_options);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(flex: 1, child: _createTabBarViewBody()),
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Container(
          color: RSColor.color_0xFFFFFFFF,
          padding: EdgeInsets.only(
              top: 16,
              bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight,
              left: 16,
              right: 16),
          alignment: Alignment.center,
          child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_apply, (title) {
            logic.backEditingPage(state.chartEntity);
          }),
        ),
      ],
    );
  }

  Widget _createTabBarViewBody() {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: state.sections.length,
      itemBuilder: (context, sectionIndex) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                state.sections[sectionIndex],
                style: TextStyle(
                  color: RSColor.color_0x40000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Obx(() {
              return Column(
                children: _buildListWidget(sectionIndex),
              );
            }),
          ],
        );
      },
    );
  }

  List<Widget> _buildListWidget(int sectionIndex) {
    List<Widget> widgets = [];
    var tmp = state.items[state.sections[sectionIndex]];
    if (tmp is List<String>) {
      widgets = tmp.map((e) => _createItemWidget(e)).toList();
    }

    return widgets;
  }

  Widget _createItemWidget(String title) {
    String? subtitle;

    if (title == S.current.rs_name) {
      return RSFormCommonTypeWidget.buildInputFormWidget(title, state.nameTextController,
          showErrorLine: state.nameErrorTip.value, maxLength: 40);
    } else if (title == S.current.rs_chart_type) {
      if (state.selectedChartLabelIndex.value != -1) {
        subtitle = state.chartEntity?.chartType?[state.selectedChartLabelIndex.value].name;
      }
      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          showErrorLine: state.chartLabelErrorTip.value, () {
        _buildChartTypeBottomSheet();
      });
    } else if (title == S.current.rs_dim) {
      subtitle = state.recordSelectedBasicDim.value.dimName;

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, showErrorLine: state.basicDimErrorTip.value,
          () {
        if (state.chartEntity != null) {
          // 单选指标&维度
          Get.toNamed(AppRoutes.analyticsAddChartSubViewsMetricPage, arguments: {
            "pageType": SubViewsMetricPageType.single,
            "dimOrMetricType": PageDimOrMetricType.dim,
            "analysisChartEntity": state.chartEntity,
            "defaultList": state.selectedAllDimsFormIndex
          })?.then((result) {
            if (state.chartEntity?.dims != null) {
              for (int index = 0; index < state.chartEntity!.dims!.length; index++) {
                if (state.chartEntity?.dims?[index].metricOptions != null &&
                    state.chartEntity!.dims![index].metricOptions!.isNotEmpty &&
                    !state.selectedAllDimsFormIndex.contains(index)) {
                  state.selectedBasicDimIndex.value = index;
                  state.recordSelectedBasicDim.value = state.chartEntity!.dims![index];
                  break;
                }
              }

              // 动态添加可选指标选项
              // setState(() {
              //   if (state.items.containsKey(S.current.rs_advanced)) {
              //     if (state.selectedBasicDimIndex.value != -1) {
              //       if (!state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
              //         state.items[S.current.rs_advanced]?.add(S.current.rs_metrics_options);
              //       }
              //     } else {
              //       if (state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
              //         state.items[S.current.rs_advanced]?.remove(S.current.rs_metrics_options);
              //       }
              //     }
              //   }
              // });
            }
          });
        } else {
          EasyLoading.showError('Chart Entity Empty');
        }
      });
    } else if (title == S.current.rs_metric) {
      subtitle = state.recordSelectedBasicMetric.value.metricName;

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          showErrorLine: state.basicMetricErrorTip.value, () {
        if (state.chartEntity != null) {
          // 单选指标&维度
          Get.toNamed(AppRoutes.analyticsAddChartSubViewsMetricPage, arguments: {
            "pageType": SubViewsMetricPageType.single,
            "analysisChartEntity": state.chartEntity,
            "defaultList": state.selectedAllMetricsFormIndex
          })?.then((result) {
            if (state.chartEntity?.metrics != null) {
              for (int index = 0; index < state.chartEntity!.metrics!.length; index++) {
                if (state.chartEntity?.metrics?[index].dimOptions != null &&
                    state.chartEntity!.metrics![index].dimOptions!.isNotEmpty &&
                    !state.selectedAllMetricsFormIndex.contains(index)) {
                  state.selectedBasicMetricIndex.value = index;
                  state.recordSelectedBasicMetric.value = state.chartEntity!.metrics![index];
                  break;
                }
              }

              // 动态添加可选指标选项
              setState(() {
                if (state.items.containsKey(S.current.rs_advanced)) {
                  if (state.selectedBasicMetricIndex.value != -1) {
                    if (!state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
                      state.items[S.current.rs_advanced]?.add(S.current.rs_metrics_options);
                    }
                  } else {
                    if (state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
                      state.items[S.current.rs_advanced]?.remove(S.current.rs_metrics_options);
                    }
                  }
                }
              });
            }
          });
        } else {
          EasyLoading.showError('Chart Entity Empty');
        }

        // Get.bottomSheet(
        //   AnalyticsAddMetricsBottomSheetPage(
        //     title: S.current.rs_metric,
        //     tabName: widget.tabName,
        //     custom: widget.custom,
        //     checkType: AnalyticsAddMetricsCheckType.single,
        //     selectIndexList: state.selectedBasicMetricIndex.value == -1 ? [] : [state.selectedBasicMetricIndex.value],
        //     lastSelectedMetrics: [state.recordSelectedComparedToMetric.value] + state.recordSelectedAllMetrics,
        //     selectedSingleCallback: (int selectedMetricIndex) {
        //       state.selectedBasicMetricIndex.value = selectedMetricIndex;
        //       // 动态添加可选指标选项
        //       setState(() {
        //         if (state.selectedBasicMetricIndex.value != -1) {
        //           if (!state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
        //             state.items[S.current.rs_advanced]?.add(S.current.rs_metrics_options);
        //           }
        //         } else {
        //           if (state.items[S.current.rs_advanced]!.contains(S.current.rs_metrics_options)) {
        //             state.items[S.current.rs_advanced]?.remove(S.current.rs_metrics_options);
        //           }
        //         }
        //       });
        //
        //       if (widget.custom != null && widget.custom?.metrics != null && widget.custom!.metrics!.isNotEmpty) {
        //         state.recordSelectedBasicMetric.value = widget.custom!.metrics![selectedMetricIndex];
        //       }
        //     },
        //   ),
        //   isScrollControlled: true,
        //   isDismissible: false,
        // );
      });
    } else if (title == S.current.rs_compare_to) {
      if (state.formComparedToIsCheck.value && state.selectedComparedToFormIndex.value != -1) {
        subtitle = state.chartEntity?.compareType?[state.selectedComparedToFormIndex.value].name;
      }

      return RSFormCommonTypeWidget.buildSecondaryOperationFormWidget(
          title, state.formComparedToIsCheck.value, subtitle,
          showErrorLine: state.comparedToErrorTip.value, (check) {
        state.formComparedToIsCheck.value = check;
        if (!check && state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_PERIOD) {
          state.selectedComparedToFormIndex.value = -1;
          if (state.items[S.current.rs_base_settings]!.contains(S.current.rs_compared_metric)) {
            state.items[S.current.rs_base_settings]?.remove(S.current.rs_compared_metric);
          }
        }
      }, () {
        if (state.chartEntity?.cardType?.code == TopicCardType.DATA_CHART_PERIOD) {
          if (state.selectedComparedToFormIndex.value != -1) {}

          Get.bottomSheet(PickerToolBottomSheetPage(
            listTitle: state.chartEntity?.compareType?.map((e) => e.name ?? "").toList() ?? [],
            selectedItemIndexCallback: (int index) {
              state.selectedComparedToFormIndex.value = index;
              if (state.chartEntity?.compareType?[index].code == AddMetricsCompareType.METRICS) {
                if (!state.items[S.current.rs_base_settings]!.contains(S.current.rs_compared_metric)) {
                  state.items[S.current.rs_base_settings]?.add(S.current.rs_compared_metric);
                }
              } else {
                if (state.items[S.current.rs_base_settings]!.contains(S.current.rs_compared_metric)) {
                  state.items[S.current.rs_base_settings]?.remove(S.current.rs_compared_metric);
                }
              }
            },
            defaultIndex: state.selectedComparedToFormIndex.value,
          ));
        }
      });
    } else if (title == S.current.rs_compared_metric) {
      if (state.selectedComparedToMetricsFormIndex.value != -1) {
        subtitle = state.chartEntity?.metrics?[state.selectedComparedToMetricsFormIndex.value].metricName;
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle,
          showErrorLine: state.comparedToMetricsErrorTip.value, () {
        Get.bottomSheet(
          AnalyticsAddMetricsBottomSheetPage(
            title: S.current.rs_compare_to,
            tabName: widget.tabName,
            custom: state.chartEntity,
            checkType: AnalyticsAddMetricsCheckType.single,
            selectIndexList: state.selectedComparedToMetricsFormIndex.value == -1
                ? []
                : [state.selectedComparedToMetricsFormIndex.value],
            lastSelectedMetrics: [state.recordSelectedBasicMetric.value],
            selectedSingleCallback: (int selectedMetricIndex) {
              state.selectedComparedToMetricsFormIndex.value = selectedMetricIndex;
              if (state.chartEntity != null &&
                  state.chartEntity?.metrics != null &&
                  state.chartEntity!.metrics!.isNotEmpty) {
                state.recordSelectedComparedToMetric.value = state.chartEntity!.metrics![selectedMetricIndex];
              }
            },
          ),
          isScrollControlled: true,
          isDismissible: false,
        );
      });
    } else if (title == S.current.rs_metrics_options) {
      if (state.selectedAllMetricsFormIndex.isNotEmpty) {
        subtitle = "${state.selectedAllMetricsFormIndex.length}";
      }

      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, () {
        if (state.chartEntity != null) {
          // 单选指标&维度
          Get.toNamed(AppRoutes.analyticsAddChartSubViewsMetricPage, arguments: {
            "pageType": SubViewsMetricPageType.multiple,
            "analysisChartEntity": state.chartEntity,
            "defaultList": [state.selectedBasicMetricIndex.value]
          })?.then((result) {
            if (state.chartEntity?.metrics != null) {
              state.selectedAllMetricsFormIndex.clear();

              for (int index = 0; index < state.chartEntity!.metrics!.length; index++) {
                if (state.chartEntity?.metrics?[index].dimOptions != null &&
                    state.chartEntity!.metrics![index].dimOptions!.isNotEmpty &&
                    state.selectedBasicMetricIndex.value != index) {
                  state.selectedAllMetricsFormIndex.add(index);
                }
              }

              state.recordSelectedAllMetrics.value =
                  state.selectedAllMetricsFormIndex.map((index) => state.chartEntity!.metrics![index]).toList();
            }
          });
        } else {
          EasyLoading.showError('Chart Entity Empty');
        }
      });
    } else if (title == S.current.rs_chart_optional) {
      if (state.selectedChartLabelChangeIndex.value != -1) {
        subtitle = state.chartEntity?.advancedInfo?.chartType?[state.selectedChartLabelChangeIndex.value].name;
      }
      return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, () {
        _buildChartTypeBottomSheet(ifAdvanced: true);
      });
    } else {
      return RSFormCommonTypeWidget.buildRadioFormWidget(
          title, state.formComparedToIsCheck.value, (check) => state.formComparedToIsCheck.value = check);
    }

    // else if (title == S.current.rs_dims_options) {
    // if (state.selectedAllDimsFormIndex.isNotEmpty) {
    // subtitle = "${state.selectedAllDimsFormIndex.length}";
    // }
    //
    // return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, () {
    // Get.bottomSheet(
    // AnalyticsAddMetricsBottomSheetPage(
    // title: S.current.rs_dims_options,
    // pageType: AnalyticsAddMetricsOrDimsType.dims,
    // tabName: widget.tabName,
    // custom: widget.custom,
    // checkType: AnalyticsAddMetricsCheckType.multiple,
    // selectIndexList: state.selectedAllDimsFormIndex,
    // lastSelectedDims: [state.recordSelectedBasicDim.value],
    // selectedMultipleIndexCallback: (List<int> selectedDimsIndex) {
    // if (selectedDimsIndex.isEmpty) {
    // state.recordSelectedAllDims.clear();
    // state.selectedAllDimsFormIndex.clear();
    // } else {
    // state.selectedAllDimsFormIndex.value = selectedDimsIndex;
    // if (widget.custom != null && widget.custom?.dims != null && widget.custom!.dims!.isNotEmpty) {
    // var tmp = selectedDimsIndex.map((index) => widget.custom!.dims![index]).toList();
    // state.recordSelectedAllDims.value = tmp;
    // }
    // }
    // },
    // ),
    // isScrollControlled: true,
    // isDismissible: false,
    // );
    // });
    // }
    // else if (title == S.current.rs_dim) {
    //   if (state.selectedBasicDimIndex.value != -1) {
    //     subtitle = widget.custom?.dims?[state.selectedBasicDimIndex.value].dimName;
    //   }
    //
    //   return RSFormCommonTypeWidget.buildGeneralFormWidget(title, subtitle, showErrorLine: state.basicDimErrorTip.value,
    //       () {
    //     Get.bottomSheet(
    //       AnalyticsAddMetricsBottomSheetPage(
    //         title: S.current.rs_dim,
    //         pageType: AnalyticsAddMetricsOrDimsType.dims,
    //         tabName: widget.tabName,
    //         custom: widget.custom,
    //         checkType: AnalyticsAddMetricsCheckType.single,
    //         selectIndexList: state.selectedBasicDimIndex.value == -1 ? [] : [state.selectedBasicDimIndex.value],
    //         lastSelectedDims: state.recordSelectedAllDims,
    //         selectedSingleCallback: (int selectedDimIndex) {
    //           state.selectedBasicDimIndex.value = selectedDimIndex;
    //
    //           if (widget.custom != null && widget.custom?.dims != null && widget.custom!.dims!.isNotEmpty) {
    //             state.recordSelectedBasicDim.value = widget.custom!.dims![selectedDimIndex];
    //           }
    //         },
    //       ),
    //       isScrollControlled: true,
    //       isDismissible: false,
    //     );
    //   });
    // }
  }

  /// Chart type Widget
  void _buildChartTypeBottomSheet({bool ifAdvanced = false}) {
    Get.bottomSheet(
      RSBottomSheetWidget(
        title: S.current.rs_chart_type,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _createChartTypeWidget(ifAdvanced),
                ),
              ),
            ),
          ),
          // RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_confirm, (title) {
          //   Get.back();
          // }),
        ],
      ),
      isScrollControlled: true,
    );
  }

  /// Chart type Widget
  Widget _createChartTypeWidget(bool ifAdvanced) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 160 / 55,
      ),
      itemCount: ifAdvanced
          ? state.chartEntity?.advancedInfo?.chartType?.length ?? 0
          : state.chartEntity?.chartType?.length ?? 0,
      itemBuilder: (context, index) {
        return Obx(() {
          var stateType = ChartLabelStateType.ifDefault;
          if (ifAdvanced) {
            stateType = state.selectedChartLabelIndex.value == index
                ? ChartLabelStateType.ifDefault
                : (state.selectedChartLabelChangeIndex.value == index
                    ? ChartLabelStateType.selected
                    : ChartLabelStateType.none);
          } else {
            stateType = state.selectedChartLabelChangeIndex.value == index
                ? ChartLabelStateType.ifDefault
                : (state.selectedChartLabelIndex.value == index
                    ? ChartLabelStateType.selected
                    : ChartLabelStateType.none);
          }

          AddMetricsChartType? type = AddMetricsChartType.LINE;
          String typeName = '';
          if (ifAdvanced) {
            type = state.chartEntity?.advancedInfo?.chartType?[index].code;
            typeName = state.chartEntity?.advancedInfo?.chartType?[index].name ?? '';
          } else {
            type = state.chartEntity?.chartType?[index].code;
            typeName = state.chartEntity?.chartType?[index].name ?? '';
          }
          return ChartLabelPage(
            type: type ?? AddMetricsChartType.LINE,
            typeName: typeName,
            stateType: stateType,
            selectedCallBack: (ChartLabelStateType type) {
              if (ifAdvanced) {
                if (state.selectedChartLabelChangeIndex.value == index) {
                  state.selectedChartLabelChangeIndex.value = -1;
                } else {
                  state.selectedChartLabelChangeIndex.value = index;
                }
              } else {
                state.selectedChartLabelIndex.value = index;
              }
              Get.back();
            },
          );
        });
      },
    );
  }
}
