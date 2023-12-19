class Task {
  final int id;
  final String level;
  final String total;

  Task({
    required this.id,
    required this.level,
    required this.total,
  });
}

List<Task> createTaskList(List<List<dynamic>> data, List<String> columnNames) {
  List<Task> tasks = [];

  for (List<dynamic> row in data) {

    int id = row[0];
    String level = row[1];
    String total = row[2];

    Task task = Task(
      id: id,
      level: level,
      total: total,
    );

    tasks.add(task);
  }

  return tasks;
}