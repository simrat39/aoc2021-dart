import 'dart:io';

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();

  var nums = input[0].split(",").map((e) => int.parse(e)).toList();

  /* part1(nums); */
  part2(nums);
}

// better solution
void part2(List<int> nums) {
  var days = 256;

  List<int> state = List.generate(9, (index) => 0);

  for (var num in nums) {
    state[num] += 1;
  }

  for (var i = 0; i < days; i++) {
    // padding
    var newState = List.from(state);

    state.asMap().forEach((index, count) {
      if (index == 0) {
        newState[8] = count;
      } else {
        newState[index - 1] = count;
      }
    });

    newState[6] += newState.last;

    state = List.from(newState);
    // padding
  }

  print(state.fold(0, (p, c) => (p! as int) + c));
}

// naive solution
void part1(List<int> nums) {
  var days = 80;
  var state = nums;

  for (int i = 0; i < days; i++) {
    List<int> endAppend = [];

    for (var fish = 0; fish < state.length; fish++) {
      var value = state[fish];

      if (value == 0) {
        state[fish] = 6;
        endAppend.add(8);
      } else {
        state[fish] = value - 1;
      }
    }
    state.addAll(endAppend);
  }

  print(state.length);
}
