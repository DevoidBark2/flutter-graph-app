class DijkstraAlgorithm{
  static DijkstraResult dijkstraAlgorithm(List<List<int?>> graph, int start) {
    // Create a set of visited vertices
    Set<int> visited = <int>{};
    // Create a list of distances to each vertex
    Map<int?, int?> dist = <int?, int?>{};

    // Initialize distances for all vertices
    for (var i = 0; i < graph.length; i++) {
      dist[i] = null;
    }
    dist[start] = 0; // The distance from the initial vertex to itself is 0

    // Loop through all vertices
    while (visited.length < graph.length) {
      // Looking for a vertex with a minimum distance
      int? current = _findMinimum(dist, visited);
      if (current == -1) {
        break; // All peaks visited
      }

      // Adding the current vertex to the visited set
      visited.add(current!);

      // Update distances to adjacent vertices
      for (var i = 0; i < graph[current].length; i++) {
        if (graph[current][i] == 0) {
          continue; // Edge does not exist
        }
        int newDist = (dist[current] ?? 0) + graph[current][i]!;
        if (dist[i] == null || newDist < dist[i]!) {
          // Update distance to vertex i
          dist[i] = newDist;
        }
      }
    }
    String result = "";
    result = "Начальная вершина: ${start + 1}" "\n";
    for (var i = 0; i < dist.length; i++) {
      if (dist[i] == null) {
        result += "Вершина ${start + 1} не имеет маршрут в вершину ${i + 1}" "\n";
      } else {
        if(start == i){
          continue;
        }
        result += "Вершина ${i + 1}: ${dist[i]}" "\n";
      }
    }
    return DijkstraResult(result);
  }
  static int? _findMinimum(Map<int?, int?> dist, Set<int> visited) {
    int minDist = 1000000;
    int? minVertex = -1;

    for (var vertex in dist.keys) {
      if (visited.contains(vertex)) {
        continue; // Skip already visited vertices
      }

      int? currentDist = dist[vertex];
      if (currentDist != null && currentDist < minDist) {
        minDist = currentDist;
        minVertex = vertex;
      }
    }

    return minVertex;
  }
}

class DijkstraResult{
  late String result;
  DijkstraResult(this.result);
}