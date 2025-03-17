import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../config/rs_color.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../generated/l10n.dart';
import '../../../../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../../../../model/business_topic/edit/metrics_edit_info_entity.dart';
import '../../../../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../../../../widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import '../../../../../../../widget/chart_label/chart_label_view.dart';
import 'analytics_add_chart_type_logic.dart';
import 'analytics_add_chart_type_state.dart';

typedef ChartTypeCallBack = void Function(
  int selectedChartLabelIndex,
  int selectedChartLabelChangeIndex,
  int selectedChartLabelDisplayCountIndex,
);

class AnalyticsAddChartTypePage extends StatefulWidget {
  const AnalyticsAddChartTypePage({
    super.key,
    this.chartEntity,
    required this.ifAdvanced,
    required this.selectedChartLabelIndex,
    required this.selectedChartLabelChangeIndex,
    required this.selectedChartLabelDisplayCountIndex,
    required this.chartTypeCallBack,
  });

  final MetricsEditInfoMetricsCard? chartEntity;
  final bool ifAdvanced;

  final int selectedChartLabelIndex;
  final int selectedChartLabelChangeIndex;
  final int selectedChartLabelDisplayCountIndex;

  final ChartTypeCallBack chartTypeCallBack;

  @override
  State<AnalyticsAddChartTypePage> createState() => _AnalyticsAddChartTypePageState();
}

class _AnalyticsAddChartTypePageState extends State<AnalyticsAddChartTypePage> {
  final AnalyticsAddChartTypeLogic logic = Get.put(AnalyticsAddChartTypeLogic());
  final AnalyticsAddChartTypeState state = Get.find<AnalyticsAddChartTypeLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsAddChartTypeLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    state.selectedChartLabelIndex.value = widget.selectedChartLabelIndex;
    state.selectedChartLabelChangeIndex.value = widget.selectedChartLabelChangeIndex;
    state.selectedChartLabelDisplayCountIndex.value = widget.selectedChartLabelDisplayCountIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool editable = false;

      if (widget.ifAdvanced) {
        if (state.selectedChartLabelChangeIndex.value != -1) {
          editable = true;
        }
      } else {
        if (state.selectedChartLabelIndex.value != -1) {
          if (widget.chartEntity?.chartType?[state.selectedChartLabelIndex.value].pageSize != null) {
            if (state.selectedChartLabelDisplayCountIndex.value != -1) {
              editable = true;
            }
          } else {
            editable = true;
          }
        }
      }

      return RSBottomSheetWidget(
        title: S.current.rs_chart_type,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                width: 1.sw,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _wrapChartTypeWidget(widget.ifAdvanced),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: RSBottomButtonWidget.buildFixedWidthBottomButton(S.current.rs_confirm, editable: editable, (title) {
              widget.chartTypeCallBack(
                state.selectedChartLabelIndex.value,
                state.selectedChartLabelChangeIndex.value,
                state.selectedChartLabelDisplayCountIndex.value,
              );
              Get.back();
            }),
          ),
        ],
      );
    });
  }

  /// 包装ChartTypeWidget
  Widget _wrapChartTypeWidget(bool ifAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            '图表类型',
            style: TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        _createChartTypeWidget(ifAdvanced),
        if (!ifAdvanced &&
            state.selectedChartLabelIndex.value != -1 &&
            widget.chartEntity?.chartType?[state.selectedChartLabelIndex.value].pageSize != null)
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8),
            child: Text(
              '展示分组数',
              style: TextStyle(
                color: RSColor.color_0x40000000,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        if (!ifAdvanced && state.selectedChartLabelIndex.value != -1)
          GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 4 / 1,
              ),
              itemCount: widget.chartEntity?.chartType?[state.selectedChartLabelIndex.value].pageSize?.length ?? 0,
              itemBuilder: (context, index) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      state.selectedChartLabelDisplayCountIndex.value = index;
                    },
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(state.selectedChartLabelDisplayCountIndex.value == index
                              ? Assets.imageCheckCircleSel
                              : Assets.imageCheckCircle),
                          gaplessPlayback: true,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: AutoSizeText(
                            '${widget.chartEntity?.chartType?[state.selectedChartLabelIndex.value].pageSize?[index].displayValue}',
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: RSColor.color_0x90000000,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              }),
      ],
    );
  }

  /// Chart type Widget
  Widget _createChartTypeWidget(bool ifAdvanced) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 160 / 55,
      ),
      itemCount: ifAdvanced
          ? widget.chartEntity?.advancedInfo?.chartType?.length ?? 0
          : widget.chartEntity?.chartType?.length ?? 0,
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
            type = widget.chartEntity?.advancedInfo?.chartType?[index].code;
            typeName = widget.chartEntity?.advancedInfo?.chartType?[index].name ?? '';
          } else {
            type = widget.chartEntity?.chartType?[index].code;
            typeName = widget.chartEntity?.chartType?[index].name ?? '';
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
            },
          );
        });
      },
    );
  }
}
