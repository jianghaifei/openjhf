import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/popup_widget/drop_down_popup/rs_popup.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/l10n.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../rs_custom_grid.dart';

typedef ApplyCallback = Function(int selectedIndex);

/// 排序弹窗
class RSEntityListSortDropDownView extends StatefulWidget {
  const RSEntityListSortDropDownView({
    super.key,
    required this.defaultIndex,
    required this.orderByList,
    required this.applyCallback,
  });

  /// 默认选择下标
  final int defaultIndex;

  /// 排序信息
  final List<AnalyticsEntityFilterComponentOrderBy> orderByList;

  /// Callback
  final ApplyCallback applyCallback;

  @override
  State<RSEntityListSortDropDownView> createState() => _RSEntityListSortDropDownViewState();
}

class _RSEntityListSortDropDownViewState extends State<RSEntityListSortDropDownView> {
  var selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(padding: EdgeInsets.all(16), child: _createOptionsWidget()),
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
          child: InkWell(
            onTap: () {
              if (selectedIndex >= 0 && selectedIndex < widget.orderByList.length) {
                widget.applyCallback.call(selectedIndex);
              } else {
                widget.applyCallback.call(-1);
              }

              RSPopup.pop(Get.context!);
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 40,
              decoration: ShapeDecoration(
                color: RSColor.color_0xFF5C57E6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                S.current.rs_apply,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _createOptionsWidget() {
    return RSCustomGridView(
      itemCount: widget.orderByList.length,
      rowCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            if (index == selectedIndex) {
              selectedIndex = -1;
            } else {
              selectedIndex = index;
            }

            setState(() {});
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: ShapeDecoration(
              color: isSelected ? RSColor.color_0xFF5C57E6.withOpacity(0.1) : RSColor.color_0xFFF3F3F3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: AutoSizeText(
              "${widget.orderByList[index].displayName}",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? RSColor.color_0xFF5C57E6 : RSColor.color_0x90000000,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}
