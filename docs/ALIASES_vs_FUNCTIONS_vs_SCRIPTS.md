Taken from: https://unix.stackexchange.com/questions/30925/in-bash-when-to-alias-when-to-script-and-when-to-write-a-function on 8/22/18

# Aliases and Functions
- The entire contents of aliases and functions are stored in the shell's memory.
- Thus, aliases and functions can only be used by the current shell, and not by any other programs you may invoke from the shell like text editors, scripts, or even child instances of the same shell.
- Aliases and functions are executed by the current shell, i.e. they run within and affect the shell's current environment. No separate process is necessary to run an alias or function.


# Scripts
- Shells do not keep scripts in memory. Instead, scripts are read from the files where they are stored every time they are needed. If the script is found via a $PATH search, many shells store a hash of its path name in memory to save time on future $PATH look-ups, but that is the extent of a script's memory footprint when not in use.
- Scripts can be passed as an argument to an interpreter, like `python script`, or invoked directly as an executable, in which case the interpreter in the shebang line (e.g. #!/bin/sh) is invoked to run it. In both cases, the script is run by a separate interpreter process with its own environment separate from that of your shell, whose environment the script cannot affect in any way. Indeed, the interpreter shell does not even have to match the invoking shell. Because scripts invoked this way appear to behave like any ordinary executable, they can be used by any program.
- Finally, a script can be read and run by the current shell with ., or in some shells, source. In this case, the script behaves much like a function that is read on-demand instead of being constantly kept in memory.

# Application
Given the above, we can come up with some general guidelines for whether to make something a script or function / alias.

- Do other programs besides your shell need to be able to use it? If so, it has to be a script.
- Do you only want it to be available from an interactive shell? It's common to want to change the default behavior of many commands when run interactively without affecting external commands / scripts. For this case, use an alias / function set in the shell's "interactive-mode-only" rc file (for bash this is .bashrc).
- Does it need to change the shell's environment? Both a function / alias or a sourced script are possible choices.
- Is it something you use frequently? It's probably more efficient to keep it in memory, so make it a function / alias if possible.
- Conversely, is it something you use only rarely? In that case, there's no sense having it hog memory when you don't need it, so make it a script.
