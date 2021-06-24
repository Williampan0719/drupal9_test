#!/usr/bin/env bash

isCommand() {
  for cmd in \
    "about" \
    "archive" \
    "browse" \
    "check-platform-reqs" \
    "clear-cache" \
    "clearcache" \
    "config" \
    "create-project" \
    "depends" \
    "diagnose" \
    "dump-autoload" \
    "dumpautoload" \
    "exec" \
    "global" \
    "help" \
    "home" \
    "info" \
    "init" \
    "install" \
    "licenses" \
    "list" \
    "outdated" \
    "prohibits" \
    "remove" \
    "require" \
    "run-script" \
    "search" \
    "self-update" \
    "selfupdate" \
    "show" \
    "status" \
    "suggests" \
    "update" \
    "upgrade" \
    "validate" \
    "why" \
    "why-not"
  do
    if [ -z "${cmd#"$1"}" ]; then
      return 0
    fi
  done

  return 1
}

windowsComposerHack()
{
  [ "$1" = 'composer' ] && shift
  echo "Install rsync if necessary . . . "
  [ command -v rsync ] || apk --no-cache add rsync
  echo "Create /temp_dir . . . "
  mkdir -p /temp_dir
  echo "Copy /app to /temp_dir . . . "
  cp -rvf /app /temp_dir/
  cd /temp_dir/app
  echo "Run composer command . . . "
  composer "$@"
  cd /
  echo "Commit changes from /temp_dir to /app . . . "
  rsync -avz /temp_dir/app/* /app/
}

# check if runing in windoows
if [ "$1" = '--windows-hack' ]; then
  if [ "$(printf %c "$2")" = '-' ] || [ "$2" = 'composer' ] || isCommand "$2"; then
    shift
    echo "Start composer hack for windows . . . "
    windowsComposerHack "$@"
    echo "Hack finished . . . "
    exit
  else
    shift
    exec "$@"
    exit
  fi
# check if the first argument passed in looks like a flag
elif [ "$(printf %c "$1")" = '-' ]; then
  set -- /sbin/tini -- composer "$@"
# check if the first argument passed in is composer
elif [ "$1" = 'composer' ]; then
  set -- /sbin/tini -- "$@"
# check if the first argument passed in matches a known command
elif isCommand "$1"; then
  set -- /sbin/tini -- composer "$@"
fi

exec "$@"
