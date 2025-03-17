// 暂时不用
import 'package:flutter/material.dart';
import 'index.dart';
import 'node.dart';

class FullScreenGraphView extends StatelessWidget {
  final List<AIChatOrgChartNode> nodes;

  const FullScreenGraphView({
    required this.nodes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: AIChatOrgChart(
          initialNodes: nodes,
        ));
  }
}
