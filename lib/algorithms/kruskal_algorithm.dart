import '../graph/edge.dart';

class KruskalAlgorithm{
  static List<Edge> _getEdgesFromMatrix(List<List<int?>> matrix) {
    List<Edge> edges = [];
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        if (matrix[i][j] != 0) {
          edges.add(Edge(i+1, j+1, matrix[i][j]!));
        }
      }
    }
    return edges;
  }
  static KruskalResult kruskalAlgorithm(bool isCheckedWeight,bool isCheckedOriented,String error,List<List<int?>> matrix){
    if(isCheckedWeight == false){
      error = 'Граф должен быть взвешенный';
      return KruskalResult.empty(error);
    }else if(isCheckedOriented == true){
      error="Граф не должен быть орентированный";
      return KruskalResult.empty(error);
    }
    else{
      List<Edge> edges = _getEdgesFromMatrix(matrix);
      List<Edge> result = [];
      List<int> treeIds = List<int>.generate(matrix.length+1, (int index) => index);
      edges.sort((a, b) => a.w - b.w); // sort edges by weight

      for (Edge edge in edges) {
        if (treeIds[edge.a] != treeIds[edge.b]) {
          result.add(edge);
          int oldId = treeIds[edge.b], newId = treeIds[edge.a];
          for (int i = 1; i <= matrix.length; i++) {
            if (treeIds[i] == oldId) treeIds[i] = newId;
          }
        }
      }
      List<List<int>> newMatrix = List.generate(matrix.length, (i) => List.filled(matrix.length, 0));
      for (Edge edge in result) {
        newMatrix[edge.a - 1][edge.b - 1] = edge.w;
        newMatrix[edge.b - 1][edge.a - 1] = edge.w;
      }
      double totalWeight = 0;
      for (Edge edge in result) {
        totalWeight += edge.w;
      }
      return KruskalResult(totalWeight, newMatrix);
    }
  }
}

class KruskalResult{
  late double totalWeight;
  late List<List<int>> newMatrix;
  late String error = '';
  KruskalResult(this.totalWeight, this.newMatrix);
  KruskalResult.empty(this.error);
}