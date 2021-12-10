import 'dart:io';

void main(List<String> arguments) async {
  var file = File("input.txt");
  var lines = await file.readAsLines();

  part1(lines);
  part2(lines);
}

var opposites = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>',
};

var closingOpposites = {
  ')': '(',
  ']': '[',
  '}': '{',
  '>': '<',
};

var syntacScoreMap = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137,
};

var completionScoreMap = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4,
};

extension GetChars on String {
  List<String> getChars() {
    return runes.map((e) => String.fromCharCode(e)).toList();
  }
}

// im sure I could optimize this but I can't be bothered right now
void part2(List<String> lines) {
  var allScores = [];

  for (var line in lines) {
    List<String> openChunks = [];
    bool isBroken = false;

    for (var char in line.getChars()) {
      if (opposites.containsKey(char)) {
        openChunks.add(char);
      } else if (closingOpposites.containsKey(char)) {
        if (openChunks.contains(closingOpposites[char])) {
          if (openChunks.last != closingOpposites[char]) {
            isBroken = true;
            break;
          }
          openChunks.removeAt(openChunks.lastIndexOf(closingOpposites[char]!));
        } else {
          isBroken = true;
          break;
        }
      }
    }

    if (!isBroken) {
      var score = openChunks.reversed
          .map((e) => completionScoreMap[opposites[e]]!)
          .fold(
              0, (int previousValue, element) => (previousValue * 5) + element);

      if (score != 0) {
        allScores.add(score);
      }
    }
  }

  allScores.sort();
  print(allScores[allScores.length ~/ 2]);
}

void part1(List<String> lines) {
  var brokes = [];
  for (var line in lines) {
    List<String> openChunks = [];
    String? daBrokenOne;

    for (var char in line.getChars()) {
      if (opposites.containsKey(char)) {
        openChunks.add(char);
      } else if (closingOpposites.containsKey(char)) {
        if (openChunks.contains(closingOpposites[char])) {
          if (openChunks.last != closingOpposites[char]) {
            daBrokenOne = char;
            break;
          }
          openChunks.removeAt(openChunks.lastIndexOf(closingOpposites[char]!));
        } else {
          daBrokenOne = char;
          break;
        }
      }
    }
    if (daBrokenOne != null) {
      brokes.add(daBrokenOne);
    }
  }
  print(brokes
      .map((e) => syntacScoreMap[e]!)
      .reduce((value, element) => value + element));
}
