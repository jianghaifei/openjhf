import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../model/business_topic/business_topic_type_enum.dart';
import 'chart_label_logic.dart';

enum ChartLabelStateType {
  selected,
  ifDefault,
  none,
}

typedef SelectedCallBack = Function(ChartLabelStateType type);

class ChartLabelPage extends StatefulWidget {
  const ChartLabelPage(
      {super.key, required this.type, required this.stateType, required this.selectedCallBack, required this.typeName});

  final AddMetricsChartType type;
  final String typeName;
  final ChartLabelStateType stateType;
  final SelectedCallBack selectedCallBack;

  @override
  State<ChartLabelPage> createState() => _ChartLabelPageState();
}

class _ChartLabelPageState extends State<ChartLabelPage> {
  final logic = Get.put(ChartLabelLogic());
  final state = Get.find<ChartLabelLogic>().state;

  @override
  void dispose() {
    Get.delete<ChartLabelLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.stateType != ChartLabelStateType.ifDefault) {
          var stateType = ChartLabelStateType.none;

          if (widget.stateType == ChartLabelStateType.none) {
            stateType = ChartLabelStateType.selected;
          } else {
            stateType = ChartLabelStateType.none;
          }

          widget.selectedCallBack.call(stateType);
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: logic.returnWidgetBorderColor(widget.stateType)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.typeName,
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  logic.returnChartImageName(widget.type),
                  fit: BoxFit.fill,
                )
              ],
            ),
          ),
          if (widget.stateType != ChartLabelStateType.none)
            SizedBox(
                width: 24,
                child: Image.asset(
                  widget.stateType == ChartLabelStateType.selected
                      ? Assets.imageCornerMarkSelect
                      : Assets.imageCornerMarkSelectGray,
                  fit: BoxFit.fill,
                ))
        ],
      ),
    );
  }
}
