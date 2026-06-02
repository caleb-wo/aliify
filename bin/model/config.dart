import 'dart:io';
import 'package:path/path.dart' as p;
import 'repo.dart';

/// Handles setup and management of the Aliify application. Self iniitalizes.
///
/// Initializes the program and and ensures it's environment is ready to be used. Checks
/// that all necessary directories and files are in existence and creates if needed. Additionally
/// provided access to Repo.
final class AliifyState {
  Status status = .uninitialized;
  final String location;
  late final File file;
  late final Directory directory;
  late final AliifyRepo repo;

  AliifyState._()
    : location = p.dirname(p.dirname(Platform.script.toFilePath())) {
    directory = Directory(p.join(location, 'bank'));
    file = File(p.join(directory.path, 'alias_bank.sh'));
    _setup();

    repo = AliifyRepo(this);
  }
  static final AliifyState _instance = ._();
  factory AliifyState() => _instance;

  (bool directory, bool file) _check() {
    var dir = directory.existsSync();
    var f = file.existsSync();
    return (dir, f);
  }

  /// Checks that the necessary file and directory are created. If not, it handles the
  /// creation.
  bool _setup() {
    try {
      var exists = _check();
      if (exists.$1 && exists.$2) {
        status = .initialized;
        return true;
      }

      directory.createSync(recursive: true);
      file.createSync(exclusive: false);
      status = .initialized;
      return true;
    } catch (_) {
      status = .error;
      return false;
    }
  }
}

enum Status {
  initialized,
  uninitialized,
  error,
}
