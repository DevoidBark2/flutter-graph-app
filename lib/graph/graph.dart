import 'package:flutter/widgets.dart';
import 'package:test_project/graph/node.dart';

class Graph extends StatefulWidget{
  final List<NodeGraph> nodes;
  const Graph(this.nodes, {super.key});
  @override
  State<StatefulWidget> createState() => _StateGraph();
}

class _StateGraph extends State<Graph>{
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return const Text('Graph view');
  }

}