import 'dart:io';

class BoardEntry {
  final int value;
  bool marked = false;

  BoardEntry(this.value);

  @override
  String toString() {
    var ret = value.toString();

    return ret;
  }

  void setMarked() {
    marked = true;
  }
}

class Board {
  final List<List<BoardEntry>> entries;
  bool hasBingod = false;

  Board(this.entries);

  @override
  String toString() {
    return entries.toString();
  }

  void mark(int num) {
    for (var row in entries) {
      for (var entry in row) {
        if (entry.value == num) {
          entry.setMarked();
        }
      }
    }
  }

  int getUnmarkedSum() {
    int ret = 0;
    for (var row in entries) {
      for (var entry in row) {
        if (!entry.marked) {
          ret += entry.value;
        }
      }
    }
    return ret;
  }

  bool check() {
    bool bingo = false;

    for (var row in entries) {
      // check if each row has a full line of marked entries
      var markedEntries = 0;
      for (var entry in row) {
        if (entry.marked) {
          markedEntries++;
        } else {
          break;
        }
      }
      if (markedEntries == row.length) {
        bingo = true;
        break;
      }
    }

    // check columns
    if (!bingo) {
      for (var i = 0; i < entries[0].length; i++) {
        var markedEntries = 0;
        for (var row in entries) {
          var entry = row[i];
          if (entry.marked) {
            markedEntries++;
          } else {
            break;
          }
        }
        if (markedEntries == entries.length) {
          bingo = true;
          break;
        }
      }
    }
    return bingo;
  }
}

void part1(List<int> nums, List<Board> boards) {
  bool bingo = false;
  int? bingodAt;
  Board? bingoBoard;

  for (var number in nums) {
    if (bingo) break;

    for (var board in boards) {
      board.mark(number);
      bool innerBingo = board.check();
      if (innerBingo) {
        bingo = true;
        bingodAt = number;
        bingoBoard = board;
        break;
      }
    }
  }

  int sol = bingoBoard!.getUnmarkedSum() * bingodAt!;
  print("D4 P1: " + sol.toString());
}

void part2(List<int> nums, List<Board> boards) {
  int? bingodAt;
  Board? bingoBoard;

  for (var number in nums) {
    for (var board in boards) {
      if (board.hasBingod) continue;

      board.mark(number);
      bool bingo = board.check();
      if (bingo) {
        bingodAt = number;
        bingoBoard = board;
        board.hasBingod = true;
      }
    }
  }

  int sol = bingoBoard!.getUnmarkedSum() * bingodAt!;
  print("D4 P1: " + sol.toString());
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();

  var iter = input.iterator;
  iter.moveNext();

  var nums = iter.current.split(",").map((e) => int.parse(e)).toList();

  iter.moveNext();

  List<Board> boards = [];

  List<List<BoardEntry>> current = [];

  while (iter.moveNext()) {
    var line = iter.current;

    if (line.isEmpty) {
      boards.add(Board(current));
      current = [];
    } else {
      List<BoardEntry> row = [];
      for (var i = 0; i < line.length; i += 3) {
        row.add(BoardEntry(int.parse(line[i] + line[i + 1])));
      }
      current.add(row);
    }
  }

  part1(nums, boards);
  part2(nums, boards);
}
