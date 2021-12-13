import 'dart:io';

import 'dart:math';

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() {
    return "$x $y";
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(covariant Point other) {
    return x == other.x && y == other.y;
  }
}

class FoldData {
  final String axis;
  final int value;

  FoldData(this.axis, this.value);

  @override
  String toString() {
    return "$axis=$value";
  }
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var lines = await file.readAsLines();

  var it = lines.iterator;
  List<Point> points = [];
  List<FoldData> foldData = [];

  while (it.moveNext()) {
    if (it.current.isEmpty) {
      break;
    } else {
      var splitted = it.current.split(",");
      points.add(Point(int.parse(splitted[0]), int.parse(splitted[1])));
    }
  }

  while (it.moveNext()) {
    var split = it.current.split('=');

    var axis = split[0].substring(split[0].length - 1);
    var coord = int.parse(split[1]);

    foldData.add(FoldData(axis, coord));
  }

  part1(points, foldData);
  part2(points, foldData);
}

void part2(List<Point> points, List<FoldData> fd) {
  Set<Point> temp = Set.from(points);
  var max_x = 0;
  var max_y = 0;

  for (var fold in fd) {
    var coord = fold.value;
    var axis = fold.axis;
    Set<Point> points = {};

    for (var point in temp) {
      var np = Point(point.x, point.y);
      if (point.x > coord && axis == 'x') {
        np.x = coord - (coord - point.x).abs();
      } else if (point.y > coord && axis == 'y') {
        np.y = coord + (coord - point.y);
      }
      points.add(np);
    }

    temp = points;
  }

  for (var p in temp) {
    max_x = max(max_x, p.x);
    max_y = max(max_y, p.y);
  }

  for (var y = 0; y < max_y + 1; y++) {
    for (var x = 0; x < max_x + 1; x++) {
      if (temp.contains(Point(x, y))) {
        stdout.write("#");
      } else {
        stdout.write(" ");
      }
    }
    print("");
  }
}

void part1(List<Point> points, List<FoldData> fd) {
  var coord = fd.first.value;

  Set<Point> newPoints = {};

  for (var point in points) {
    var np = Point(point.x, point.y);
    if (point.x > coord) {
      np.x = coord - (coord - point.x).abs();
    }
    newPoints.add(np);
  }

  print(points.length);
  print(newPoints.length);
}
