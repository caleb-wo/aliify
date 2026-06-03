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

  AliifyState._() : location = _resolveLocation() {
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

  // 1. Add this static helper method inside your AliifyState class
  static String _resolveLocation() {
    final exe = Platform.resolvedExecutable;

    // If the executable is 'dart' or 'dart.exe', we are in Development (JIT) mode
    if (exe.endsWith('dart') || exe.endsWith('dart.exe')) {
      return p.dirname(p.dirname(Platform.script.toFilePath()));
    }

    // Otherwise, we are in Production (AOT) mode.
    // resolvedExecutable points straight to the compiled binary inside your project folder!
    return p.dirname(exe);
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

  void aliifyInit() async {
    final homeDir = Platform.environment['HOME'];

    if (homeDir == null) {
      stderr.writeln('[ERROR] Could not resolve home directory.');
      return;
    }

    final shellPath = Platform.environment['SHELL'] ?? '';
    String configFileName = '.bashrc'; // default

    if (shellPath.contains('zsh')) {
      configFileName = '.zshrc';
    }

    final shellConfigFile = File(p.join(homeDir, configFileName));
    final (bankDir, aliasBank) = repo.resources();

    final sourceLine = "source '$aliasBank'";

    if (shellConfigFile.existsSync()) {
      final configContent = await shellConfigFile.readAsString();
      if (configContent.contains(aliasBank)) {
        print('Aliify is already configured in $configFileName!');
        return;
      }
    }

    try {
      final sink = shellConfigFile.openWrite(mode: .append);
      sink.writeln();
      sink.writeln('\n##### Aliify Alias Bank Connection');
      sink.writeln(sourceLine);
      sink.writeln("export PATH=\"\$PATH:${p.dirname(bankDir)}\"");
      sink.writeln('##### Aliify');
      sink.writeln();
      await sink.close();
      print('Success! Added aliify to your $configFileName file.');
      print(
        'Please run: "source ~/$configFileName" or open a new terminal tab to activate!',
      );
    } catch (e) {
      stderr.writeln('[ERROR] Failed to write to shell config file.\n$e');
    }
  }
}

enum Status {
  initialized,
  uninitialized,
  error,
}
