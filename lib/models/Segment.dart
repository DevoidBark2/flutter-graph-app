import "Point.dart";

class Segment {
  final double eps = 0.1;
  final Point a, b;

  const Segment({required this.a,required this.b});

  // параллельны ли отрезки
  bool parall(Segment s)
  {
    double v1x = b.x - a.x;
    double v1y = b.y - a.y;
    double v2x = s.b.x - s.a.x;
    double v2y = s.b.y - s.a.y;
    double delta = v1x * v2y - v1y * v2x;

    return (delta).abs() < eps;
  }

  // точка пересечения прямых, содержащих отрезки
  Point cross(Segment s)
  {
    if (parall(s)) throw Exception("parall not intersect");
    // коэффициенты общего уравнения первой прямой
    double a1 = b.y - a.y;
    double b1 = a.x - b.x;
    double c1 = -(b.y - a.y) * a.x - (a.x - b.x) * a.y;
    // коэффициенты общего уравнения 2ой прямой
    double a2 = s.b.y - s.a.y;
    double b2 = s.a.x - s.b.x;
    double c2 = -(s.b.y - s.a.y) * s.a.x - (s.a.x - s.b.x) * s.a.y;
    // debug Console.WriteLine($"{A1}x + {B1}y + {C1} = 0");
    // решаем систему методом Крамера
    double delta = a1 * c2 - a2 * b1;
    double delta1 = b1 * c2 - b2 * c1;
    double delta2 = a2 * c1 - a1 * c2;
    return Point(x:delta1 / delta, y:delta2 / delta);
  }

  bool intersect(Segment s)
  {
    if (parall(s)) return false;
    Point p = cross(s);
    if (p.between(s.a, s.b) && p.between(a, b)) {
      return true;
    }
    return false;
  }
}