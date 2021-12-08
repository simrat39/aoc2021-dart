/*     0:      1:      2:      3:      4: */
/*    aaaa    ....    aaaa    aaaa    .... */
/*   b    c  .    c  .    c  .    c  b    c */
/*   b    c  .    c  .    c  .    c  b    c */
/*    ....    ....    dddd    dddd    dddd */
/*   e    f  .    f  e    .  .    f  .    f */
/*   e    f  .    f  e    .  .    f  .    f */
/*    gggg    ....    gggg    gggg    .... */

/*     5:      6:      7:      8:      9: */
/*    aaaa    aaaa    aaaa    aaaa    aaaa */
/*   b    .  b    .  .    c  b    c  b    c */
/*   b    .  b    .  .    c  b    c  b    c */
/*    dddd    dddd    ....    dddd    dddd */
/*   .    f  e    f  .    f  e    f  .    f */
/*   .    f  e    f  .    f  e    f  .    f */
/*    gggg    gggg    ....    gggg    gggg */

import 'dart:collection';
import 'dart:io';

void main(List<String> arguments) async {
  var file = File("input.txt");

  List<List<String>> allPatterns = [];
  List<List<String>> allNums = [];

  for (var line in await file.readAsLines()) {
    var splitted = line.split("|");

    var patterns = splitted[0].split(" ");
    patterns.removeLast();

    var jumbledNums = splitted[1].split(" ");
    jumbledNums.removeAt(0);

    allPatterns.add(patterns);
    allNums.add(jumbledNums);
  }

  /* part1(allPatterns, allNums); */
  part2(allPatterns, allNums);
}

typedef ScreenDigit = int;
typedef Count = int;

void part2(List<List<String>> patternsAll, List<List<String>> numsAll) {
  List<int> decodedNumbers = [];

  for (var i = 0; i < patternsAll.length; i++) {
    Map<int, List<List<String>>> possibleRealValues = {
      0: [],
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
      7: [],
      8: [],
      9: [],
    };
    Map<String, String> deduction = {};

    var curPatterns = patternsAll[i];
    var curNumms = numsAll[i];

    // coz 8 uses all the digits
    for (var p in curPatterns) {
      switch (p.length) {
        case 2:
          possibleRealValues[1]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
        case 3:
          possibleRealValues[7]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
        case 4:
          possibleRealValues[4]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
        case 5:
          possibleRealValues[2]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          possibleRealValues[3]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          possibleRealValues[5]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
        case 6:
          possibleRealValues[0]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          possibleRealValues[6]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          possibleRealValues[9]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
        case 7:
          possibleRealValues[8]!
              .add(p.runes.map((e) => String.fromCharCode(e)).toList());
          break;
      }
    }

    deduction['a'] = possibleRealValues[7]![0]
        .where((c) => !possibleRealValues[1]![0].contains(c))
        .toList()[0];

    var eOrG = possibleRealValues[8]![0]
        .where((c) => !possibleRealValues[7]![0].contains(c))
        .where((c) => !possibleRealValues[4]![0].contains(c))
        .toList();

    String twoExample = "";

    for (var num in curPatterns.where((element) => element.length == 5)) {
      if (num.contains(eOrG[0]) && num.contains(eOrG[1])) {
        twoExample = num;
        break;
      }
    }

    var dOrC = twoExample.runes
        .map((e) => String.fromCharCode(e))
        .toList()
        .where((element) => element != deduction['a'])
        .where((element) => !eOrG.contains(element))
        .toList();

    deduction['f'] = possibleRealValues[1]![0]
        .where((element) => !dOrC.contains(element))
        .toList()
        .first;

    deduction['c'] = possibleRealValues[1]![0]
        .where((element) => element != deduction['f'])
        .toList()
        .first;

    var bOrd = possibleRealValues[8]![0]
        .where((element) => !deduction.values.contains(element))
        .where((element) => !eOrG.contains(element))
        .toList();

    deduction['b'] =
        bOrd.where((element) => !dOrC.contains(element)).toList().first;

    deduction['d'] =
        bOrd.where((element) => element != deduction['b']).toList().first;

    String nineExample = "";
    for (var num in curPatterns.where((element) => element.length == 6)) {
      if (num.contains(eOrG[0]) ^ num.contains(eOrG[1])) {
        nineExample = num;
        break;
      }
    }

    deduction['g'] = nineExample.runes
        .map((c) => String.fromCharCode(c))
        .toList()
        .where((element) => !deduction.containsValue(element))
        .toList()
        .first;

    deduction['e'] =
        eOrG.where((element) => element != deduction['g']).toList().first;

    List<String> easyify(List<String> letters) {
      return letters.map((e) => deduction[e]!).toList();
    }

    var decodedMap = {
      0: easyify(['a', 'b', 'c', 'e', 'f', 'g']),
      1: easyify(['c', 'f']),
      2: easyify(['a', 'c', 'd', 'e', 'g']),
      3: easyify(['a', 'c', 'd', 'f', 'g']),
      4: easyify(['b', 'c', 'd', 'f']),
      5: easyify(['a', 'b', 'd', 'f', 'g']),
      6: easyify(['a', 'b', 'd', 'e', 'f', 'g']),
      7: easyify(['a', 'c', 'f']),
      8: easyify(['a', 'b', 'c', 'd', 'e', 'f', 'g']),
      9: easyify(['a', 'b', 'd', 'c', 'f', 'g']),
    };

    var collectedNum = "";
    for (var num in curNumms) {
      for (var i = 0; i < decodedMap.length; i++) {
        var key = decodedMap.keys.elementAt(i);
        var value = decodedMap.values.elementAt(i);

        var leftOvers = num.runes
            .map((e) => String.fromCharCode(e))
            .where((element) => !value.contains(element));

        if (leftOvers.isEmpty && value.length == num.length) {
          collectedNum += key.toString();
          break;
        }
      }
    }
    decodedNumbers.add(int.parse(collectedNum));
  }
  print(decodedNumbers);
  print(decodedNumbers.reduce((value, element) => value + element));
}

// 1, 4, 7, 8
// 1 uses [c. f]
// 4 uses [b. c, d, f]
// 7 uses [a. c, f]
// 8 uses [a. b, c, d, f, e, g]
void part1(List<List<String>> patternsAll, List<List<String>> numsAll) {
  HashMap<ScreenDigit, Count> countMap = HashMap();

  for (var i = 0; i < patternsAll.length; i++) {
    var nums = numsAll[i];
    // coz 8 uses all the digits
    for (var num in nums) {
      switch (num.length) {
        case 7:
          countMap.update(8, (value) => value + 1, ifAbsent: () => 1);
          break;
        case 2:
          countMap.update(1, (value) => value + 1, ifAbsent: () => 1);
          break;
        case 3:
          countMap.update(7, (value) => value + 1, ifAbsent: () => 1);
          break;
        case 4:
          countMap.update(4, (value) => value + 1, ifAbsent: () => 1);
          break;
      }
    }
  }

  print(countMap.values.reduce((v, e) => v + e));
}
