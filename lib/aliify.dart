import 'dart:io';
import 'alias.dart';

/// Manages a user's shell aliases used on their system. Allows for the creation,
/// deletion, listing, and updating of aliify-managed aliases. When an alias is saved it
/// is written as follows: alias NAME='';
///
/// NOTE: Aliases are only `...='{command}'`, aka they can only be execution-time evaluated.
class Aliify {
  /// [aliasBank] = the directory which houses the `.aliify.sh` or another set by the user.
  /// It must be an absolute path.
  late String? aliasBank;

  /// [aliasRecord] = the primary file Aliify writes and reads from. Its named
  /// `.aliify.sh' by default. Users can set a default file or specify a specific file.
  late String? aliasRecord;

  /// [aliases] = an array of all the user's aliases.
  late List<Alias> aliases;

  /// [initStatus] = tracks whether [init] has been run. Must be `true` for almost all
  /// other functions to run.
  bool initStatus = false;

  /// [isInitialized] = checks if [initStatus] is `true`. (added purely for ergonomics🤓)
  bool get isInitialized => initStatus;

  /// [notInitialized] = checks if [initStatus] is `false`. (added purely for ergonomics🤓)
  bool get notInitialized => !isInitialized;

  /// The [init] method handles the setup of the application. It simply loads the alias
  /// file and folder (either user defaults or specific).
  void init() {}

  /// [usage] prints acceptable Aliify commands to stdout.
  void usage() {
    if (notInitialized) {
      return;
    }
  }

  /// [create] adds a new alias to the file designated by [aliasRecord].
  void create(String command) {
    if (notInitialized) {
      return;
    }
  }

  /// [delete] removes an alias.
  ///
  /// [aliasNumber] = index of the alias being deleted.
  void delete(int aliasNumber) {
    if (notInitialized) {
      return;
    }
  }

  /// [update] updates a current alias.
  void update() {
    if (notInitialized) {
      return;
    }
  }

  /// [display] lists all aliases by number.
  void display() {
    if (notInitialized) {
      return;
    }
  }

  /// [setDefaults] allows the users to setup a new default directory and file.
  void setDefaults() {}

  /// [_getDefaults] fetches the [dir] and [file] the users has set to default.
  (Directory dir, File file)? _getDefaults() {}
}
