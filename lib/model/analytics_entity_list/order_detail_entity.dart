import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/order_detail_entity.g.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

@JsonSerializable()
class OrderDetailEntity {
  /// 页面标题
  String? title;

  /// 页面块级数据信息
  List<OrderDetailDivs>? divs;

  /// 拉单状态 0拉单中 1拉单有结果
  int? fetchStatus;

  OrderDetailEntity();

  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) => $OrderDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivs {
  /// 行标题
  OrderDetailDivsTitle? title;

  /// 行数限制
  int? rowLimit;

  /// 列数据
  List<OrderDetailDivsRows>? rows;

  OrderDetailDivs();

  factory OrderDetailDivs.fromJson(Map<String, dynamic> json) => $OrderDetailDivsFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsTitle {
  String? text;
  String? lineColor;
  OrderDetailDivsRowsColumnsPadding? padding;
  OrderDetailDivsRowsColumnsFont? font;

  OrderDetailDivsTitle();

  factory OrderDetailDivsTitle.fromJson(Map<String, dynamic> json) => $OrderDetailDivsTitleFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsTitleToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRows {
  /// 数据类型
  @JSONField(isEnum: true)
  OrderDetailRowType? rowType;

  /// 列数据信息
  List<OrderDetailDivsRowsColumns>? columns;

  /// 跳转的下级数据 rowType = SUB_TITLE_WITH_DRILL_DOWN 时有数据
  List<OrderDetailDivs>? drillDownRows;

  /// rowType = SUB_TITLE_WITH_DRILL_DOWN 或者 SUB_TITLE 时的标题文案
  String? title;

  /// 修饰title
  OrderDetailDivsRowsColumnsFont? font;

  /// 线颜色
  String? lineColor;

  /// 线高度
  double lineHeight = 0.0;

  /// 间距信息
  OrderDetailDivsRowsColumnsPadding? padding;

  OrderDetailDivsRows();

  factory OrderDetailDivsRows.fromJson(Map<String, dynamic> json) => $OrderDetailDivsRowsFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumns {
  /// 显示文案
  OrderDetailDivsRowsColumnsContent? content;

  /// tag信息
  OrderDetailDivsRowsColumnsTag? tag;

  /// 1.3.6新增，跳转详情参数
  OrderDetailDivsRowsColumnsRelatedInfo? relatedInfo;

  OrderDetailDivsRowsColumns();

  factory OrderDetailDivsRowsColumns.fromJson(Map<String, dynamic> json) => $OrderDetailDivsRowsColumnsFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsContent {
  /// 展示文字
  String? text;

  /// 行宽度权重
  int? flex;

  /// 数据类型（LEFT,RIGHT,CENTER）
  @JSONField(isEnum: true)
  OrderDetailContentTextAlign? textAlign;

  /// 字体样式
  OrderDetailDivsRowsColumnsFont? font;

  /// 背景样式
  OrderDetailDivsRowsColumnsBackground? background;

  OrderDetailDivsRowsColumnsContent();

  factory OrderDetailDivsRowsColumnsContent.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsContentFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsContentToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsTag {
  /// 展示文字
  String? text;

  /// 字体样式
  OrderDetailDivsRowsColumnsFont? font;

  /// 背景样式
  OrderDetailDivsRowsColumnsBackground? background;

  OrderDetailDivsRowsColumnsTag();

  factory OrderDetailDivsRowsColumnsTag.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsTagFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsTagToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsRelatedInfo {
  /// D_orderId
  String? fieldCode;

  /// D_orderId的值
  String? fieldValue;

  /// 传参的entity
  String? entity;

  OrderDetailDivsRowsColumnsRelatedInfo();

  factory OrderDetailDivsRowsColumnsRelatedInfo.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsRelatedInfoFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsRelatedInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsFont {
  double? size;
  String? color;
  int? weightIndex;

  OrderDetailDivsRowsColumnsFont();

  factory OrderDetailDivsRowsColumnsFont.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsFontFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsFontToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsBackground {
  String? color;

  OrderDetailDivsRowsColumnsBackground();

  factory OrderDetailDivsRowsColumnsBackground.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsBackgroundFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsBackgroundToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailDivsRowsColumnsPadding {
  double? top;
  double? bottom;
  double? left;
  double? right;

  OrderDetailDivsRowsColumnsPadding();

  factory OrderDetailDivsRowsColumnsPadding.fromJson(Map<String, dynamic> json) =>
      $OrderDetailDivsRowsColumnsPaddingFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailDivsRowsColumnsPaddingToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
