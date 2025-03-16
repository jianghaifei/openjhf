import 'package:flutter/cupertino.dart';

import '../../config/rs_color.dart';

class RSCustomDatePickerWidget extends StatefulWidget {
  const RSCustomDatePickerWidget(
      {super.key, required this.titles, required this.onSelectedItemChanged, required this.defaultIndex});

  final List<String> titles;
  final ValueChanged<int> onSelectedItemChanged;
  final int defaultIndex;

  @override
  State<RSCustomDatePickerWidget> createState() => _RSCustomDatePickerWidgetState();
}

class _RSCustomDatePickerWidgetState extends State<RSCustomDatePickerWidget> {
  FixedExtentScrollController? scrollController;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.defaultIndex != -1) {
      selectedIndex = widget.defaultIndex;
      scrollController = FixedExtentScrollController(initialItem: selectedIndex);
    }

    if (selectedIndex >= widget.titles.length) {
      selectedIndex = widget.titles.length - 1;
      scrollController = FixedExtentScrollController(initialItem: selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoPicker.builder(
        scrollController: scrollController,
        itemExtent: 40,
        useMagnifier: true,
        childCount: widget.titles.length,
        selectionOverlay: Container(),
        onSelectedItemChanged: (int position) {
          setState(() {
            selectedIndex = position;
            widget.onSelectedItemChanged.call(position);
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              widget.titles[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selectedIndex == index ? RSColor.color_0x90000000 : RSColor.color_0x60000000,
                fontSize: 18,
                fontWeight: selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }
}
