class GetDegreesAlgorithm{
  static GetDegreesResult getDegrees(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    List<int> degrees = List.generate(n, (_) => 0);
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (adjacencyMatrix[i][j] != null && adjacencyMatrix[i][j] != 0) {
          degrees[i]++;
        }
      }
    }
    String result = "";
    result += "$degrees\n";
    for(int i = 0;i < degrees.length;i++){
      result += "Степень вершины ${i + 1} равна ${degrees[i]}" "\n";
    }
    return GetDegreesResult(result);
  }
}
class GetDegreesResult{
  late String result;
  GetDegreesResult(this.result);
}