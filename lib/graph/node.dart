class NodeGraph{
  late final String id;
  late final int data;

  NodeGraph(this.id,this.data);

  @override
  bool operator ==(Object other) => other is NodeGraph && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id -> $data>';
}