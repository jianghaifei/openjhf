import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/rs_color.dart';
import '../../generated/l10n.dart';

class RSStepsWidget {
  Widget buildThreeStepOperationWidget(int stepsIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (1.sw - 16 * 2) / 3 / 2.5,
            ),
            _createOperationIndexWidget(1, stepsIndex),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 1,
                decoration: ShapeDecoration(
                  color: stepsIndex > 1 ? RSColor.color_0xFF5C57E6 : RSColor.color_0xFFE7E7E7,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
            _createOperationIndexWidget(2, stepsIndex),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 1,
                decoration: ShapeDecoration(
                  color: stepsIndex > 2 ? RSColor.color_0xFF5C57E6 : RSColor.color_0xFFE7E7E7,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
            _createOperationIndexWidget(3, stepsIndex),
            SizedBox(
              width: (1.sw - 16 * 2) / 3 / 2.5,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createOperationBottomTextWidget(1, stepsIndex),
            SizedBox(width: 8),
            _createOperationBottomTextWidget(2, stepsIndex),
            SizedBox(width: 8),
            _createOperationBottomTextWidget(3, stepsIndex),
          ],
        ),
      ],
    );
  }

  Widget _createOperationIndexWidget(int index, int currentIndex) {
    Color backgroundColor = RSColor.color_0xFF5C57E6;
    Color textColor = RSColor.color_0xFFFFFFFF;
    if (index == currentIndex) {
      backgroundColor = RSColor.color_0xFF5C57E6;
      textColor = RSColor.color_0xFFFFFFFF;
    } else if (index < currentIndex) {
      backgroundColor = RSColor.color_0xFF5C57E6.withOpacity(0.2);
      textColor = RSColor.color_0xFF5C57E6;
    } else if (index > currentIndex) {
      backgroundColor = RSColor.color_0xFFE7E7E7;
      textColor = RSColor.color_0x40000000;
    }

    return Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: const OvalBorder(),
        ),
        child: currentIndex > index
            ? Icon(
                Icons.done,
                color: RSColor.color_0xFF5C57E6,
                size: 14,
              )
            : Text(
                "$index",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ));
  }

  Widget _createOperationBottomTextWidget(int index, int currentIndex) {
    String bottomText = S.current.rs_layout_selection;
    Color textColor = RSColor.color_0xFF5C57E6;

    if (index == 1) {
      bottomText = S.current.rs_layout_selection;
    } else if (index == 2) {
      bottomText = S.current.rs_add_metrics;
    } else if (index == 3) {
      bottomText = S.current.rs_sort;
    }

    if (index == currentIndex) {
      textColor = RSColor.color_0xFF5C57E6;
    } else if (index < currentIndex) {
      textColor = RSColor.color_0x90000000;
    } else if (index > currentIndex) {
      textColor = RSColor.color_0x40000000;
    }

    return Expanded(
      flex: 1,
      child: Text(
        bottomText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: index == currentIndex ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildStepsWidget(int stepsIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: RSColor.color_0xFF5C57E6.withOpacity(stepsIndex == 1 ? 1 : 0.2),
            shape: const OvalBorder(),
          ),
          child: stepsIndex == 1
              ? Text(
                  '1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Icon(
                  Icons.done,
                  color: RSColor.color_0xFF5C57E6,
                  size: 14,
                ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 1,
            decoration: ShapeDecoration(
              color: stepsIndex == 1 ? RSColor.color_0xFFE7E7E7 : RSColor.color_0xFF5C57E6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: stepsIndex == 2 ? RSColor.color_0xFF5C57E6 : RSColor.color_0xFFF3F3F3,
            shape: const OvalBorder(),
          ),
          child: Text(
            '2',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: stepsIndex == 2 ? Colors.white : RSColor.color_0x40000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
