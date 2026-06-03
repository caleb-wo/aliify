# Aliify("Alias-ify")
This is a simple program I made just so it's easier to manage shell aliases that are sourced on startup. The first version was made in Lua. You can see it in `legacy/`. I've now implementing it in Dart. Feel free to take a look!

# Usage

Aliify creates, updates, & deletes aliases in a file that the program manages called `bank/alias_bank.sh`. It can be used by typing the command `aliify` followed by the command & arguments.

## Adding

Usage: `aliify add <alias name> [command(s)]`]

Examples:

```bash
aliify add get_here 'export HERE=$(pwd)' # quotes are needed so '$(pwd)' is evaluated where get_here is called.
aliify add 
```





