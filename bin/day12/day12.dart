import 'dart:collection';
import 'dart:io';

typedef Graph = HashMap<String, List<String>>;

void main(List<String> arguments) async {
  var file = File("input.txt");
  var lines = await file.readAsLines();

  Graph graph = HashMap();

  for (var line in lines) {
    var splitted = line.split("-");
    var node = splitted[0];
    var neighbor = splitted[1];

    graph.update(
      node,
      (value) => [...value, neighbor],
      ifAbsent: () => [neighbor],
    );

    graph.update(
      neighbor,
      (value) => [...value, node],
      ifAbsent: () => [node],
    );
  }

  part1(graph);
  part2(graph);
}

void getAllPathsP2(Graph graph, String s, String d, List<String> path,
    List<int> count, bool can_twice) {
  path.add(s);

  if (s == d) {
    count[0] += 1;
  } else {
    for (var n in graph[s]!) {
      if (n.toLowerCase() == n && path.contains(n)) {
        if (can_twice && !["start", "end"].contains(n)) {
          getAllPathsP2(graph, n, d, path, count, false);
        }
        continue;
      }
      getAllPathsP2(graph, n, d, path, count, can_twice);
    }
  }

  path.removeLast();
}

void part2(Graph graph) {
  List<int> count = [0];
  getAllPathsP2(graph, "start", "end", [], count, true);
  print(count);
}

void getAllPathsP1(
    Graph graph, String s, String d, List<String> path, List<int> count) {
  path.add(s);

  if (s == d) {
    count[0] += 1;
  } else {
    for (var n in graph[s]!) {
      if (n.toLowerCase() == n && path.contains(n)) {
        continue;
      }
      getAllPathsP1(graph, n, d, path, count);
    }
  }

  path.removeLast();
}

void part1(Graph graph) {
  List<int> count = [0];
  getAllPathsP1(graph, "start", "end", [], count);
  print(count);
}
