/// [Alias] holds data for an alias
class Alias {
  const Alias(this.index, {required this.identifier, required this.command});

  /// [index] = index of the alias.
  final String index;

  /// [identifier] = name of the alias.
  final String identifier;

  /// [command] = string of the command the user gave.
  final String command;

  @override
  String toString() {
    return "($index)=[  alias $identifier='$command'  ]";
  }
}
