import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../config/rs_color.dart';
import 'amount_limit_logic.dart';

typedef SymbolChanged = Function(String value);

class AmountLimitPage extends StatefulWidget {
  const AmountLimitPage({
    super.key,
    required this.metricsTitle,
    required this.symbol,
    required this.minimumController,
    required this.maximumController,
    required this.symbolChanged,
  });

  final String metricsTitle;

  final TextEditingController minimumController;
  final TextEditingController maximumController;

  final String symbol;
  final SymbolChanged symbolChanged;

  @override
  State<AmountLimitPage> createState() => _AmountLimitPageState();
}

class _AmountLimitPageState extends State<AmountLimitPage> {
  final logic = Get.put(AmountLimitLogic());
  final state = Get.find<AmountLimitLogic>().state;

  @override
  void dispose() {
    Get.delete<AmountLimitLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.symbol.isNotEmpty) {
      state.currentSymbol.value = widget.symbol;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _createAmountLimitWidget(),
    );
  }

  Widget _createAmountLimitWidget() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.metricsTitle,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Container(
                    width: 72,
                    height: 32,
                    padding: EdgeInsets.only(left: 16, right: 8),
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFFFFFFFF,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      elevation: 2,
                      iconEnabledColor: RSColor.color_0x90000000,
                      value: state.currentSymbol.value,
                      items: logic.createSymbolItems(),
                      onChanged: (String? value) {
                        widget.maximumController.clear();
                        if (value != null) {
                          state.currentSymbol.value = value;
                          widget.symbolChanged.call(value);
                        }
                      },
                    )),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: RSColor.color_0xFFFFFFFF,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _createAmountLimitTextField(widget.minimumController),
                  ),
                ),
                Visibility(
                  visible: state.currentSymbol.value == "~",
                  child: Text(
                    ' ~ ',
                    style: TextStyle(
                      color: RSColor.color_0x90000000,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Visibility(
                  visible: state.currentSymbol.value == "~",
                  child: Flexible(
                    child: Container(
                      height: 32,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: RSColor.color_0xFFFFFFFF,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: _createAmountLimitTextField(widget.maximumController),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _createAmountLimitTextField(TextEditingController controller, {String? hint}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textAlign: TextAlign.center,
      style: TextStyle(
        color: RSColor.color_0x90000000,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: RSColor.color_0xFF5C57E6,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        isCollapsed: false,
        isDense: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          color: RSColor.color_0x40000000,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
