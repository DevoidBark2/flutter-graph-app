import 'dart:collection';

class BFSAlgorithm{
  static List<int> bfs(List<List<int?>> adjacencyMatrix, int start) {
    int n = adjacencyMatrix.length;
    List<bool> visited = List.generate(n, (_) => false);
    List<int> visitedOrder = [];
    Queue<int> queue = Queue();
    visited[start] = true;
    queue.add(start);

    // order the queue by vertex numbers
    while (queue.isNotEmpty) {
      bool isSwapped = false;
      for (int i = queue.length - 1; i > 0; i--) {
        int current = queue.elementAt(i);
        int prev = queue.elementAt(i - 1);
        if (current < prev) {
          queue.remove(current);
          queue.addFirst(current);
          isSwapped = true;
        }
      }
      if (!isSwapped) {
        break;
      }
    }

    while (queue.isNotEmpty) {
      int u = queue.removeFirst();
      visitedOrder.add(u + 1); // add a top to the end of the list
      for (int v = 0; v < n; v++) {
        if (adjacencyMatrix[u][v] == 1 && !visited[v]) {
          visited[v] = true;
          queue.add(v);
        }
      }
    }
    return visitedOrder;
  }
}
class BFSResult{
  late List<int> result;
  BFSResult(this.result);
}