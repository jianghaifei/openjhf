import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/generated/assets.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import 'login_custom_text_field_logic.dart';

class LoginCustomTextFieldPage extends StatelessWidget {
  LoginCustomTextFieldPage({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.onChanged,
    this.suffixWidget,
    this.obscureText = false,
    this.prefixWidget,
    this.focusNode,
  });

  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixWidget;
  final bool obscureText;
  final Widget? prefixWidget;
  final FocusNode? focusNode;

  final logic = Get.put(LoginCustomTextFieldLogic());
  final state = Get.find<LoginCustomTextFieldLogic>().state;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: RSColor.color_0xFF5C57E6,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: RSColor.color_0xFFFFFFFF,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: RSColor.color_0x26000000),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: RSColor.color_0xFF5C57E6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: RSColor.color_0xFFD54941),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: RSColor.color_0xFFD54941),
        ),
        label: AutoSizeText(
          labelText,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: RSColor.color_0x60000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSuffixIcons(),
        ),
        errorText: errorText,
        errorStyle: const TextStyle(color: RSColor.color_0xFFD54941),
        prefixIcon: prefixWidget,
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  List<Widget> _buildSuffixIcons() {
    List<Widget> widgets = [];

    if (controller.value.text.isNotEmpty) {
      widgets.add(InkWell(
        onTap: () {
          controller.clear();
          onChanged?.call("");
        },
        child: Image.asset(
          Assets.imageCloseSmall,
        ),
      ));
    }

    if (suffixWidget != null) {
      widgets.add(const SizedBox(width: 10));
      widgets.add(suffixWidget!);
      widgets.add(const SizedBox(width: 10));
    }

    return widgets;
  }
}
