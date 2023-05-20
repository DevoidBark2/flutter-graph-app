class ChromaticNumber{
  static int chromaticNumber(List<List<int?>> adjMatrix) {
    int n = adjMatrix.length;
    List<int> colors = List.filled(n, -1);
    List<bool> availableColors;

    List<int> usedColors = []; // список всех использованных цветов

    for (int i = 0; i < n; i++) {
      availableColors = List.filled(n, true);

      for (int j = 0; j < n; j++) {
        if (adjMatrix[i][j] == 1 && colors[j] != -1) {
          availableColors[colors[j]] = false;
        }
      }

      int cr = 0;
      while (!availableColors[cr]) {
        cr++;
      }

      colors[i] = cr;
      usedColors.add(cr); // добавляем использованный цвет в список
    }

    int uniqueColors = Set<int>.from(usedColors).length; // подсчитываем количество уникальных цветов
    return uniqueColors;
  }
}