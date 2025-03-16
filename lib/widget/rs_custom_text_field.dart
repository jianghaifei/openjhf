import 'package:flutter/cupertino.dart';

import '../config/rs_color.dart';

class RSCustomTextField extends StatefulWidget {
  const RSCustomTextField({
    super.key,
    required this.textFieldController,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    // this.onSuffixTap,
  });

  final TextEditingController textFieldController;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  // final VoidCallback? onSuffixTap;

  @override
  State<RSCustomTextField> createState() => _RSCustomTextFieldState();
}

class _RSCustomTextFieldState extends State<RSCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: CupertinoSearchTextField(
        controller: widget.textFieldController,
        // padding: const EdgeInsetsDirectional.fromSTEB(5.5, 12, 5.5, 12),
        prefixInsets: EdgeInsets.only(left: 12, top: 2),
        suffixInsets: EdgeInsets.only(right: 12, top: 2),
        onChanged: (changedString) {
          widget.onChanged?.call(changedString);
        },
        onSubmitted: (valueString) {
          widget.onSubmitted?.call(valueString);
        },
        onSuffixTap: () {
          widget.textFieldController.clear();
          widget.onSubmitted?.call('');
          widget.onChanged?.call('');
          // widget.onSuffixTap?.call();
        },
        style: TextStyle(
          color: RSColor.color_0x90000000,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: BoxDecoration(
          color: RSColor.color_0xFFF3F3F3,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        placeholder: widget.hintText,
        placeholderStyle: TextStyle(
          color: RSColor.color_0x40000000,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
