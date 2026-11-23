#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/KD-Shadow/nixos-config.git"
USER_NAME="sh4dow"
USER_GROUP="users"
REPO_DIR="/mnt/home/$USER_NAME/nixos-config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P || true)"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
die() {
  printf '\033[1;31mERROR:\033[0m %b\n' "$*" >&2
  exit 1
}

HOSTS=()
if [[ -n $SCRIPT_DIR && -d $SCRIPT_DIR/hosts ]]; then
  while IFS= read -r host_dir; do
    [[ -f "$host_dir/configuration.nix" ]] && HOSTS+=("$(basename "$host_dir")")
  done < <(find "$SCRIPT_DIR/hosts" -mindepth 1 -maxdepth 1 -type d | sort)
fi
(( ${#HOSTS[@]} > 0 )) || die "no hosts found under ${SCRIPT_DIR:-<script dir>}/hosts"

usage() {
  cat <<EOF
Usage: sudo $0 [--host <name>] [<name>]

Available hosts:
$(printf '  %s\n' "${HOSTS[@]}")

You can also select non-interactively:
  sudo env HOST=${HOSTS[0]} $0
  sudo $0 --host ${HOSTS[0]}

With no host argument, this script shows a numbered menu.
EOF
}

is_known_host() {
  local candidate
  for candidate in "${HOSTS[@]}"; do
    [[ $candidate == "$1" ]] && return 0
  done
  return 1
}

HOST="${HOST:-}"
while (($# > 0)); do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    --list-hosts)
      printf '%s\n' "${HOSTS[@]}"
      exit 0
      ;;
    --host)
      shift
      (($# > 0)) || die "--host requires a value"
      HOST="$1"
      ;;
    --host=*)
      HOST="${1#--host=}"
      ;;
    -*)
      die "unknown option: $1\n\n$(usage)"
      ;;
    *)
      [[ -z $HOST ]] || die "host specified more than once\n\n$(usage)"
      HOST="$1"
      ;;
  esac
  shift
done

if [[ -z $HOST ]]; then
  if [[ ! -t 0 ]]; then
    die "no host selected and no TTY available\n\n$(usage)"
  fi
  echo
  echo "Select host to install:"
  local_i=1
  for host in "${HOSTS[@]}"; do
    printf '  %d) %s\n' "$local_i" "$host"
    local_i=$((local_i + 1))
  done
  read -rp "Host [1-${#HOSTS[@]}]: " choice
  [[ $choice =~ ^[0-9]+$ ]] || die "invalid host selection: $choice"
  (( 10#$choice >= 1 && 10#$choice <= ${#HOSTS[@]} )) || die "invalid host selection: $choice"
  HOST="${HOSTS[10#$choice - 1]}"
else
  is_known_host "$HOST" || die "unknown host '$HOST'\n\n$(usage)"
fi

log "Selected host: $HOST"

[[ $EUID -eq 0 ]] || die "run as root (sudo -i)"
mountpoint -q /mnt || die "/mnt is not a mountpoint - mount your target root first"
if [[ -d /sys/firmware/efi ]] && ! mountpoint -q /mnt/boot; then
  die "booted in UEFI mode but /mnt/boot (ESP) is not mounted"
fi

if (($(awk '/MemTotal/{print $2}' /proc/meminfo) < 6000000)) && [[ -z "$(swapon --show --noheadings)" ]]; then
  echo "WARNING: <6 GB RAM and no swap active. The build may OOM. Consider: swapon /dev/<swap-partition>"
  read -rp "Continue anyway? [y/N] " ans
  [[ $ans == [yY]* ]] || exit 1
fi

export NIX_CONFIG="experimental-features = nix-command flakes
accept-flake-config = true
extra-substituters = https://nyx-cache.chaotic.cx/ https://noctalia.cachix.org
extra-trusted-public-keys = nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk= noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="

# Repo may be owned by another user (e.g. cloned as 'nixos', run as root)
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=safe.directory
export GIT_CONFIG_VALUE_0='*'

mkdir -p /mnt/tmp
export TMPDIR=/mnt/tmp

if ! command -v git >/dev/null; then
  git() { nix shell nixpkgs#git -c git "$@"; }
fi

# Figure out whether this script lives inside a git checkout of the repo
SRC_REPO=""
if [[ -n $SCRIPT_DIR ]]; then
  SRC_REPO="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
fi

mkdir -p "/mnt/home/$USER_NAME"

if [[ -d $REPO_DIR/.git ]]; then
  log "Using existing repo at $REPO_DIR"
elif [[ -n $SRC_REPO && -f $SRC_REPO/flake.nix ]]; then
  log "Copying local repo ($SRC_REPO) to $REPO_DIR"
  mkdir -p "$REPO_DIR"
  cp -a "$SRC_REPO/." "$REPO_DIR/"
else
  log "Cloning $REPO_URL"
  curl -fsI --max-time 10 https://github.com >/dev/null || die "no network / github unreachable"
  git clone "$REPO_URL" "$REPO_DIR"
fi

HW_DIR="$REPO_DIR/hosts/$HOST"
[[ -d $HW_DIR ]] || die "$HW_DIR does not exist - check HOST name / repo layout"

log "Generating hardware-configuration.nix"
nixos-generate-config --root /mnt --show-hardware-config >"$HW_DIR/hardware-configuration.nix"
# Flakes only see git-tracked files; -f in case it's gitignored
git -C "$REPO_DIR" add -f "hosts/$HOST/hardware-configuration.nix"

log "Installing $HOST (this takes a while)"
nixos-install --root /mnt --flake "$REPO_DIR#$HOST"

log "Set password for $USER_NAME"
until nixos-enter --root /mnt -c "passwd $USER_NAME"; do
  echo "Try again."
done

log "Fixing ownership of /home/$USER_NAME"
nixos-enter --root /mnt -c "chown -R $USER_NAME:$USER_GROUP /home/$USER_NAME && chmod 700 /home/$USER_NAME"

rm -rf /mnt/tmp
log "Done. Run 'reboot' (remove the install media)."
