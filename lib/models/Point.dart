class Point {
  final double eps = 0.1;
  final double x, y;

  const Point({required this.x, required this.y});

  // лежит ли точка между двумя заданными (над отрезком или над продолжением)
  // через скалярное произведение векторов
  bool between(Point a, Point b) {
    double pab = (b.x - a.x) * (x - a.x) + (b.y - a.y) * (y - a.y);
    double pba = (a.x - b.x) * (x - b.x) + (a.y - b.y) * (y - b.y);
    return (pab > eps) && (pba > eps);
  }
}