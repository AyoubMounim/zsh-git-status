
# Git Status Plugin

A zsh plugin that exposes functions for retrieving informations about the
status of the current git repository.

A use case for this plugin is the displaying of the repository git status in
the terminal prompt.

After the `zsh-git-status.zsg` file is sourced a number of utilities functions
for getting informations about the git directories are avaible to the client
code.

## Prompt Application

The API function `get_git_status` returns a formatted
string which can be readyly embedded inside a console prompt.

One could either custumise the output of `get_git_status` by editing the global
variables defined in the `zsh-git-status-globals.zsh`, or use the API functios
to build ther own prompt string.

The default formatted string shows the git info in the following format:
[git_branch|3|4]

