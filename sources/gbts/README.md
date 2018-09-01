GBTS - GBT written in Shell
===========================

Use `gbts` in the prompt:

```shell
export GBT__HOME=/path/to/gbt

### Local prompt
# ZSH
PROMPT='$($GBT__HOME/sources/gbts/gbts $?)'
# Bash
PS1='$($GBT__HOME/sources/gbts/gbts $?)'

source $GBT__HOME/sources/gbts/cmd/local.sh

# Local aliases
alias docker=gbt_docker
alias mysql=gbt_mysql
alias screen=gbt_screen
alias ssh=gbt_ssh
alias vagrant=gbt_vagrant

# Remote aliases
alias gbt___sudo=gbt_sudo
alias gbt___su=gbt_su
```

Additional settings (must be configured before sourcing the `local.sh` file):

```shell
# List of cars to pack for the remote.
# Should match or exceed the list of cars from the theme or the theme variables
# (GBT__THEME_REMOTE_CARS and GBT__THEME_MYSQL_CARS).
export GBT__CARS_REMOTE='Status, Os, Time, Hostname, Dir, Custom, Git, Sign'

# Set SSH theme file
export GBT__THEME_SSH=$GBT__HOME/sources/gbts/theme/local/basic.sh

# List of plugins to pack for the remote
export GBT__PLUGINS_REMOTE='docker,mysql,screen,ssh,su,sudo,vagrant'

# List of plugins to pack for local commands
export GBT__PLUGINS_LOCAL='docker,mysql,screen,ssh,su,sudo,vagrant'

# Suppress code minimizing
export GBT__SOURCE_MINIMIZE='cat'

# Suppress code compressing
export GBT__SOURCE_COMPRESS='cat'

# Suppress code decompressin
export GBT__SOURCE_DECOMPRESS='cat'

# Set base64 decompressing switch for MacOS
export GBT__SOURCE_BASE64_DEC='-D'
```
