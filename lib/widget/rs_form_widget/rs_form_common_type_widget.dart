import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_widget.dart';

import '../../config/rs_color.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';

class RSFormCommonTypeWidget {
  /// 普通类型
  static Widget buildGeneralFormWidget(
    String title,
    String? subtitle,
    VoidCallback? clickRightCallback, {
    bool showArrow = true,
    bool showErrorLine = false,
    String? hint,
  }) {
    return RSFormWidget(
      title: title,
      subtitle: subtitle,
      hint: hint,
      ifAllAreaClick: true,
      showErrorLine: showErrorLine,
      trailing: showArrow
          ? Icon(
              Icons.keyboard_arrow_right,
              color: RSColor.color_0x40000000,
              size: 24,
            )
          : null,
      clickRightCallback: clickRightCallback,
    );
  }

  /// 输入框类型
  static Widget buildInputFormWidget(String title, TextEditingController controller,
      {double height = 56, bool showErrorLine = false, int? maxLength}) {
    return SizedBox(
      height: height,
      child: RSFormWidget(
        formType: RSFormType.input,
        title: title,
        subtitle: null,
        hint: null,
        leftFlex: 2,
        rightFlex: 5,
        showErrorLine: showErrorLine,
        trailing: TextField(
          controller: controller,
          textAlign: TextAlign.left,
          maxLength: maxLength,
          cursorColor: RSColor.color_0xFF5C57E6,
          decoration: InputDecoration(
              counterText: '',
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: S.current.rs_input,
              hintStyle: TextStyle(
                color: RSColor.color_0x40000000,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              )),
        ),
      ),
    );
  }

  /// 输入框货币类型
  static Widget buildInputCurrencyFormWidget(
    String title,
    TextEditingController controller,
    String? currencySymbol, {
    double height = 56,
    bool showErrorLine = false,
    int maxLength = 15,
    bool? enabled,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      height: height,
      child: RSFormWidget(
        formType: RSFormType.input,
        title: title,
        subtitle: null,
        hint: null,
        leftFlex: 2,
        rightFlex: 5,
        showErrorLine: showErrorLine,
        trailing: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                readOnly: readOnly,
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyTextInputFormatter(controller: controller),
                ],
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                maxLength: maxLength,
                cursorColor: RSColor.color_0xFF5C57E6,
                decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: S.current.rs_input,
                    hintStyle: TextStyle(
                      color: RSColor.color_0x40000000,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                onChanged: (value) {
                  // 清除非数字字符（去掉分隔符）
                  String cleanedValue = value.replaceAll(',', '');

                  onChanged?.call(cleanedValue);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                currencySymbol ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RSColor.color_0x40000000,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 单选对钩视图
  static Widget buildCheckFormWidget(
    String title,
    bool isCheck,
    Function(bool check) clickCheckCallback,
  ) {
    return RSFormWidget(
      title: title,
      subtitle: null,
      hint: null,
      ifAllAreaClick: true,
      trailing: isCheck
          ? Icon(
              Icons.check,
              color: RSColor.color_0xFF5C57E6,
              size: 24,
            )
          : null,
      clickRightCallback: () {
        clickCheckCallback.call(!isCheck);
      },
    );
  }

  /// 单选操作类型
  static Widget buildRadioFormWidget(String title, bool isCheck, Function(bool check) clickCheckCallback,
      {bool ifDefault = false, bool ifMultipleSelect = false, bool showErrorLine = false}) {
    return RSFormWidget(
      title: title,
      subtitle: null,
      hint: null,
      ifDefault: ifDefault,
      ifAllAreaClick: true,
      showErrorLine: showErrorLine,
      clickRightCallback: () {
        if (!ifDefault) {
          clickCheckCallback.call(!isCheck);
        }
      },
      trailing: ifDefault
          ? Image(
              image: AssetImage(ifMultipleSelect ? Assets.imageCheckBoxSel : Assets.imageCheckCircleSel),
              gaplessPlayback: true,
              color: RSColor.color_0xFF5C57E6.withOpacity(ifDefault ? 0.4 : 1),
            )
          : isCheck
              ? Image(
                  image: AssetImage(ifMultipleSelect ? Assets.imageCheckBoxSel : Assets.imageCheckCircleSel),
                  gaplessPlayback: true,
                  color: RSColor.color_0xFF5C57E6,
                )
              : Image(
                  image: AssetImage(ifMultipleSelect ? Assets.imageCheckBox : Assets.imageCheckCircle),
                  gaplessPlayback: true,
                  color: RSColor.color_0x26000000,
                ),
    );
  }

  static Widget buildMultipleCheckAndSubtitle(
    String title,
    String? subtitle,
    bool isCheck,
    Function(bool check) clickCheckCallback, {
    bool ifDefault = false,
    RSFormSubtitleType subtitleType = RSFormSubtitleType.down,
    bool ifMultipleSelect = true,
    bool ifEdit = true,
    String? hint,
  }) {
    return RSFormWidget(
      title: title,
      subtitle: subtitle,
      hint: hint,
      subtitleType: subtitleType,
      ifDefault: !ifEdit ? true : ifDefault,
      ifAllAreaClick: true,
      clickRightCallback: () {
        if (ifEdit) {
          if (!ifDefault) {
            clickCheckCallback.call(!isCheck);
          }
        }
      },
      trailing: !ifEdit
          ? isCheck
              ? Image(
                  image: AssetImage(ifMultipleSelect ? Assets.imageCheckBoxSel : Assets.imageCheckCircleSel),
                  gaplessPlayback: true,
                  color: RSColor.color_0xFF5C57E6.withOpacity(!ifEdit ? 0.4 : 1),
                )
              : Image(
                  image: AssetImage(ifMultipleSelect ? Assets.imageCheckBox : Assets.imageCheckCircle),
                  gaplessPlayback: true,
                  color: !ifEdit ? RSColor.color_0xFFE7E7E7 : RSColor.color_0x26000000,
                )
          : ifDefault
              ? Image(
                  image: AssetImage(ifMultipleSelect ? Assets.imageCheckBoxSel : Assets.imageCheckCircleSel),
                  gaplessPlayback: true,
                  color: RSColor.color_0xFF5C57E6.withOpacity(ifDefault ? 0.4 : 1),
                )
              : isCheck
                  ? Image(
                      image: AssetImage(ifMultipleSelect ? Assets.imageCheckBoxSel : Assets.imageCheckCircleSel),
                      gaplessPlayback: true,
                      color: RSColor.color_0xFF5C57E6,
                    )
                  : Image(
                      image: AssetImage(ifMultipleSelect ? Assets.imageCheckBox : Assets.imageCheckCircle),
                      gaplessPlayback: true,
                      color: RSColor.color_0x26000000,
                    ),
    );
  }

  /// 尾部是”设为默认“选项
  static Widget buildMultipleChoiceAndSetDefault(String title, bool isCheck, bool isShowSetDefault,
      Function(bool check) clickCheckCallback, VoidCallback? clickRightCallback,
      {bool ifDefault = false, bool ifSetDefault = false, bool showErrorLine = false}) {
    return RSFormWidget(
      title: title,
      subtitle: null,
      hint: null,
      ifDefault: ifDefault,
      showErrorLine: showErrorLine,
      ifAllAreaClick: false,
      leading: GestureDetector(
        onTap: () {
          if (!ifDefault) {
            clickCheckCallback.call(!isCheck);
          }
        },
        child: Image(
          image: AssetImage(isCheck ? Assets.imageCheckBoxSel : Assets.imageCheckBox),
          gaplessPlayback: true,
        ),
      ),
      trailing: isShowSetDefault
          ? InkWell(
              onTap: () => clickRightCallback?.call(),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(ifSetDefault ? Assets.imageCheckCircleSel : Assets.imageCheckCircle),
                    gaplessPlayback: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      '设为默认',
                      style: TextStyle(
                        color: RSColor.color_0x90000000,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            )
          : null,
      // clickRightCallback: () {
      //   if (isCheck && !ifDefault) {
      //     clickRightCallback?.call();
      //   }
      // },
    );
  }

  /// 二次操作类型
  static Widget buildSecondaryOperationFormWidget(
    String title,
    bool isCheck,
    String? subtitle,
    Function(bool check) clickCheckCallback,
    VoidCallback? clickRightCallback, {
    bool ifDefault = false,
    bool showErrorLine = false,
    bool ifMultipleStyle = false,
    String? hint,
  }) {
    return RSFormWidget(
      title: title,
      subtitle: subtitle,
      hint: hint,
      ifDefault: ifDefault,
      showErrorLine: showErrorLine,
      ifAllAreaClick: true,
      leading: GestureDetector(
        onTap: () {
          if (!ifDefault) {
            clickCheckCallback.call(!isCheck);
          }
        },
        child: Image(
          image: ifMultipleStyle
              ? (AssetImage(isCheck ? Assets.imageCheckBoxSel : Assets.imageCheckBox))
              : AssetImage(isCheck ? Assets.imageCheckCircleSel : Assets.imageCheckCircle),
          gaplessPlayback: true,
          color: isCheck ? RSColor.color_0xFF5C57E6.withOpacity(ifDefault ? 0.4 : 1) : RSColor.color_0x26000000,
        ),
      ),
      trailing: isCheck
          ? Icon(
              Icons.keyboard_arrow_right,
              color: RSColor.color_0x40000000.withOpacity(ifDefault ? 0.2 : 0.4),
            )
          : null,
      clickRightCallback: () {
        if (isCheck && !ifDefault) {
          clickRightCallback?.call();
        }
      },
    );
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  final TextEditingController controller;

  CurrencyTextInputFormatter({required this.controller});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 处理新的输入
    String newText = newValue.text;

    // 确保首位不能为0
    if (newText.startsWith('0') && newText.length > 1) {
      newText = newText.substring(1);
    }

    // 格式化为货币样式
    String formattedText = _formatCurrency(newText);

    // 返回更新后的值
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCurrency(String input) {
    // 去掉非数字字符
    String numericString = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.isEmpty) {
      return '';
    }

    // 手动添加千位分隔符
    StringBuffer buffer = StringBuffer();
    int length = numericString.length;
    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(','); // 添加分隔符
      }
      buffer.write(numericString[i]);
    }

    return buffer.toString();
  }
}
