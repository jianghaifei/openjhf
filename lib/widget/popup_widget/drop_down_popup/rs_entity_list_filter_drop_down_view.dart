import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../function/analytics/analytics_entity_list_page/analytics_entity_list_drawer/amount_limit/amount_limit_view.dart';
import '../../../generated/l10n.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../model/business_topic/business_topic_type_enum.dart';
import '../../../utils/analytics_tools.dart';
import '../../bottom_button_widget/rs_bottom_button_widget.dart';
import '../../rs_custom_grid.dart';

typedef ApplyCallback = Function(List<double?> limitNumbers, String filterTypeString);

class RSEntityListFilterDropDownView extends StatefulWidget {
  const RSEntityListFilterDropDownView({
    super.key,
    this.filters,
    required this.applyCallback,
    this.limitNumbersApplyCallback,
  });

  final VoidCallback applyCallback;
  final ApplyCallback? limitNumbersApplyCallback;

  /// 筛选器信息
  final AnalyticsEntityFilterComponentFilters? filters;

  @override
  State<RSEntityListFilterDropDownView> createState() => _RSEntityListFilterDropDownViewState();
}

class _RSEntityListFilterDropDownViewState extends State<RSEntityListFilterDropDownView> {
  AnalyticsEntityFilterComponentFilters? myFilters;

  late TextEditingController minimumController;
  late TextEditingController maximumController;

  String currentSymbol = '';

  @override
  void initState() {
    super.initState();

    if (widget.filters != null) {
      myFilters = AnalyticsEntityFilterComponentFilters.fromJson(widget.filters!.toJson());
    }

    if (myFilters?.componentType == EntityComponentType.NUM_FILTER) {
      minimumController = TextEditingController();
      maximumController = TextEditingController();

      handleData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        _accordingConditionsCreateWidget(),
        SizedBox(height: 16),
        _createFooterWidget(),
      ],
    );
  }

  Widget _accordingConditionsCreateWidget() {
    if (myFilters?.componentType == EntityComponentType.NUM_FILTER) {
      return AmountLimitPage(
        metricsTitle: myFilters?.displayName ?? '*',
        symbol: currentSymbol,
        minimumController: minimumController,
        maximumController: maximumController,
        symbolChanged: (value) {
          currentSymbol = value;
        },
      );
    } else {
      return Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: AutoSizeText(
                myFilters?.displayName ?? '*',
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _createOptionsWidget(myFilters?.options,
                singleChoice: myFilters?.componentType == EntityComponentType.SELECTION),
          ],
        ),
      );
    }
  }

  Widget _createOptionsWidget(List<AnalyticsEntityFilterComponentFiltersOptions>? options,
      {bool singleChoice = false}) {
    return Flexible(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: RSCustomGridView(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          itemCount: options?.length ?? 0,
          rowCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (singleChoice && options[index].isSelected == false) {
                  // 单选逻辑处理
                  for (var element in options) {
                    element.isSelected = false;
                  }
                }
                setState(() {
                  options[index].isSelected = !options[index].isSelected;
                });
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: ShapeDecoration(
                  color:
                      options![index].isSelected ? RSColor.color_0xFF5C57E6.withOpacity(0.1) : RSColor.color_0xFFF3F3F3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: AutoSizeText(
                  options[index].displayName ?? '*',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: options[index].isSelected ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
                    fontSize: 14,
                    fontWeight: options[index].isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _createFooterWidget() {
    return Column(
      children: [
        const Divider(
          color: RSColor.color_0xFFE7E7E7,
          thickness: 1,
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
                S.current.rs_clean_all,
                RSColor.color_0xFF5C57E6,
                RSColor.color_0xFF5C57E6.withOpacity(0.1),
                () {
                  setState(() {
                    if (myFilters?.componentType == EntityComponentType.NUM_FILTER) {
                      minimumController.clear();
                      maximumController.clear();

                      myFilters = null;
                      widget.filters?.filterType = null;
                      widget.limitNumbersApplyCallback?.call([], currentSymbol);
                    } else {
                      myFilters?.options?.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                    widget.filters?.options = myFilters?.options;
                    widget.applyCallback.call();

                    RSPopup.pop(Get.context!);
                  });
                },
              ),
              SizedBox(
                width: 16,
              ),
              RSBottomButtonWidget.buildAdaptiveConstraintsButtonWidget(
                S.current.rs_apply,
                RSColor.color_0xFFFFFFFF,
                RSColor.color_0xFF5C57E6,
                () {
                  if (myFilters?.componentType == EntityComponentType.NUM_FILTER) {
                    var tmpModel = AnalyticsEntityFilterComponentFiltersOptions();
                    tmpModel.value = returnLimitList().map((e) => e?.toString() ?? '').toList();

                    myFilters?.options = [tmpModel];

                    myFilters?.filterType = AnalyticsTools().returnFilterType(currentSymbol);
                    widget.filters?.filterType = myFilters?.filterType;

                    widget.limitNumbersApplyCallback?.call(returnLimitList(), currentSymbol);
                  }
                  widget.filters?.options = myFilters?.options;
                  widget.applyCallback.call();
                  RSPopup.pop(Get.context!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void handleData() {
    List<double?> limitNum = [];

    myFilters?.options?.first.value?.forEach((element) {
      limitNum.add(double.tryParse(element));
    });

    currentSymbol = AnalyticsTools().returnFilterTypeString(myFilters?.filterType ?? EntityFilterType.RANGE);

    if (limitNum.length == 1) {
      minimumController.text = limitNum.first!.toStringAsFixed(2);
    }
    if (limitNum.length == 2) {
      minimumController.text = limitNum.first!.toStringAsFixed(2);
      maximumController.text = limitNum.last!.toStringAsFixed(2);
    }
  }

  List<double?> returnLimitList() {
    double? minNum, maxNum;
    if (minimumController.text.isNotEmpty) {
      minNum = double.tryParse(minimumController.text) ?? 0;
    }
    if (maximumController.text.isNotEmpty) {
      maxNum = double.tryParse(maximumController.text) ?? 0;
    }

    if (currentSymbol == "~") {
      if (minNum != null || maxNum != null) {
        minNum ??= 0;
        maxNum ??= 0;
        return [min(minNum, maxNum), max(minNum, maxNum)];
      } else {
        return [];
      }
    } else {
      if (minNum == null && maxNum == null) {
        return [];
      }

      return [minNum];
    }
  }
}
