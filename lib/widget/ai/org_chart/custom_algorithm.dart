import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class AIChatOrgChartCustomBuchheimWalkerAlgorithm extends BuchheimWalkerAlgorithm {
  AIChatOrgChartCustomBuchheimWalkerAlgorithm(
      BuchheimWalkerConfiguration configuration, EdgeRenderer renderer)
      : super(configuration, renderer);

  @override
  Size run(Graph? graph, double shiftX, double shiftY) {
    nodeData.clear();
    initData(graph);
    var firstNode = getFirstNode(graph!);
    firstWalk(graph, firstNode, 0, 0);
    secondWalk(graph, firstNode, 0.0);
    checkUnconnectedNotes(graph);
    positionNodes(graph);
    shiftCoordinates(graph, 0, 0);
    return calculateGraphSize(graph);
  }
}
