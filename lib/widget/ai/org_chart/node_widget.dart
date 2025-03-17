import 'package:flutter/material.dart';
import 'node.dart';
import 'pk_widget.dart';

class AIChatOrgChartNodeWidget extends StatelessWidget {
  final AIChatOrgChartNode node;
  final VoidCallback onExpandChanged;

  const AIChatOrgChartNodeWidget({
    required this.node,
    required this.onExpandChanged,
    super.key,
  });

  bool get _hasChildren => node.children.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          node.padding?.left ?? 10,
          node.padding?.top ?? 10,
          node.padding?.right ?? 10,
          _hasChildren ? 0 : (node.padding?.bottom ?? 0),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE3E2FF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(),
            _buildContentRow(),
            if (_hasChildren) _buildExpandIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildText(node.title),
        _buildText(node.extra),
      ],
    );
  }

  Widget _buildContentRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataColumn(),
        if (node.referenceData != null) _buildPKWidget(),
        if (node.referenceData != null) _buildReferenceDataColumn(),
      ],
    );
  }

  Widget _buildDataColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: node.data?.map(_buildText).toList() ?? [],
    );
  }

  Widget _buildPKWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: const AIChatOrgChatPK(),
    );
  }

  Widget _buildReferenceDataColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: node.referenceData?.map(_buildText).toList() ?? [],
    );
  }

  Widget _buildExpandIcon() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onExpandChanged,
        child: Container(
          width: 50.0,
          height: 16.0,
          color: Colors.transparent,
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0.0, 1.5),
            child: Icon(
              node.isExpanded
                  ? Icons.remove_circle_outline
                  : Icons.add_circle_outline,
              color: const Color(0xFFCCCAFB),
              size: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(dynamic text) {
    if (text == null) return const SizedBox.shrink();

    if (text is AIChatOrgChartNodeText) {
      return _buildTextBase(text);
    } else if (text is AIChatOrgChartNodeTextGroup) {
      return Row(
        children: text.texts.map(_buildTextBase).toList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTextBase(AIChatOrgChartNodeText text) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        text.padding?.left ?? 4,
        text.padding?.top ?? 4,
        text.padding?.right ?? 4,
        text.padding?.bottom ?? 4,
      ),
      margin: EdgeInsets.fromLTRB(
        text.margin?.left ?? 0,
        text.margin?.top ?? 2,
        text.margin?.right ?? 0,
        text.margin?.bottom ?? 2,
      ),
      decoration: BoxDecoration(
        color: text.bgColor,
        border: text.bgColor != null
            ? Border.all(width: 0.0, color: text.bgColor!)
            : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(text.borderRadius?.topLeft ?? 0),
          topRight: Radius.circular(text.borderRadius?.topRight ?? 0),
          bottomLeft: Radius.circular(text.borderRadius?.bottomLeft ?? 0),
          bottomRight: Radius.circular(text.borderRadius?.bottomRight ?? 0),
        ),
      ),
      child: Text(
        text.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: text.color,
          fontSize: text.fontSize,
          fontWeight: text.fontWeight,
          fontStyle: text.fontStyle,
          height: 1.0,
        ),
      ),
    );
  }
}
