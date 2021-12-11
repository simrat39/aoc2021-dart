import 'dart:io';

typedef Grid = List<List<Dumbo>>;

void pretty(Grid map) {
  for (var element in map) {
    print(element);
  }
  print("");
}

extension GetChars on String {
  List<String> getChars() {
    return runes.map((e) => String.fromCharCode(e)).toList();
  }
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var lines = await file.readAsLines();

  Grid grid = [];

  for (var line in lines) {
    List<Dumbo> row = [];
    for (var char in line.getChars()) {
      row.add(Dumbo(int.parse(char), false));
    }
    grid.add(row);
  }

  var g1 = deepCopy(grid);
  var g2 = deepCopy(grid);

  part1(g1);
  part2(g2);
}

Grid deepCopy(Grid map) {
  Grid ret = [];

  for (var row in map) {
    ret.add(row.map((e) => Dumbo(e.value, e.wasLastFlashed)).toList());
  }

  return ret;
}

class Dumbo {
  int value;
  bool wasLastFlashed;

  Dumbo(this.value, this.wasLastFlashed);

  @override
  String toString() {
    return "[$value: ${wasLastFlashed.toString().substring(0, 1)}]";
  }
}

Grid recurse(Grid grid, int x, int y) {
  if (y < 0 || y >= grid.length || x < 0 || x >= grid[0].length) {
    return grid;
  }

  if (grid[y][x].value == 9) {
    grid[y][x].value = 0;
    grid[y][x].wasLastFlashed = true;

    // go right
    recurse(grid, x + 1, y);
    // go left
    recurse(grid, x - 1, y);
    // go down
    recurse(grid, x, y + 1);
    // go up
    recurse(grid, x, y - 1);

    // go top right
    recurse(grid, x + 1, y - 1);
    // go top left
    recurse(grid, x - 1, y - 1);

    // go down right
    recurse(grid, x + 1, y + 1);
    // go down left
    recurse(grid, x - 1, y + 1);
  } else {
    if (!grid[y][x].wasLastFlashed) {
      grid[y][x].value += 1;
    }
  }

  return grid;
}

void part2(Grid grid) {
  var stop = false;
  var step = 0;

  while (!stop) {
    step++;

    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid[0].length; x++) {
        recurse(grid, x, y);
      }
    }

    var zeroCount = 0;

    for (var row in grid) {
      for (var col in row) {
        col.wasLastFlashed = false;
        if (col.value == 0) {
          zeroCount++;
        }
      }
    }

    if (zeroCount == grid.length * grid[0].length) {
      stop = true;
    }
  }

  print(step);
}

void part1(Grid grid) {
  var glowCount = 0;

  for (var _ in List<int>.generate(100, (idx) => idx)) {
    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid[0].length; x++) {
        recurse(grid, x, y);
      }
    }

    for (var row in grid) {
      for (var col in row) {
        col.wasLastFlashed = false;
        if (col.value == 0) {
          glowCount += 1;
        }
      }
    }
  }

  print(glowCount);
}
