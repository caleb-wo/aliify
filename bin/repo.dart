import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:characters/characters.dart';

import 'config.dart';

/// Manages reading and writing aliify aliases.
final class AliifyRepo {
  final AliifyState _state;
  late final AliasList aliases;

  AliifyRepo(this._state) {
    _loadAliases();
  }

  void _loadAliases() {
    if (_state.status == .uninitialized) {
      stderr.writeln('[ERROR] Aliify is not intialized.');
      exit(255);
    }

    try {
      aliases = AliasList(_state.file.readAsLinesSync());
    } catch (e) {
      stderr.writeln('[ERROR] Issues reading ${_state.file.path} \n$e');
      exit(255);
    }
  }

  void _saveAliases() {
    if (aliases.isEmpty) return;

    var buffer = StringBuffer(
      '# DO NOT EDIT. This file is used by the Aliify program.',
    );
    var current = aliases.list[0];
    try {
      for (final alias in aliases) {
        buffer.writeln(alias);
      }

      _state.file.writeAsStringSync(buffer.toString());
    } catch (e) {
      stderr.writeln(
        "[ERROR] Couldn't write \"$current\" to file: ${_state.file.path}",
      );
      exit(255);
    }
  }
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

  String toDisplayString() {
    return "- $position. alias $name='$commandString';";
  }
}

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
      if (line.startsWith('#')) continue;

      final halves = line.split('=');
      if (halves.length != 2) {
        stderr.writeln('[ERROR] Line: $line');
        exit(255);
      }

      final name = halves[0].split(' ')[1].trim();
      final chars = halves[1].trim().split('');

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
    if (list.isEmpty) return 'AliasList: [ /* empty */ ]'; // Saftey check
    final buffer = StringBuffer('Aliases: [');

    for (final alias in list) {
      buffer.writeln('  ${alias.toDisplayString()}');
    }
    buffer.writeln(']');

    return buffer.toString();
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
