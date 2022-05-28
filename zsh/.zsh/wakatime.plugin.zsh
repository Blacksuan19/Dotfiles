
# wakatime-zsh-plugin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin

_wakatime_heartbeat() {
  # Sends a heartbeat to the wakatime server before each command.
  # But it can be disabled by an environment variable:
  # Set `$WAKATIME_DO_NOT_TRACK` to 1 to skip the tracking.
  if (( WAKATIME_DO_NOT_TRACK )); then
    return  # Tracking is skipped!
  fi

  # Set a custom path for the wakatime-cli binary
  # otherwise point to the default `~/.wakatime/wakatime-cli`
  local wakatime_bin="${ZSH_WAKATIME_BIN:=$HOME/.wakatime/wakatime-cli}"

  # Checks if `wakatime` is installed,
  if ! wakatime_loc="$(type -p "$wakatime_bin")"; then
    echo 'wakatime-cli is not installed, run:'
    echo '$ python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"'
    echo
    echo 'Time is not tracked for now.'
    return
  fi

  # We only send the last command to the wakatime.
  # We only send the first argument, which is a binary in 99% of cases.
  # It does not include any sensitive information.
  local last_command
  last_command=$(echo "$history[$HISTCMD]" | cut -d ' ' -f1)

  # Determine the project name
  local root_directory

  # If the `.wakatime-project` file exists
  # then we read the first line to get the project name
  # and use it as the `root` directory name.
  if [ -f .wakatime-project ]; then
    read -r root_directory < .wakatime-project
  fi

  # If the `.wakatime-project` file does not exist (or if it is empty)
  # then we get the `root` directory from the current git repository.
  # If we are not in a git repository
  # then we will use the default project name `Terminal`.
  if [ -z "$root_directory" ]; then
    root_directory=$(
      git rev-parse --show-toplevel 2>/dev/null || echo 'Terminal'
    )
  fi

  # Checks if the app should work online, otherwise returns
  # a special option to turn `wakatime` sync off:
  local should_work_online
  if (( WAKATIME_DISABLE_OFFLINE )); then
    should_work_online='--disable-offline'
  else
    should_work_online=''
  fi

  "$wakatime_bin" --write \
    --plugin 'wakatime-zsh-plugin/0.2.2' \
    --entity-type app \
    --entity "$last_command" \
    --project "${root_directory:t}" \
    --language sh \
    --timeout "${WAKATIME_TIMEOUT:-5}" \
    $should_work_online \
    &>/dev/null </dev/null &!
}

# See docs on `add-zsh-hook`:
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/add-zsh-hook
autoload -U add-zsh-hook

# See docs on what `preexec` is:
# http://zsh.sourceforge.net/Doc/Release/Functions.html
add-zsh-hook preexec _wakatime_heartbeat
