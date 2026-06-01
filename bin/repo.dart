import 'dart:io';

import 'config.dart';

final class AliifyRepo {
  final AliifyState state = AliifyState();
}

class Alias {
  String name;
  String commandString;
  int position;

  Alias({
    required this.name,
    required this.commandString,
    required this.position,
  });

  @override
  String toString() {
    return "- $position. $name='$commandString';";
  }
}

class AliasList {
  late List<Alias> list;

  AliasList(List<String> source) {
    list = parse(source);
  }

  /// Handles parsing string lines from `alias_bank.sh` into a list of [Alias].
  List<Alias> parse(List<String> source) {
    List<Alias> list = [];
    var counter = 1;

    for (final line in source) {
      final halves = line.split('=');
      if (halves.length != 2) {
        stderr.writeln('[ERROR] Line: $line');
        exit(255);
      }

      final name = halves[0].split(' ')[1];
      final command = halves[1];
      if (!command.startsWith("'")) {
        stderr.writeln(
          "[ERROR] Command string must start with \"'\".\nLine: $line",
        );
        exit(255);
      }
      list.add(
        Alias(
          name: name,
          commandString: command,
          position: counter++, // passes count first, then incerments
        ),
      );
    }
    return list;
  }

  @override
  String toString() {
    final buffer = StringBuffer('Aliases: [');
    if (list.isEmpty) return 'AliasList: [ /* empty */ ]'; // Saftey check

    for (final alias in list) {
      buffer.writeln('  $alias');
    }
    buffer.writeln(']');

    return buffer.toString();
  }
}
