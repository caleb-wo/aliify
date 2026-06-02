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

  void _sync() {
    _saveAliases();
    _loadAliases();
  }

  void list() {
    print(aliases);
  }

  void add(PartialAlias partial) {
    aliases.add(Alias.fromPartial(partial, position: aliases.length));
    _sync();
  }

  Alias remove(int index) {
    var removed = aliases.removeAt(index);
    _sync();
    return removed;
  }

  (String old, String fresh) update({
    required int position,
    required PartialAlias using,
  }) {
    final index = position - 1;
    final old = aliases[index].toString();

    aliases[index] = Alias.fromPartial(using, position: position);
    final replacement = aliases[index].toString();

    _sync();

    return (old, replacement);
  }

  (String dirPath, String filePath) resources() {
    return (_state.directory.path, _state.file.path);
  }
}
