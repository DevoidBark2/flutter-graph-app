import 'dart:convert';

class Task {
  final int id;
  final int level;
  final int total;
  final int time_level;
  final String description;
  final List<List<int>> graph;

  Task({
    required this.id,
    required this.level,
    required this.total,
    required this.time_level,
    required this.description,
    required this.graph,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    List<List<int>>? graph;


    if (map['graph'] != null) {
     graph = jsonDecode(map['graph']).cast<List<dynamic>>().map<List<int>>(
              (row) => (row as List<dynamic>).cast<int>().toList()
      ).toList();
    }
    print(graph);
    return Task(
      id: map['id'] ?? 0,
      level: map['level'] ?? 0,
      total: map['total'] ?? 0,
      time_level: map['time_level'] ?? 0,
      description: map['description'] ?? '',
      graph: graph ?? []
    );
  }
}