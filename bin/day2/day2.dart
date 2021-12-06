import 'dart:io';

enum Direction { down, up, forward }

class Command {
  final Direction direction;
  final int distance;

  Command(this.direction, this.distance);
}

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();
  List<Command> parsed = [];

  for (var val in input) {
    var splits = val.split(" ");
    var directionStr = splits[0];
    var distance = int.parse(splits[1]);

    late Direction direction;

    switch (directionStr) {
      case "forward":
        direction = Direction.forward;
        break;
      case "down":
        direction = Direction.down;
        break;
      case "up":
        direction = Direction.up;
        break;
    }

    parsed.add(Command(direction, distance));
  }

  part1(parsed);
  part2(parsed);
}

void part2(List<Command> input) {
  int horizontal = 0;
  int vertical = 0;
  int aim = 0;

  for (var val in input) {
    switch (val.direction) {
      case Direction.down:
        aim += val.distance;
        break;
      case Direction.up:
        aim -= val.distance;
        break;
      case Direction.forward:
        horizontal += val.distance;
        vertical += aim * val.distance;
        break;
    }
  }

  print("D1 P2: " + (horizontal * vertical).toString());
}

void part1(List<Command> input) {
  int horizontal = 0;
  int vertical = 0;

  for (var val in input) {
    switch (val.direction) {
      case Direction.down:
        vertical += val.distance;
        break;
      case Direction.up:
        vertical -= val.distance;
        break;
      case Direction.forward:
        horizontal += val.distance;
        break;
    }
  }

  print("D1 P1: " + (horizontal * vertical).toString());
}
