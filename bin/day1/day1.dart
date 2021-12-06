import 'dart:io';

void main(List<String> arguments) async {
  var file = File("input.txt");
  List<int> nums = await file
      .readAsLines()
      .then((value) => value.map((e) => int.parse(e)).toList());

  part1(nums);
  part2(nums);
}

void part2(List<int> input) {
  // part 1
  var windows = [];

  input.asMap().forEach(
    (index, value) {
      if (index < input.length - 2) {
        windows.add(0);
        for (var i = index; i < index + 3; i++) {
          windows[index] += input[i];
        }
      }
    },
  );

  // part 1
  var bigger = 0;
  int? last;

  for (var element in windows) {
    if (last != null && element > last) {
      bigger++;
    }
    last = element;
  }

  print("D1 P2: " + bigger.toString());
}

void part1(List<int> input) {
  // part 1
  var bigger = 0;
  int? last;

  for (var element in input) {
    if (last != null && element > last) {
      bigger++;
    }
    last = element;
  }

  print("D1 P1: " + bigger.toString());
}
