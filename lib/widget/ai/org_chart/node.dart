import 'package:flutter/material.dart';
import '../utils/help.dart';

// AIChartTRBL 用于表示边距、内边距、圆角等四个方向的数值。
class AIChartTRBL {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  AIChartTRBL({
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  factory AIChartTRBL.fromJson(Map<String, dynamic> json) {
    return AIChartTRBL(
      left: json['left']?.toDouble(),
      right: json['right']?.toDouble(),
      top: json['top']?.toDouble(),
      bottom: json['bottom']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'right': right,
      'top': top,
      'bottom': bottom,
    };
  }
}

class AIChartBorderRadius {
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;

  AIChartBorderRadius({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  factory AIChartBorderRadius.fromJson(Map<String, dynamic> json) {
    return AIChartBorderRadius(
      topLeft: json['topLeft']?.toDouble(),
      topRight: json['topRight']?.toDouble(),
      bottomLeft: json['bottomLeft']?.toDouble(),
      bottomRight: json['bottomRight']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topLeft': topLeft,
      'topRight': topRight,
      'bottomLeft': bottomLeft,
      'bottomRight': bottomRight,
    };
  }
}

class AIChatOrgChartNodeText {
  final String text;
  final Color? color;
  final Color? bgColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final AIChartTRBL? padding;
  final AIChartTRBL? margin;
  final AIChartBorderRadius? borderRadius;

  // 构造函数
  AIChatOrgChartNodeText({
    required this.text,
    this.color = Colors.black,
    this.bgColor = Colors.transparent,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  factory AIChatOrgChartNodeText.fromJson(Map<String, dynamic> json) {
    return AIChatOrgChartNodeText(
      text: json['text'].toString(),
      color: getColorFromString(json['color']),
      bgColor: getColorFromString(json['bgColor']),
      fontSize: json['fontSize']?.toDouble(),
      fontWeight: getFontWeightFromString(json['fontWeight'] ?? 'normal'),
      fontStyle: getFontStyleFromString(json['fontStyle'] ?? 'normal'),
      padding: json['padding'] != null
          ? AIChartTRBL.fromJson(json['padding'])
          : null,
      margin:
          json['margin'] != null ? AIChartTRBL.fromJson(json['margin']) : null,
      borderRadius: json['borderRadius'] != null
          ? AIChartBorderRadius.fromJson(json['borderRadius'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'color': color?.toString(),
      'bgColor': bgColor?.toString(),
      'fontSize': fontSize,
      'fontWeight': fontWeight?.toString(),
      'fontStyle': fontStyle?.toString(),
      'padding': padding?.toJson(),
      'margin': margin?.toJson(),
      'borderRadius': borderRadius?.toJson(),
    };
  }
}

// 表示多段文本的类
class AIChatOrgChartNodeTextGroup {
  final List<AIChatOrgChartNodeText> texts;

  AIChatOrgChartNodeTextGroup({required this.texts});

  factory AIChatOrgChartNodeTextGroup.fromJson(List<dynamic> json) {
    return AIChatOrgChartNodeTextGroup(
      texts: json
          .map(
              (e) => AIChatOrgChartNodeText.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<dynamic> toJson() {
    return texts.map((e) => e.toJson()).toList();
  }
}

// AIChatOrgChartNode 用于表示组织图中的每个节点
class AIChatOrgChartNode {
  bool isExpanded;
  final dynamic title;
  final dynamic extra;
  List<dynamic>? data;
  List<dynamic>? referenceData; // 同上
  final List<AIChatOrgChartNode> children;
  final AIChartTRBL? padding;

  AIChatOrgChartNode({
    this.isExpanded = true,
    required this.title,
    this.extra,
    this.data,
    this.referenceData,
    this.children = const [],
    this.padding,
  });

  // 从 JSON 反序列化为 AIChatOrgChartNode 对象
  factory AIChatOrgChartNode.fromJson(Map<String, dynamic> json) {
    return AIChatOrgChartNode(
      isExpanded: json['isExpanded'] ?? true,
      title: json['title'] is List
          ? AIChatOrgChartNodeTextGroup.fromJson(json['title'])
          : AIChatOrgChartNodeText.fromJson(json['title']),
      extra: json['extra'] != null
          ? (json['extra'] is List
              ? AIChatOrgChartNodeTextGroup.fromJson(json['extra'])
              : AIChatOrgChartNodeText.fromJson(json['extra']))
          : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) {
              return e is Map<String, dynamic>
                  ? AIChatOrgChartNodeText.fromJson(e)
                  : AIChatOrgChartNodeTextGroup.fromJson(e);
            }).toList()
          : null,
      referenceData: json['referenceData'] != null
          ? (json['referenceData'] as List).map((e) {
              return e is Map<String, dynamic>
                  ? AIChatOrgChartNodeText.fromJson(e)
                  : AIChatOrgChartNodeTextGroup.fromJson(e);
            }).toList()
          : null,
      padding: json['padding'] != null ? AIChartTRBL.fromJson(json['padding']) : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((e) => AIChatOrgChartNode.fromJson(e))
              .toList()
          : [],
    );
  }

  // 将 AIChatOrgChartNode 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'isExpanded': isExpanded,
      'title': title is AIChatOrgChartNodeText
          ? (title as AIChatOrgChartNodeText).toJson()
          : (title as AIChatOrgChartNodeTextGroup).toJson(),
      'extra': extra != null
          ? (extra is AIChatOrgChartNodeText
              ? (extra as AIChatOrgChartNodeText).toJson()
              : (extra as AIChatOrgChartNodeTextGroup).toJson())
          : null,
      'data': data?.map((e) {
        return e is AIChatOrgChartNodeText
            ? e.toJson()
            : (e as AIChatOrgChartNodeTextGroup).toJson();
      }).toList(),
      'referenceData': referenceData?.map((e) {
        return e is AIChatOrgChartNodeText
            ? e.toJson()
            : (e as AIChatOrgChartNodeTextGroup).toJson();
      }).toList(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}
