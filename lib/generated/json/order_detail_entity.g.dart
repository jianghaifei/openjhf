import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/order_detail_entity.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';

OrderDetailEntity $OrderDetailEntityFromJson(Map<String, dynamic> json) {
  final OrderDetailEntity orderDetailEntity = OrderDetailEntity();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    orderDetailEntity.title = title;
  }
  final List<OrderDetailDivs>? divs =
      (json['divs'] as List<dynamic>?)?.map((e) => jsonConvert.convert<OrderDetailDivs>(e) as OrderDetailDivs).toList();
  if (divs != null) {
    orderDetailEntity.divs = divs;
  }
  final int? fetchStatus = jsonConvert.convert<int>(json['fetchStatus']);
  if (fetchStatus != null) {
    orderDetailEntity.fetchStatus = fetchStatus;
  }
  return orderDetailEntity;
}

Map<String, dynamic> $OrderDetailEntityToJson(OrderDetailEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['divs'] = entity.divs?.map((v) => v.toJson()).toList();
  data['fetchStatus'] = entity.fetchStatus;
  return data;
}

extension OrderDetailEntityExtension on OrderDetailEntity {
  OrderDetailEntity copyWith({
    String? title,
    List<OrderDetailDivs>? divs,
    int? fetchStatus,
  }) {
    return OrderDetailEntity()
      ..title = title ?? this.title
      ..divs = divs ?? this.divs
      ..fetchStatus = fetchStatus ?? this.fetchStatus;
  }
}

OrderDetailDivs $OrderDetailDivsFromJson(Map<String, dynamic> json) {
  final OrderDetailDivs orderDetailDivs = OrderDetailDivs();
  final OrderDetailDivsTitle? title = jsonConvert.convert<OrderDetailDivsTitle>(json['title']);
  if (title != null) {
    orderDetailDivs.title = title;
  }
  final int? rowLimit = jsonConvert.convert<int>(json['rowLimit']);
  if (rowLimit != null) {
    orderDetailDivs.rowLimit = rowLimit;
  }
  final List<OrderDetailDivsRows>? rows = (json['rows'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<OrderDetailDivsRows>(e) as OrderDetailDivsRows)
      .toList();
  if (rows != null) {
    orderDetailDivs.rows = rows;
  }
  return orderDetailDivs;
}

Map<String, dynamic> $OrderDetailDivsToJson(OrderDetailDivs entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title?.toJson();
  data['rowLimit'] = entity.rowLimit;
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

extension OrderDetailDivsExtension on OrderDetailDivs {
  OrderDetailDivs copyWith({
    OrderDetailDivsTitle? title,
    int? rowLimit,
    List<OrderDetailDivsRows>? rows,
  }) {
    return OrderDetailDivs()
      ..title = title ?? this.title
      ..rowLimit = rowLimit ?? this.rowLimit
      ..rows = rows ?? this.rows;
  }
}

OrderDetailDivsTitle $OrderDetailDivsTitleFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsTitle orderDetailDivsTitle = OrderDetailDivsTitle();
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    orderDetailDivsTitle.text = text;
  }
  final String? lineColor = jsonConvert.convert<String>(json['lineColor']);
  if (lineColor != null) {
    orderDetailDivsTitle.lineColor = lineColor;
  }
  final OrderDetailDivsRowsColumnsPadding? padding =
      jsonConvert.convert<OrderDetailDivsRowsColumnsPadding>(json['padding']);
  if (padding != null) {
    orderDetailDivsTitle.padding = padding;
  }
  final OrderDetailDivsRowsColumnsFont? font = jsonConvert.convert<OrderDetailDivsRowsColumnsFont>(json['font']);
  if (font != null) {
    orderDetailDivsTitle.font = font;
  }
  return orderDetailDivsTitle;
}

Map<String, dynamic> $OrderDetailDivsTitleToJson(OrderDetailDivsTitle entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['text'] = entity.text;
  data['lineColor'] = entity.lineColor;
  data['padding'] = entity.padding?.toJson();
  data['font'] = entity.font?.toJson();
  return data;
}

extension OrderDetailDivsTitleExtension on OrderDetailDivsTitle {
  OrderDetailDivsTitle copyWith({
    String? text,
    String? lineColor,
    OrderDetailDivsRowsColumnsPadding? padding,
    OrderDetailDivsRowsColumnsFont? font,
  }) {
    return OrderDetailDivsTitle()
      ..text = text ?? this.text
      ..lineColor = lineColor ?? this.lineColor
      ..padding = padding ?? this.padding
      ..font = font ?? this.font;
  }
}

OrderDetailDivsRows $OrderDetailDivsRowsFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRows orderDetailDivsRows = OrderDetailDivsRows();
  final OrderDetailRowType? rowType =
      jsonConvert.convert<OrderDetailRowType>(json['rowType'], enumConvert: (v) => OrderDetailRowType.values.byName(v));
  if (rowType != null) {
    orderDetailDivsRows.rowType = rowType;
  }
  final List<OrderDetailDivsRowsColumns>? columns = (json['columns'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<OrderDetailDivsRowsColumns>(e) as OrderDetailDivsRowsColumns)
      .toList();
  if (columns != null) {
    orderDetailDivsRows.columns = columns;
  }
  final List<OrderDetailDivs>? drillDownRows = (json['drillDownRows'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<OrderDetailDivs>(e) as OrderDetailDivs)
      .toList();
  if (drillDownRows != null) {
    orderDetailDivsRows.drillDownRows = drillDownRows;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    orderDetailDivsRows.title = title;
  }
  final OrderDetailDivsRowsColumnsFont? font = jsonConvert.convert<OrderDetailDivsRowsColumnsFont>(json['font']);
  if (font != null) {
    orderDetailDivsRows.font = font;
  }
  final String? lineColor = jsonConvert.convert<String>(json['lineColor']);
  if (lineColor != null) {
    orderDetailDivsRows.lineColor = lineColor;
  }
  final double? lineHeight = jsonConvert.convert<double>(json['lineHeight']);
  if (lineHeight != null) {
    orderDetailDivsRows.lineHeight = lineHeight;
  }
  final OrderDetailDivsRowsColumnsPadding? padding =
      jsonConvert.convert<OrderDetailDivsRowsColumnsPadding>(json['padding']);
  if (padding != null) {
    orderDetailDivsRows.padding = padding;
  }
  return orderDetailDivsRows;
}

Map<String, dynamic> $OrderDetailDivsRowsToJson(OrderDetailDivsRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rowType'] = entity.rowType?.name;
  data['columns'] = entity.columns?.map((v) => v.toJson()).toList();
  data['drillDownRows'] = entity.drillDownRows?.map((v) => v.toJson()).toList();
  data['title'] = entity.title;
  data['font'] = entity.font?.toJson();
  data['lineColor'] = entity.lineColor;
  data['lineHeight'] = entity.lineHeight;
  data['padding'] = entity.padding?.toJson();
  return data;
}

extension OrderDetailDivsRowsExtension on OrderDetailDivsRows {
  OrderDetailDivsRows copyWith({
    OrderDetailRowType? rowType,
    List<OrderDetailDivsRowsColumns>? columns,
    List<OrderDetailDivs>? drillDownRows,
    String? title,
    OrderDetailDivsRowsColumnsFont? font,
    String? lineColor,
    double? lineHeight,
    OrderDetailDivsRowsColumnsPadding? padding,
  }) {
    return OrderDetailDivsRows()
      ..rowType = rowType ?? this.rowType
      ..columns = columns ?? this.columns
      ..drillDownRows = drillDownRows ?? this.drillDownRows
      ..title = title ?? this.title
      ..font = font ?? this.font
      ..lineColor = lineColor ?? this.lineColor
      ..lineHeight = lineHeight ?? this.lineHeight
      ..padding = padding ?? this.padding;
  }
}

OrderDetailDivsRowsColumns $OrderDetailDivsRowsColumnsFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumns orderDetailDivsRowsColumns = OrderDetailDivsRowsColumns();
  final OrderDetailDivsRowsColumnsContent? content =
      jsonConvert.convert<OrderDetailDivsRowsColumnsContent>(json['content']);
  if (content != null) {
    orderDetailDivsRowsColumns.content = content;
  }
  final OrderDetailDivsRowsColumnsTag? tag = jsonConvert.convert<OrderDetailDivsRowsColumnsTag>(json['tag']);
  if (tag != null) {
    orderDetailDivsRowsColumns.tag = tag;
  }
  final OrderDetailDivsRowsColumnsRelatedInfo? relatedInfo =
      jsonConvert.convert<OrderDetailDivsRowsColumnsRelatedInfo>(json['relatedInfo']);
  if (relatedInfo != null) {
    orderDetailDivsRowsColumns.relatedInfo = relatedInfo;
  }
  return orderDetailDivsRowsColumns;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsToJson(OrderDetailDivsRowsColumns entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['content'] = entity.content?.toJson();
  data['tag'] = entity.tag?.toJson();
  data['relatedInfo'] = entity.relatedInfo?.toJson();
  return data;
}

extension OrderDetailDivsRowsColumnsExtension on OrderDetailDivsRowsColumns {
  OrderDetailDivsRowsColumns copyWith({
    OrderDetailDivsRowsColumnsContent? content,
    OrderDetailDivsRowsColumnsTag? tag,
    OrderDetailDivsRowsColumnsRelatedInfo? relatedInfo,
  }) {
    return OrderDetailDivsRowsColumns()
      ..content = content ?? this.content
      ..tag = tag ?? this.tag
      ..relatedInfo = relatedInfo ?? this.relatedInfo;
  }
}

OrderDetailDivsRowsColumnsContent $OrderDetailDivsRowsColumnsContentFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsContent orderDetailDivsRowsColumnsContent = OrderDetailDivsRowsColumnsContent();
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    orderDetailDivsRowsColumnsContent.text = text;
  }
  final int? flex = jsonConvert.convert<int>(json['flex']);
  if (flex != null) {
    orderDetailDivsRowsColumnsContent.flex = flex;
  }
  final OrderDetailContentTextAlign? textAlign = jsonConvert.convert<OrderDetailContentTextAlign>(json['textAlign'],
      enumConvert: (v) => OrderDetailContentTextAlign.values.byName(v));
  if (textAlign != null) {
    orderDetailDivsRowsColumnsContent.textAlign = textAlign;
  }
  final OrderDetailDivsRowsColumnsFont? font = jsonConvert.convert<OrderDetailDivsRowsColumnsFont>(json['font']);
  if (font != null) {
    orderDetailDivsRowsColumnsContent.font = font;
  }
  final OrderDetailDivsRowsColumnsBackground? background =
      jsonConvert.convert<OrderDetailDivsRowsColumnsBackground>(json['background']);
  if (background != null) {
    orderDetailDivsRowsColumnsContent.background = background;
  }
  return orderDetailDivsRowsColumnsContent;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsContentToJson(OrderDetailDivsRowsColumnsContent entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['text'] = entity.text;
  data['flex'] = entity.flex;
  data['textAlign'] = entity.textAlign?.name;
  data['font'] = entity.font?.toJson();
  data['background'] = entity.background?.toJson();
  return data;
}

extension OrderDetailDivsRowsColumnsContentExtension on OrderDetailDivsRowsColumnsContent {
  OrderDetailDivsRowsColumnsContent copyWith({
    String? text,
    int? flex,
    OrderDetailContentTextAlign? textAlign,
    OrderDetailDivsRowsColumnsFont? font,
    OrderDetailDivsRowsColumnsBackground? background,
  }) {
    return OrderDetailDivsRowsColumnsContent()
      ..text = text ?? this.text
      ..flex = flex ?? this.flex
      ..textAlign = textAlign ?? this.textAlign
      ..font = font ?? this.font
      ..background = background ?? this.background;
  }
}

OrderDetailDivsRowsColumnsTag $OrderDetailDivsRowsColumnsTagFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsTag orderDetailDivsRowsColumnsTag = OrderDetailDivsRowsColumnsTag();
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    orderDetailDivsRowsColumnsTag.text = text;
  }
  final OrderDetailDivsRowsColumnsFont? font = jsonConvert.convert<OrderDetailDivsRowsColumnsFont>(json['font']);
  if (font != null) {
    orderDetailDivsRowsColumnsTag.font = font;
  }
  final OrderDetailDivsRowsColumnsBackground? background =
      jsonConvert.convert<OrderDetailDivsRowsColumnsBackground>(json['background']);
  if (background != null) {
    orderDetailDivsRowsColumnsTag.background = background;
  }
  return orderDetailDivsRowsColumnsTag;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsTagToJson(OrderDetailDivsRowsColumnsTag entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['text'] = entity.text;
  data['font'] = entity.font?.toJson();
  data['background'] = entity.background?.toJson();
  return data;
}

extension OrderDetailDivsRowsColumnsTagExtension on OrderDetailDivsRowsColumnsTag {
  OrderDetailDivsRowsColumnsTag copyWith({
    String? text,
    OrderDetailDivsRowsColumnsFont? font,
    OrderDetailDivsRowsColumnsBackground? background,
  }) {
    return OrderDetailDivsRowsColumnsTag()
      ..text = text ?? this.text
      ..font = font ?? this.font
      ..background = background ?? this.background;
  }
}

OrderDetailDivsRowsColumnsRelatedInfo $OrderDetailDivsRowsColumnsRelatedInfoFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsRelatedInfo orderDetailDivsRowsColumnsRelatedInfo =
      OrderDetailDivsRowsColumnsRelatedInfo();
  final String? fieldCode = jsonConvert.convert<String>(json['fieldCode']);
  if (fieldCode != null) {
    orderDetailDivsRowsColumnsRelatedInfo.fieldCode = fieldCode;
  }
  final String? fieldValue = jsonConvert.convert<String>(json['fieldValue']);
  if (fieldValue != null) {
    orderDetailDivsRowsColumnsRelatedInfo.fieldValue = fieldValue;
  }
  final String? entity = jsonConvert.convert<String>(json['entity']);
  if (entity != null) {
    orderDetailDivsRowsColumnsRelatedInfo.entity = entity;
  }
  return orderDetailDivsRowsColumnsRelatedInfo;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsRelatedInfoToJson(OrderDetailDivsRowsColumnsRelatedInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fieldCode'] = entity.fieldCode;
  data['fieldValue'] = entity.fieldValue;
  data['entity'] = entity.entity;
  return data;
}

extension OrderDetailDivsRowsColumnsRelatedInfoExtension on OrderDetailDivsRowsColumnsRelatedInfo {
  OrderDetailDivsRowsColumnsRelatedInfo copyWith({
    String? fieldCode,
    String? fieldValue,
    String? entity,
  }) {
    return OrderDetailDivsRowsColumnsRelatedInfo()
      ..fieldCode = fieldCode ?? this.fieldCode
      ..fieldValue = fieldValue ?? this.fieldValue
      ..entity = entity ?? this.entity;
  }
}

OrderDetailDivsRowsColumnsFont $OrderDetailDivsRowsColumnsFontFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsFont orderDetailDivsRowsColumnsFont = OrderDetailDivsRowsColumnsFont();
  final double? size = jsonConvert.convert<double>(json['size']);
  if (size != null) {
    orderDetailDivsRowsColumnsFont.size = size;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    orderDetailDivsRowsColumnsFont.color = color;
  }
  final int? weightIndex = jsonConvert.convert<int>(json['weightIndex']);
  if (weightIndex != null) {
    orderDetailDivsRowsColumnsFont.weightIndex = weightIndex;
  }
  return orderDetailDivsRowsColumnsFont;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsFontToJson(OrderDetailDivsRowsColumnsFont entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['size'] = entity.size;
  data['color'] = entity.color;
  data['weightIndex'] = entity.weightIndex;
  return data;
}

extension OrderDetailDivsRowsColumnsFontExtension on OrderDetailDivsRowsColumnsFont {
  OrderDetailDivsRowsColumnsFont copyWith({
    double? size,
    String? color,
    int? weightIndex,
  }) {
    return OrderDetailDivsRowsColumnsFont()
      ..size = size ?? this.size
      ..color = color ?? this.color
      ..weightIndex = weightIndex ?? this.weightIndex;
  }
}

OrderDetailDivsRowsColumnsBackground $OrderDetailDivsRowsColumnsBackgroundFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsBackground orderDetailDivsRowsColumnsBackground =
      OrderDetailDivsRowsColumnsBackground();
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    orderDetailDivsRowsColumnsBackground.color = color;
  }
  return orderDetailDivsRowsColumnsBackground;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsBackgroundToJson(OrderDetailDivsRowsColumnsBackground entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['color'] = entity.color;
  return data;
}

extension OrderDetailDivsRowsColumnsBackgroundExtension on OrderDetailDivsRowsColumnsBackground {
  OrderDetailDivsRowsColumnsBackground copyWith({
    String? color,
  }) {
    return OrderDetailDivsRowsColumnsBackground()..color = color ?? this.color;
  }
}

OrderDetailDivsRowsColumnsPadding $OrderDetailDivsRowsColumnsPaddingFromJson(Map<String, dynamic> json) {
  final OrderDetailDivsRowsColumnsPadding orderDetailDivsRowsColumnsPadding = OrderDetailDivsRowsColumnsPadding();
  final double? top = jsonConvert.convert<double>(json['top']);
  if (top != null) {
    orderDetailDivsRowsColumnsPadding.top = top;
  }
  final double? bottom = jsonConvert.convert<double>(json['bottom']);
  if (bottom != null) {
    orderDetailDivsRowsColumnsPadding.bottom = bottom;
  }
  final double? left = jsonConvert.convert<double>(json['left']);
  if (left != null) {
    orderDetailDivsRowsColumnsPadding.left = left;
  }
  final double? right = jsonConvert.convert<double>(json['right']);
  if (right != null) {
    orderDetailDivsRowsColumnsPadding.right = right;
  }
  return orderDetailDivsRowsColumnsPadding;
}

Map<String, dynamic> $OrderDetailDivsRowsColumnsPaddingToJson(OrderDetailDivsRowsColumnsPadding entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['top'] = entity.top;
  data['bottom'] = entity.bottom;
  data['left'] = entity.left;
  data['right'] = entity.right;
  return data;
}

extension OrderDetailDivsRowsColumnsPaddingExtension on OrderDetailDivsRowsColumnsPadding {
  OrderDetailDivsRowsColumnsPadding copyWith({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return OrderDetailDivsRowsColumnsPadding()
      ..top = top ?? this.top
      ..bottom = bottom ?? this.bottom
      ..left = left ?? this.left
      ..right = right ?? this.right;
  }
}
