import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';

import 'node.dart';
import 'node_widget.dart';
import 'edge_widget.dart';
import 'custom_algorithm.dart';

class AIChatOrgChart extends StatefulWidget {
  final List<AIChatOrgChartNode> initialNodes; // 从外部传递的初始节点列表

  const AIChatOrgChart({required this.initialNodes, super.key});

  @override
  _AIChatOrgChartState createState() => _AIChatOrgChartState();
}

class _AIChatOrgChartState extends State<AIChatOrgChart> {
  late List<AIChatOrgChartNode> nodes;
  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
    ..siblingSeparation = (20)
    ..levelSeparation = (20)
    ..subtreeSeparation = (20)
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  // 初始化状态中的节点
  @override
  void initState() {
    super.initState();
    nodes = List.from(widget.initialNodes);
  }

  // 获取nodes深度
  int _getVisibleNodesDepth(AIChatOrgChartNode node) {
    if (!node.isExpanded || node.children.isEmpty) {
      return 0;
    }
    int depth = 0;
    for (var child in node.children) {
      depth = max(depth, _getVisibleNodesDepth(child) + 1);
    }
    return depth;
  }

  // 计算图表高度
  double _calcChartHeight() {
    const firstLevelHeight = 160.0;
    const otherLevelHeight = 116.0;
    int visibleDepth = _getVisibleNodesDepth(nodes[0]);
    return firstLevelHeight + visibleDepth * otherLevelHeight;
  }

  void toggleNodeExpanded(AIChatOrgChartNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        node.isExpanded = !node.isExpanded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 构建图表
    void buildGraph(AIChatOrgChartNode parentNode) {
      if (parentNode.isExpanded) {
        for (var child in parentNode.children) {
          graph.addNode(Node.Id(child));
          graph.addEdge(Node.Id(parentNode), Node.Id(child));
          buildGraph(child);
        }
      }
    }

    if (nodes.isNotEmpty) {
      graph.edges.clear();
      graph.nodes.clear();
      graph.addNode(Node.Id(nodes.first));
      buildGraph(nodes.first);
    }
    double chartHeight = _calcChartHeight();
    double chartWidth = MediaQuery.of(context).size.width;
    return Container(
        width: chartWidth,
        height: chartHeight,
        child: InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(300),
            minScale: 0.01,
            maxScale: 2,
            child: Container(
              color: Colors.grey.withOpacity(0.05),
              padding: EdgeInsets.all(16),
              child: GraphView(
                graph: graph,
                algorithm: AIChatOrgChartCustomBuchheimWalkerAlgorithm(
                    builder, AIChatOrgChartCustomTreeEdgeRenderer(builder)),
                builder: (Node node) {
                  final orgChartNode = node.key?.value as AIChatOrgChartNode;
                  return AIChatOrgChartNodeWidget(
                    node: orgChartNode,
                    onExpandChanged: () {
                      toggleNodeExpanded(orgChartNode);
                    },
                  );
                },
              ),
            )));
  }
}
