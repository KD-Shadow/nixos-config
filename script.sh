#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/KD-Shadow/nixos-config.git"
HOST="sh4dow-nixos"
USER_NAME="sh4dow"
USER_GROUP="users"
REPO_DIR="/mnt/home/$USER_NAME/nixos-config"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
die() {
  printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2
  exit 1
}

[[ $EUID -eq 0 ]] || die "run as root (sudo -i)"
mountpoint -q /mnt || die "/mnt is not a mountpoint - mount your target root first"
[[ -d /sys/firmware/efi ]] && ! mountpoint -q /mnt/boot &&
  die "booted in UEFI mode but /mnt/boot (ESP) is not mounted"
curl -fsI --max-time 10 https://github.com >/dev/null || die "no network / github unreachable"

if (($(awk '/MemTotal/{print $2}' /proc/meminfo) < 6000000)) && [[ -z "$(swapon --show --noheadings)" ]]; then
  echo "WARNING: <6 GB RAM and no swap active. The build may OOM. Consider: swapon /dev/<swap-partition>"
  read -rp "Continue anyway? [y/N] " ans
  [[ $ans == [yY]* ]] || exit 1
fi

export NIX_CONFIG="experimental-features = nix-command flakes"

mkdir -p /mnt/tmp
export TMPDIR=/mnt/tmp

if ! command -v git >/dev/null; then
  git() { nix shell nixpkgs#git -c git "$@"; }
fi

log "Cloning $REPO_URL"
mkdir -p "/mnt/home/$USER_NAME"
if [[ -d $REPO_DIR/.git ]]; then
  git -C "$REPO_DIR" pull --ff-only
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

HW_DIR="$REPO_DIR/hosts/$HOST"
[[ -d $HW_DIR ]] || die "$HW_DIR does not exist - check HOST name / repo layout"

log "Generating hardware-configuration.nix"
nixos-generate-config --root /mnt --show-hardware-config >"$HW_DIR/hardware-configuration.nix"
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
