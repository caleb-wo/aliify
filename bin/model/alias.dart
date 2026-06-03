import 'dart:collection';
import 'dart:io';

/// Represent a users alias.
class Alias {
  String name;
  String commandString;
  int position;

  Alias({
    required this.name,
    required this.commandString,
    required this.position,
  });

  /// Constructs an Alias object from [PartialAlias].
  factory Alias.fromPartial(PartialAlias partial, {required int position}) {
    return Alias(
      name: partial.name,
      commandString: partial.commandString,
      position: position,
    );
  }

  @override
  String toString() {
    return "alias $name='$commandString';";
  }

  /// A special string meant to be displayed to the user.
  String toDisplayString() {
    return "- $position. alias $name='$commandString';";
  }
}

/// A partial alias which has [name] and [commandString] but does not have [posistion].
class PartialAlias {
  final String name;
  final String commandString;

  PartialAlias(this.name, this.commandString);
}

class AliasList extends ListBase<Alias> {
  late List<Alias> list;

  @override
  int get length => list.length;
  @override
  set length(int newLength) => list.length = newLength;

  AliasList(List<String> source) {
    list = parse(source);
  }

  /// Handles parsing string lines from `alias_bank.sh` into a list of [Alias].
  List<Alias> parse(List<String> source) {
    List<Alias> list = [];
    var counter = 1;

    for (final line in source) {
      if (line.startsWith('#') || line.trim().isEmpty) continue;
      final equalsIdx = line.indexOf('=');

      if (equalsIdx == -1) {
        stderr.writeln('[ERROR] Line: $line');
        continue;
      }

      final namePart = line.substring(0, equalsIdx).trim();
      final commandPart = line.substring(equalsIdx + 1).trim();

      final nameHalves = namePart.split(' ');
      if (nameHalves.length < 2) {
        stderr.writeln('[ERROR] Line: $line');
        continue;
      }

      final name = nameHalves[1].trim();
      final chars = commandPart.split('');

      if (chars.isEmpty || chars[0] != "'") {
        stderr.writeln(
          "[ERROR] Command string must start with \"'\".\nLine: $line",
        );
        continue;
      }

      final filteredChars = chars.indexed.where((pair) {
        final (idx, char) = pair;

        if (idx == 0 && char == "'") {
          return false;
        } else if (idx == chars.length - 1 && char == ';') {
          return false;
        } else if (idx == chars.length - 2 && char == "'") {
          return false;
        } else {
          return true;
        }
      });

      final command = filteredChars.map((pair) => pair.$2).join('');

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
    if (list.isEmpty) return 'AliasList: [ /* empty */ ]'; // Saftey check
    final buffer = StringBuffer('Aliases: [')..writeln();

    for (final alias in list) {
      buffer.writeln('  ${alias.toDisplayString()}');
    }
    buffer.writeln(']');

    return buffer.toString();
  }

  @override
  void add(Alias element) {
    list.add(element);
  }

  @override
  Alias removeAt(int index) {
    return list.removeAt(index);
  }

  @override
  operator [](int index) {
    return list[index];
  }

  @override
  void operator []=(int index, dynamic value) {
    switch (value) {
      case Alias newAlias:
        list[index] = newAlias;
      case PartialAlias newPartial:
        list[index] = Alias.fromPartial(
          newPartial,
          position: list[index].position,
        );
      default:
        throw ArgumentError(
          'Unsupported assignment value type: ${value.runtimeType}',
        );
    }
  }
}
