import 'dart:io';

import 'alias.dart';
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

  void list(){
  }
}
