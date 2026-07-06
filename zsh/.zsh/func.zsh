zcp() {
  local user="blacksuan19"
  local host="10.0.0.2"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -u|--user)
        if [ -z "$2" ]; then
          echo "Error: $1 requires a username"
          return 1
        fi
        user="$2"
        shift 2
        ;;
      -h|--host)
        if [ -z "$2" ]; then
          echo "Error: $1 requires a server address"
          return 1
        fi
        host="$2"
        shift 2
        ;;
      --help|-?)
        cat <<EOF
Usage:
  zcp [OPTIONS] SOURCE... DEST_ON_SERVER

Copy one or more local files/folders to a remote server using rsync.

Options:
  -u, --user USER     SSH username. Default: blacksuan19
  -h, --host HOST     Server address/IP. Default: 10.0.0.2
      --help          Show this help text.

Arguments:
  SOURCE...           One or more local files or folders to copy.
  DEST_ON_SERVER      Destination path on the server.

Examples:
  # Copy one file using defaults
  zcp ./movie.mp4 /media/sda1-ata-SSK_Portable_SS/Videos/

  # Copy multiple files using defaults
  zcp ./a.mp4 ./b.mkv ./c.srt /media/sda1-ata-SSK_Portable_SS/Videos/

Notes:
  - Options must come before SOURCE and DEST.
  - The last non-option argument is always treated as the remote destination.
  - A trailing slash on a source folder copies its contents.
  - No trailing slash on a source folder copies the folder itself.
EOF
        return 0
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "Error: unknown option: $1"
        echo "Run: zcp --help"
        return 1
        ;;
      *)
        break
        ;;
    esac
  done

  if [ "$#" -lt 2 ]; then
    echo "Error: missing source or destination"
    echo
    zcp --help
    return 1
  fi

  local dest="${@: -1}"
  local sources=("${@:1:$#-1}")

  rsync -r \
    --partial --append-verify \
    --no-perms --no-owner --no-group --no-times --omit-dir-times \
    --info=progress2,name0,stats0 \
    --rsync-path="sudo -n /usr/bin/rsync" \
    "${sources[@]}" "${user}@${host}:$dest" \
    2>/dev/null
}
