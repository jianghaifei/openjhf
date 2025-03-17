import 'package:flutter/material.dart';

// 单个枚举值转换函数
T? stringToEnum<T>(dynamic value, List<T> enumValues, {T? defaultValue}) {
  if (value is String) {
    try {
      return enumValues.firstWhere((e) => e.toString().split('.').last == value,
          orElse: () => defaultValue as T);
    } catch (e) {
      return defaultValue;
    }
  }
  return defaultValue;
}

// 列表枚举值转换函数
List<T>? stringToEnumList<T>(List<dynamic>? list, List<T> enumValues,
    {List<T>? defaultValue}) {
  if (list == null || list.isEmpty) return defaultValue;

  final result = list
      .map((e) {
        return stringToEnum<T>(e, enumValues,
            defaultValue:
                defaultValue?.isNotEmpty == true ? defaultValue?.first : null);
      })
      .whereType<T>()
      .toList();

  return result.isNotEmpty ? result : defaultValue;
}

// 字符串列表转换为 DateTime 类型的列表
List<DateTime>? stringToDateTimeList(List<dynamic>? list,
    {List<DateTime>? defaultValue}) {
  if (list == null || list.isEmpty) return defaultValue;

  final result = list
      .map((e) =>
          DateTime.tryParse(e as String) ??
          (defaultValue?.isNotEmpty == true ? defaultValue!.first : null))
      .whereType<DateTime>()
      .toList();

  return result.isNotEmpty ? result : defaultValue;
}

// 字符串列表列表转换为 DateTime 类型的列表
List<List<DateTime>>? stringToDateTimeListList(List<dynamic>? list,
    {List<List<DateTime>>? defaultValue}) {
  if (list == null || list.isEmpty) return defaultValue;

  final result = list
      .map((e) => stringToDateTimeList(e as List<dynamic>))
      .whereType<List<DateTime>>()
      .toList();

  return result.isNotEmpty ? result : defaultValue;
}

FontWeight getFontWeightFromString(String weight) {
  switch (weight.toLowerCase()) {
    case 'bold':
      return FontWeight.bold;
    case 'normal':
      return FontWeight.normal;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

FontStyle getFontStyleFromString(String style) {
  switch (style.toLowerCase()) {
    case 'italic':
      return FontStyle.italic;
    case 'normal':
    default:
      return FontStyle.normal;
  }
}

AlignmentGeometry getTextAlignFromString(String align) {
  switch (align.toLowerCase()) {
    case 'left':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'right':
      return Alignment.centerRight;
    default:
      return Alignment.centerLeft;
  }
}

double toDouble(dynamic value, {double? defaultValue = 0.0}) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else if (value is String) {
    var parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      return parsedValue;
    }
  }
  return defaultValue ?? 0.0;
}

Color? getColorFromString(String? colorString) {
  if (colorString == null) return null;
  return Color(int.parse(colorString, radix: 16));
}
