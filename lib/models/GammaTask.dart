import 'dart:convert';

class GammaTask {
  final int id;
  final int answer;
  final List<String> list_answer;
  final String question;
  final int total;
  final List<List<int>> graph;

  GammaTask({
    required this.id,
    required this.answer,
    required this.list_answer,
    required this.question,
    required this.total,
    required this.graph
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'answer': answer,
      'list_answer': list_answer,
      'question': question,
      'total': total,
      'graph': graph
    };
  }

  factory GammaTask.fromMap(Map<String, dynamic> map) {
    print(map);
    List<List<int>>? graph;
    List<String> list_answer = [];

    if (map['graph'] != null) {
      graph = jsonDecode(map['graph']).cast<List<dynamic>>().map<List<int>>(
              (row) => (row as List<dynamic>).cast<int>().toList()
      ).toList();
    }

    if (map['list_answer'] != null) {
      list_answer = List<String>.from(map['list_answer']);
    }

    return GammaTask(
        id: map['id'] ?? 0,
        answer: map['answer'] ?? 0,
        question: map['question'] ?? '',
        total: map['total'] ?? 0,
        graph: graph ?? [],
        list_answer: list_answer
    );
  }
}