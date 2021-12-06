import 'dart:io';

void main(List<String> arguments) async {
  var file = File("input.txt");
  var input = await file.readAsLines();

  part1(input);
  part2(input);
}

String getOxygenRating(List<String> inputs, int bitIndex) {
  if (inputs.length == 1) {
    return inputs[0];
  }

  List<String> zeros = [];
  List<String> ones = [];

  for (var val in inputs) {
    if (val[bitIndex] == "0") {
      zeros.add(val);
    } else {
      ones.add(val);
    }
  }

  if (ones.length >= zeros.length) {
    return getOxygenRating(ones, bitIndex + 1);
  } else {
    return getOxygenRating(zeros, bitIndex + 1);
  }
}

String getScrubberRating(List<String> inputs, int bitIndex) {
  if (inputs.length == 1) {
    return inputs[0];
  }

  List<String> zeros = [];
  List<String> ones = [];

  for (var val in inputs) {
    if (val[bitIndex] == "0") {
      zeros.add(val);
    } else {
      ones.add(val);
    }
  }

  if (zeros.length <= ones.length) {
    return getScrubberRating(zeros, bitIndex + 1);
  } else {
    return getScrubberRating(ones, bitIndex + 1);
  }
}

void part2(List<String> input) {
  var oxyStr = getOxygenRating(input, 0);
  var oxyRating = int.parse(oxyStr, radix: 2);

  var scrubberStr = getScrubberRating(input, 0);
  var scrubberRating = int.parse(scrubberStr, radix: 2);

  print("D3 P2: " + (oxyRating * scrubberRating).toString());
}

void part1(List<String> input) {
  String gammaStr = "";
  String epsilonStr = "";

  for (var i = 0; i < input[0].length; i++) {
    int zeros = 0;
    int ones = 0;

    for (var val in input) {
      if (val[i] == '0') {
        zeros++;
      } else {
        ones++;
      }
    }

    if (ones > zeros) {
      gammaStr += "1";
      epsilonStr += "0";
    } else {
      gammaStr += "0";
      epsilonStr += "1";
    }
  }

  var gamma = int.parse(gammaStr, radix: 2);
  var epsilon = int.parse(epsilonStr, radix: 2);

  print("D3 P1: " + (gamma * epsilon).toString());
}
