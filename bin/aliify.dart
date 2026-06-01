import 'package:args/args.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

const String version = '0.0.1';

/// TODO:
/// Implement application using CommandRunner instead of ArgParser.
/// Deleted starter code to boost learning potential of the project.
void main() {
  final file = File(
    '${p.dirname(Platform.script.toFilePath())}/bank/alias_bank.sh',
  );
  final directory = Directory('${Platform.script.toFilePath()}/bank');

  print(location);
  print(file);
  print(directory);
}
