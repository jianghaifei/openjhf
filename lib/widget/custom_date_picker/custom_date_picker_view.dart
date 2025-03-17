import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/widget/custom_date_picker/rs_custom_date_picker_widget.dart';
import 'package:get/get.dart';

import '../../utils/date_util.dart';
import 'custom_date_picker_logic.dart';

enum CustomDatePickerViewType {
  weekType,
  dayType,
  monthType,
}

class CustomDatePickerPage extends StatefulWidget {
  const CustomDatePickerPage({
    super.key,
    required this.type,
    this.initialDateTime,
    required this.dateTimeValueChanged,
    this.enableMaxDate = true,
  });

  final CustomDatePickerViewType type;
  final DateTime? initialDateTime;
  final ValueChanged<List<DateTime>> dateTimeValueChanged;

  // 启用最大日期
  final bool enableMaxDate;

  @override
  State<CustomDatePickerPage> createState() => _CustomDatePickerPageState();
}

class _CustomDatePickerPageState extends State<CustomDatePickerPage> {
  final logic = Get.put(CustomDatePickerLogic());
  final state = Get.find<CustomDatePickerLogic>().state;

  @override
  void dispose() {
    Get.delete<CustomDatePickerLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == CustomDatePickerViewType.weekType) {
      int startYear = DateTime.now().year - 50;
      int endYear = DateTime.now().year;

      state.years.value = List.generate(endYear - startYear + 1, (index) => startYear + index);

      var findYearIndex = logic.getIndexForCurrentYear(state.years, widget.initialDateTime);
      state.weeks.value = logic.generateWeeklyDateRanges(state.years[findYearIndex]);

      state.selectedYearIndex.value = findYearIndex;
      state.selectedWeekIndex.value = logic.getIndexForCurrentWeek(state.weeks, widget.initialDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == CustomDatePickerViewType.weekType) {
      return _buildWeekPickerWidget();
    } else if (widget.type == CustomDatePickerViewType.monthType) {
      return _buildMonthPickerWidget();
    } else {
      return Container();
    }
  }

  Widget _buildWeekPickerWidget() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RSCustomDatePickerWidget(
            titles: state.years.map((e) => e.toString()).toList(),
            defaultIndex: state.selectedYearIndex.value,
            onSelectedItemChanged: (int value) {
              state.selectedYearIndex.value = value;

              setState(() {
                state.weeks.value = logic.generateWeeklyDateRanges(state.years[value]);
              });

              var tmp = logic.convertWeekRangeToDateList();

              widget.dateTimeValueChanged.call(tmp);
            },
          ),
          RSCustomDatePickerWidget(
            titles: state.weeks,
            defaultIndex: state.selectedWeekIndex.value,
            onSelectedItemChanged: (int value) {
              state.selectedWeekIndex.value = value;

              var tmp = logic.convertWeekRangeToDateList();

              widget.dateTimeValueChanged.call(tmp);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPickerWidget() {
    var currentDateTime = DateTime.now();

    return Flexible(
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.monthYear,
        initialDateTime: widget.initialDateTime,
        maximumDate: widget.enableMaxDate ? DateTime.now() : null,
        onDateTimeChanged: (DateTime value) {
          DateTime firstDayOfMonth = DateTime(value.year, value.month, 1);
          DateTime lastDayOfMonth = DateTime(value.year, value.month + 1, 0);
          // 如果是本月，取现在的最新时间
          if (lastDayOfMonth.year == currentDateTime.year && lastDayOfMonth.month == currentDateTime.month) {
            lastDayOfMonth = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
          }

          var timeRange = [RSDateUtil.timeToString(firstDayOfMonth), RSDateUtil.timeToString(lastDayOfMonth)];
          widget.dateTimeValueChanged.call([firstDayOfMonth, lastDayOfMonth]);
        },
      ),
    );
  }
}
