# Aliify("Alias-ify")
This is a simple program I made just so it's easier to manage shell aliases that are sourced on startup. The first version was made in Lua. You can see it in `legacy/`. I've now implemented it in Dart. Feel free to take a look! This was made without AI writing any code since it was a learning project. 

## Getting Started

**Dependancies**:

- [Dart SDK 3.12.0](https://dart.dev/get-dart)

**Compilation**:

Once you have Dart, clone this repo & cd into the root directory. Then, you just need to run:
```bash
> dart compile exe bin/aliify.dart -o aliify
> ./aliify resources
Directory: /path/to/bank
File: /path/to/bank/file
```

From there you can add it to your path however you wish. Make sure you also source the file `aliify/bank/alias_bank.sh` in your shell config (e.g., `.zshrc`, `.bashrc`).

# Usage

Aliify creates, updates, & deletes aliases in a file that the program manages called `bank/alias_bank.sh`. It can be used by typing the command `aliify` followed by the command & arguments.

## Adding

Usage: `aliify add <alias name> [command]`]

Examples:

```bash
> aliify add get_here export HERE='$(pwd)' # quotes are needed so '$(pwd)' is evaluated where get_here is called.
> aliify add byui cd path/to/my/school/work/directory
> aliify add home cd ~
> aliify add ll 'll -la' # commands w/flags must be single quoted.
```

## List

Aliify can list all saved aliases by running `aliify list`. Here's an example of what I see after using it for just a half day:

```bash
> aliify list
Aliases:
  - 1. alias ccc='c3c';
  - 2. alias myproj='cd /Users/calebwolfe/MyProjects';
  - 3. alias mysof='cd /Users/calebwolfe/MySoftwares';
  - 4. alias config='vim /Users/calebwolfe/.my_config.sh';
  - 5. alias config-load='source /Users/calebwolfe/.my_config.sh';
  - 6. alias byui='cd /Users/calebwolfe/Desktop/BYUI';
  - 7. alias get-here='export HERE=$(pwd)';
  - 8. alias ll='ls -la';
```

## Remove

Removing an alias is meant to be used alongside `List`. When listing aliases, you can see the position or index of your alias. For example, if I wanted to remove the alias `byui` from above, I'd need to do the following. 

<sub>(I've added a comment & '...')</sub>

```bash
> aliify remove 6
Successfully removed alias: byui
> aliify list
Aliases:
  - 1. alias ccc='c3c';
	...
  - 6. alias get-here='export HERE=$(pwd)'; # 'byui' alias is now gone
  - 7. alias ll='ls -la';
```

## Update

Updates an alias at the given position using `aliify update [position] [new name] [new command]`.  See the example below using the list above as well.

```bash
❯ aliify update 1 c3_compiler c3c 
Successfully updated alias at position 1.
Old: alias ccc='c3c';
New: alias c3_compiler='c3c';
```

## Resources

By running `aliify resources`, Aliify prints the paths to it's bank directory & file.

## Help

```tex
❯ aliify help            
A program to manage, create, update, and delete your aliases.

IMPORTANT: Ensure aliify's alias_bank.sh is sourced in your shell configuration file (e.g., ~/.zshrc or ~/.bashrc).

Usage: aliify <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  add         Adds a new alias.
  list        Lists all saved aliases.
  remove      Removes an alias by its position number. Run `aliify list` to get the position.
  resources   Lists the directory and file Aliify works with.
  update      Updates an existing alias.

Run "aliify help <command>" for more information about a command.
```

