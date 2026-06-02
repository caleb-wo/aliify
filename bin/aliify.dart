import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

const String version = '0.0.1';

/// TODO:
/// Implement application using CommandRunner instead of ArgParser.
/// Deleted starter code to boost learning potential of the project.
void main() {
  final runner = CommandRunner(
    'Aliify',
    'A program to manage, create, update, and delete your aliases.',
  );
}
