import 'dart:io';
import 'dart:math' as math;

typedef Position = int;
typedef Fuel = int;

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();

  var nums = input[0].split(",").map((e) => int.parse(e)).toList();

  part1(nums);
  part2(nums);
}

int shittyFibonacci(int val) {
  var ret = 0;

  for (var i = 0; i <= val; i++) {
    ret += i;
  }

  return ret;
}

void part2(List<int> nums) {
  int max = nums.reduce(math.max);

  int lastFuelSpent = 9999999999;

  for (var i = 0; i < max; i++) {
    var fuel = 0;
    for (var num in nums) {
      var steps = (num - i).abs();
      fuel += shittyFibonacci(steps);
    }
    lastFuelSpent = math.min(lastFuelSpent, fuel);
  }

  print(lastFuelSpent);
}

void part1(List<int> nums) {
  int max = nums.reduce(math.max);

  int lastFuelSpent = 9999999999;

  for (var i = 0; i < max; i++) {
    var fuel = 0;
    for (var num in nums) {
      fuel += (num - i).abs();
    }
    lastFuelSpent = math.min(lastFuelSpent, fuel);
  }

  print(lastFuelSpent);
}
