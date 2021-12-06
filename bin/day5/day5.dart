import 'dart:collection';
import 'dart:io';
import 'dart:math';

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  String toString() {
    return "($x, $y)";
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(covariant Point other) {
    return (x == other.x) && (y == other.y);
  }
}

class Line {
  final Point p1;
  final Point p2;

  Line(this.p1, this.p2);

  bool isStraight() {
    return (p1.x == p2.x) || p1.y == p2.y;
  }

  @override
  String toString() {
    return "[$p1 -> $p2]";
  }
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();

  List<Line> lines = [];

  for (var line in input) {
    var splits = line.split(" ");

    var p1Raw = splits[0].split(",");
    var p1 = Point(int.parse(p1Raw[0]), int.parse(p1Raw[1]));

    var p2Raw = splits[2].split(",");
    var p2 = Point(int.parse(p2Raw[0]), int.parse(p2Raw[1]));

    lines.add(Line(p1, p2));
  }

  part1(lines);
  part2(lines);
}

void part2(List<Line> lines) {
  HashMap<Point, int> overlapCount = HashMap();

  for (var line in lines) {
    var p1 = line.p1;
    var p2 = line.p2;

    var slope = (p2.y - p1.y) / (p2.x - p1.x);

    if (slope == 0 || slope.abs() == double.infinity) {
      var points = pointsBetweenStraightLine(line);
      for (var point in points) {
        overlapCount.update(
          point,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      continue;
    }

    var b = p2.y - (slope * p2.x);

    for (var x = min(p1.x, p2.x); x <= max(p1.x, p2.x); x++) {
      var y = ((slope * x) + b).ceil();

      var p = Point(x, y);
      overlapCount.update(
        p,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
  }

  print(overlapCount.values.toList().where((e) => e > 1).toList().length);
}

List<Point> pointsBetweenStraightLine(Line line) {
  List<Point> ret = [];

  if (line.isStraight()) {
    if (line.p1.x != line.p2.x) {
      for (var i = min(line.p1.x, line.p2.x);
          i <= max(line.p1.x, line.p2.x);
          i++) {
        var p = Point(i, line.p1.y);
        ret.add(p);
      }
    }

    if (line.p1.y != line.p2.y) {
      for (var i = min(line.p1.y, line.p2.y);
          i <= max(line.p1.y, line.p2.y);
          i++) {
        var p = Point(line.p1.x, i);
        if (p == Point(0, 9)) {
          print("bruh??");
          print(i);
        }
        ret.add(p);
      }
    }
  }

  return ret;
}

void part1(List<Line> lines) {
  HashMap<Point, int> overlapCount = HashMap();

  for (var line in lines) {
    var points = pointsBetweenStraightLine(line);
    for (var point in points) {
      overlapCount.update(
        point,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
  }
  print(overlapCount.values.toList().where((e) => e > 1).toList().length);
}
