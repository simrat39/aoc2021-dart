import 'dart:io';

typedef Heatmap = List<List<int>>;

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  @override
  String toString() {
    return "[$x, $y]";
  }
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var lines = await file.readAsLines();

  Heatmap data = [];

  for (var line in lines) {
    data.add(line.runes.map((e) => int.parse(String.fromCharCode(e))).toList());
  }

  part1(data);
  part2(data);
}

Heatmap deepCopy(Heatmap map) {
  Heatmap ret = [];

  for (var row in map) {
    ret.add(row.map((e) => e).toList());
  }

  return ret;
}

void pretty(Heatmap map) {
  for (var element in map) {
    print(element);
  }
  print("");
}

Heatmap getBasin(
    Heatmap map, Heatmap basinMap, Position current, Position last) {
  if (current.y >= map.length ||
      current.y < 0 ||
      current.x < 0 ||
      current.x >= map[0].length) {
    return basinMap;
  }

  if (basinMap[current.y][current.x] == -1) {
    return basinMap;
  }

  if (map[current.y][current.x] == 9) {
    return basinMap;
  }

  if (map[current.y][current.x] < map[last.y][last.x]) {
    return basinMap;
  }

  basinMap[current.y][current.x] = -1;

  // left
  getBasin(map, basinMap, Position(current.x - 1, current.y), current);
  // right
  getBasin(map, basinMap, Position(current.x + 1, current.y), current);
  // top
  getBasin(map, basinMap, Position(current.x, current.y + 1), current);
  // bottom
  getBasin(map, basinMap, Position(current.x, current.y - 1), current);

  return basinMap;
}

void part2(Heatmap data) {
  var results = getLowPoints(data);
  List<int> basinSizes = [];

  for (var lp in results) {
    var basinMap = getBasin(data, deepCopy(data), lp, lp);
    var sum = 0;

    for (var element in basinMap) {
      for (var element in element) {
        if (element == -1) sum += 1;
      }
    }

    basinSizes.add(sum);
  }

  basinSizes.sort();
  print(
      basinSizes.reversed.take(3).reduce((value, element) => value * element));
}

List<Position> getLowPoints(Heatmap data) {
  List<Position> ret = [];

  for (var i = 0; i < data.length; i++) {
    var row = data[i];
    for (var j = 0; j < row.length; j++) {
      var column = row[j];

      bool lessThanRight = false;
      if (j < (row.length - 1)) {
        if (column < row[j + 1]) {
          lessThanRight = true;
        }
      } else {
        lessThanRight = true;
      }

      bool lessThanLeft = false;
      if (j > 0) {
        if (column < row[j - 1]) {
          lessThanLeft = true;
        }
      } else {
        lessThanLeft = true;
      }

      bool lessThanTop = false;
      if (i > 0) {
        if (column < data[i - 1][j]) {
          lessThanTop = true;
        }
      } else {
        lessThanTop = true;
      }

      bool lessThanBottom = false;
      if (i < (data.length - 1)) {
        if (column < data[i + 1][j]) {
          lessThanBottom = true;
        }
      } else {
        lessThanBottom = true;
      }

      if (lessThanBottom && lessThanTop && lessThanLeft && lessThanRight) {
        ret.add(Position(j, i));
      }
    }
  }
  return ret;
}

void part1(Heatmap data) {
  var results = getLowPoints(data);
  var heights = results.map((cords) => data[cords.y][cords.x]).toList();

  print(heights.map((e) => e + 1).reduce((v, e) => v + e));
}
