import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class AIChatOrgChartCustomTreeEdgeRenderer extends EdgeRenderer {
  final BuchheimWalkerConfiguration configuration;

  final Path _linePath = Path();

  AIChatOrgChartCustomTreeEdgeRenderer(this.configuration);

  @override
  void render(Canvas canvas, Graph graph, Paint defaultPaint) {
    final double levelSeparationHalf = configuration.levelSeparation / 2;

    for (var node in graph.nodes) {
      final children = graph.successorsOf(node);

      for (var child in children) {
        final edge = graph.getEdgeBetween(node, child);
        final edgePaint = (edge?.paint ?? defaultPaint)
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFFCCCAFB) 
          ..strokeWidth = 1.5; 

        _linePath.reset();

        _linePath.moveTo(child.x + child.width / 2, child.y);

        _linePath.lineTo(
            child.x + child.width / 2, child.y - levelSeparationHalf);

        _linePath.lineTo(node.x + node.width / 2, child.y - levelSeparationHalf);

        _linePath.moveTo(node.x + node.width / 2, child.y - levelSeparationHalf);
        _linePath.lineTo(node.x + node.width / 2, node.y + node.height);

        canvas.drawPath(_linePath, edgePaint);
      }
    }
  }
}
