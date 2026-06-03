import 'dart:io';
import 'package:args/command_runner.dart';

import 'model/alias.dart';
import 'model/config.dart';
import 'model/repo.dart';

const String version = '0.0.1';

void main(List<String> args) async {
  final state = AliifyState();
  final repo = state.repo;

  final runner =
      CommandRunner(
          'aliify',
          'A program to manage, create, update, and delete your aliases.\n\n'
              'IMPORTANT: Ensure aliify\'s alias_bank.sh is sourced in your shell configuration file (e.g., ~/.zshrc or ~/.bashrc).',
        )
        ..addCommand(ListCommand(repo))
        ..addCommand(AddCommand(repo))
        ..addCommand(RemoveCommand(repo))
        ..addCommand(UpdateCommand(repo))
        ..addCommand(ResourcesCommand(repo))
        ..addCommand(SetupCommand(state));

  try {
    await runner.run(args);
  } catch (e) {
    stderr.writeln(e);
    exit(64);
  }
}

/// COMMAND: list
/// Usage: aliify list
class ListCommand extends Command {
  final AliifyRepo repo;

  @override
  final String name = 'list';
  @override
  final String description = 'Lists all saved aliases.';

  @override
  List<String> get aliases => ['l', 'ls'];

  ListCommand(this.repo);

  @override
  void run() {
    repo.list();
  }
}

/// COMMAND: resources
/// Usage: aliify resources
class ResourcesCommand extends Command {
  final AliifyRepo repo;

  @override
  final String name = 'resources';

  @override
  final String description = 'Lists the directory and file Aliify works with.';

  @override
  List<String> get aliases => ['re', 'resource', 'paths'];

  ResourcesCommand(this.repo);

  @override
  void run() {
    var contents = repo.resources();
    print('Directory: ${contents.$1}');
    print('File: ${contents.$2}');
  }
}

/// COMMAND: add
/// Usage: aliify add <name> <command>
class AddCommand extends Command {
  final AliifyRepo repo;

  @override
  final String name = 'add';
  @override
  final String description =
      'Adds a new alias.\nUsage: aliify add <name> <command>';

  @override
  List<String> get aliases => ['a', 'new', 'create'];

  AddCommand(this.repo);

  @override
  void run() {
    final rest = argResults?.rest ?? [];
    if (rest.length < 2) {
      usageException('You must provide both a name and a command string.');
    }

    final aliasName = rest[0];
    final commandString = rest.sublist(1).join(' ');

    repo.add(PartialAlias(aliasName, commandString));
    print('Successfully added alias: $aliasName');
  }
}

/// COMMAND: remove
/// Usage: aliify remove <position>
class RemoveCommand extends Command {
  final AliifyRepo repo;

  @override
  final String name = 'remove';
  @override
  final String description =
      'Removes an alias by its position number. Run `aliify list` to get the position.\n'
      'Usage: aliify remove <position>';

  @override
  List<String> get aliases => ['r', 'rm', 'delete'];

  RemoveCommand(this.repo);

  @override
  void run() {
    final rest = argResults?.rest ?? [];
    if (rest.isEmpty) {
      usageException(
        'You must provide the position number of the alias to remove.',
      );
    }

    final position = int.tryParse(rest[0]);
    if (position == null || position < 1 || position > repo.aliases.length) {
      usageException(
        'Invalid position number. Please check "aliify list" and try again.',
      );
    }

    // Pass 'position - 1' because your repo expects a 0-based array index
    final removed = repo.remove(position - 1);
    print('Successfully removed alias: ${removed.name}');
  }
}

/// COMMAND: update
/// Usage: aliify update <position> <new_name> <new_command>
class UpdateCommand extends Command {
  final AliifyRepo repo;

  @override
  final String name = 'update';
  @override
  final String description =
      'Updates an existing alias.\nUsage: aliify update <position> <new_name> <new_command>';

  @override
  List<String> get aliases => ['u'];

  UpdateCommand(this.repo);

  @override
  void run() {
    final rest = argResults?.rest ?? [];
    if (rest.length < 3) {
      usageException(
        'You must provide a position, a new name, and a new command.',
      );
    }

    final position = int.tryParse(rest[0]);
    if (position == null || position < 1 || position > repo.aliases.length) {
      usageException(
        'Invalid position number. Please check "aliify list" and try again.',
      );
    }

    final aliasName = rest[1];
    final commandString = rest.sublist(2).join(' ');

    final result = repo.update(
      position: position,
      using: PartialAlias(aliasName, commandString),
    );

    print('Successfully updated alias at position $position.');
    print('Old: ${result.$1}');
    print('New: ${result.$2}');
  }
}

/// COMMAND: setup
/// Usage: aliify setup
class SetupCommand extends Command {
  final AliifyState _state;

  @override
  String name = 'setup';

  @override
  String description;

  @override
  List<String> get aliases => ['init', 's'];

  SetupCommand(this._state)
    : description =
          "Adds and sources aliify's file path: ${_state.file.path} in the shell's config. Additionally adds aliify to PATH. (only support Bash and Zsh)";

  @override
  void run() {
    _state.aliifyInit();
  }
}
