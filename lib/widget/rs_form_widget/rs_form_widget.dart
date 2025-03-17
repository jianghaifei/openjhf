import 'package:flutter/material.dart';

import '../../config/rs_color.dart';

enum RSFormType {
  none,
  input,
}

enum RSFormSubtitleType {
  down,
  suffix,
}

class RSFormWidget extends StatefulWidget {
  const RSFormWidget({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    required this.subtitle,
    required this.hint,
    this.subtitleType = RSFormSubtitleType.suffix,
    this.leftFlex = 5,
    this.rightFlex = 3,
    this.clickRightCallback,
    this.formType = RSFormType.none,
    this.showLine = true,
    this.showErrorLine = false,
    this.ifDefault = false,
    this.ifAllAreaClick = false,
  });

  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final String? hint;
  final RSFormSubtitleType? subtitleType;
  final int leftFlex;
  final int rightFlex;
  final VoidCallback? clickRightCallback;
  final RSFormType? formType;
  final bool showLine;
  final bool showErrorLine;
  final bool ifDefault;
  final bool ifAllAreaClick;

  @override
  State<RSFormWidget> createState() => _RSFormWidgetState();
}

class _RSFormWidgetState extends State<RSFormWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildFormWidget(
      widget.leading,
      widget.trailing,
      widget.title,
      widget.subtitle,
      widget.hint,
      widget.subtitleType,
      widget.leftFlex,
      widget.rightFlex,
      widget.clickRightCallback,
      widget.formType,
      widget.showLine,
      widget.showErrorLine,
      widget.ifAllAreaClick,
    );
  }

  Widget _buildFormWidget(
    Widget? leading,
    Widget? trailing,
    String title,
    String? subtitle,
    String? hint,
    RSFormSubtitleType? subtitleType,
    int leftFlex,
    int rightFlex,
    VoidCallback? clickRightCallback,
    RSFormType? formType,
    bool showLine,
    bool showErrorLine,
    bool ifAllAreaClick,
  ) {
    return GestureDetector(
      onTap: () {
        if (ifAllAreaClick) {
          clickRightCallback?.call();
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: RSColor.color_0xFFFFFFFF,
            child: Row(
              children: [
                if (leading != null) leading,
                if (leading != null) const SizedBox(width: 8),
                if (subtitleType == RSFormSubtitleType.down)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: leftFlex,
                        child: Text(
                          title,
                          style: TextStyle(
                            color: RSColor.color_0x90000000.withOpacity(widget.ifDefault ? 0.2 : 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (subtitleType == RSFormSubtitleType.down)
                        _createSubtitleWidget(hint, subtitle, rightFlex, subtitleType, clickRightCallback),
                    ],
                  ),
                if (subtitleType == RSFormSubtitleType.down) const Spacer(),
                if (subtitleType == RSFormSubtitleType.suffix)
                  Expanded(
                    flex: leftFlex,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: RSColor.color_0x90000000.withOpacity(widget.ifDefault ? 0.2 : 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                if (subtitleType == RSFormSubtitleType.suffix)
                  _createSubtitleWidget(hint, subtitle, rightFlex, subtitleType, clickRightCallback),
                if (trailing != null && formType == RSFormType.input) Expanded(flex: rightFlex, child: trailing),
                if (trailing != null && formType != RSFormType.input) trailing,
              ],
            ),
          ),
          if (showLine)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Divider(
                color: showErrorLine ? RSColor.color_0xFFD54941 : RSColor.color_0xFFE7E7E7,
                thickness: 1,
                height: 0,
                indent: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _createSubtitleWidget(String? hint, String? subtitle, int rightFlex, RSFormSubtitleType? subtitleType,
      VoidCallback? clickRightCallback) {
    if (((hint != null && hint.isNotEmpty) || (subtitle != null && subtitle.isNotEmpty)) &&
        subtitleType == RSFormSubtitleType.down) {
      return Flexible(
        flex: rightFlex,
        child: InkWell(
          onTap: () {
            if (!widget.ifDefault) {
              clickRightCallback?.call();
            }
          },
          child: Text(
            subtitle ?? (hint ?? ''),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: subtitle != null
                  ? RSColor.color_0x60000000.withOpacity(widget.ifDefault ? 0.3 : 0.6)
                  : RSColor.color_0x40000000.withOpacity(widget.ifDefault ? 0.2 : 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else if (((hint != null && hint.isNotEmpty) || (subtitle != null && subtitle.isNotEmpty)) &&
        subtitleType == RSFormSubtitleType.suffix) {
      return Expanded(
        flex: rightFlex,
        child: InkWell(
          onTap: () {
            if (!widget.ifDefault) {
              clickRightCallback?.call();
            }
          },
          child: Text(
            subtitle ?? (hint ?? ''),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: subtitle != null
                  ? RSColor.color_0x60000000.withOpacity(widget.ifDefault ? 0.3 : 0.6)
                  : RSColor.color_0x26000000,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return SizedBox();
  }
}
