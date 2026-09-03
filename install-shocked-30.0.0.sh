#!/usr/bin/env bash
# Shocked 30 public installer wrapper.
set -Eeuo pipefail
umask 022

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NAME="shocked-console3_30.0.0-8+console3_amd64.deb"
EXPECTED_SHA256="503b656e2454a1d30b4921089abd96f4ed72937255c035f238ebfcb64841c7f0"
RELEASE_URL="https://github.com/chasemiracleborn/Shocked/releases/download/v30.0.0/${PACKAGE_NAME}"
SNAPSHOT_MODE="ask"
DEB_PATH=""
ALLOW_DOWNLOAD=1

usage() {
  cat <<'EOF'
Usage:
  bash ./install-shocked-30.0.0.sh [options] [package.deb]

Options:
  --snapshot=ask       Ask before creating available pre-install snapshot(s).
  --snapshot=none      Do not create a snapshot.
  --snapshot=snapper   Require a Snapper snapshot before install.
  --snapshot=timeshift Require a Timeshift snapshot before install.
  --snapshot=both      Require both Snapper and Timeshift snapshots.
  --no-download        Fail instead of downloading the canonical GitHub asset.
  -h, --help           Show this help.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --snapshot=*) SNAPSHOT_MODE="${arg#*=}" ;;
    --no-download) ALLOW_DOWNLOAD=0 ;;
    -h|--help) usage; exit 0 ;;
    -*) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    *)
      [[ -z "$DEB_PATH" ]] || { echo "Only one package path may be supplied." >&2; exit 2; }
      DEB_PATH="$arg"
      ;;
  esac
done

case "$SNAPSHOT_MODE" in
  ask|none|snapper|timeshift|both) ;;
  *) printf 'Invalid snapshot mode: %s\n' "$SNAPSHOT_MODE" >&2; exit 2 ;;
esac

STATE_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/shocked"
CACHE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/shocked"
mkdir -p "$STATE_ROOT" "$CACHE_ROOT"
INSTALL_LOG="$STATE_ROOT/installer-30.0.0.log"
exec > >(tee -a "$INSTALL_LOG") 2>&1

fail() {
  printf '\nSHOCKED INSTALLATION FAILED: %s\n' "$1" >&2
  printf 'Installer transcript: %s\n' "$INSTALL_LOG" >&2
  exit "${2:-1}"
}

for cmd in dpkg-deb dpkg apt-get sudo sha256sum realpath timeout; do
  command -v "$cmd" >/dev/null 2>&1 || fail "required command is unavailable: $cmd"
done

if [[ -z "$DEB_PATH" ]]; then
  for candidate in \
    "$SCRIPT_DIR/$PACKAGE_NAME" \
    "$SCRIPT_DIR/releases/30.0.0/$PACKAGE_NAME"
  do
    if [[ -f "$candidate" ]]; then
      DEB_PATH="$candidate"
      break
    fi
  done
fi

if [[ -z "$DEB_PATH" ]]; then
  ((ALLOW_DOWNLOAD)) || fail "package is not local and --no-download was requested"
  command -v curl >/dev/null 2>&1 || fail "curl is required to download the release package"
  DEB_PATH="$CACHE_ROOT/$PACKAGE_NAME"
  tmp="$DEB_PATH.part"
  rm -f -- "$tmp"
  printf 'Downloading canonical Shocked release...\n'
  curl --fail --location --proto '=https' --tlsv1.2 \
    --connect-timeout 15 --max-time 180 \
    --output "$tmp" "$RELEASE_URL" || fail "GitHub release download failed"
  mv -- "$tmp" "$DEB_PATH"
fi

DEB_PATH="$(realpath -m -- "$DEB_PATH")"
[[ -f "$DEB_PATH" ]] || fail "package file not found: $DEB_PATH"

actual_sha="$(sha256sum "$DEB_PATH" | awk '{print $1}')"
[[ "$actual_sha" == "$EXPECTED_SHA256" ]] || fail "SHA-256 mismatch for $DEB_PATH"

dpkg-deb --info "$DEB_PATH" >/dev/null 2>&1 || fail "not a readable Debian package: $DEB_PATH"
pkg="$(dpkg-deb -f "$DEB_PATH" Package)"
ver="$(dpkg-deb -f "$DEB_PATH" Version)"
arch="$(dpkg-deb -f "$DEB_PATH" Architecture)"
host_arch="$(dpkg --print-architecture)"
[[ "$pkg" == "shocked" ]] || fail "expected package shocked; found $pkg"
[[ "$arch" == "all" || "$arch" == "$host_arch" ]] || fail "architecture mismatch: package=$arch host=$host_arch"

printf 'Shocked installer\nPackage: %s %s (%s)\nFile: %s\nSHA256: %s\n' "$pkg" "$ver" "$arch" "$DEB_PATH" "$actual_sha"

create_snapper() {
  command -v snapper >/dev/null 2>&1 || return 127
  sudo timeout 60s snapper -c root create --type single --cleanup-algorithm number \
    --description "Pre-Shocked-$ver" >/dev/null
}

create_timeshift() {
  command -v timeshift >/dev/null 2>&1 || return 127
  sudo timeout 120s timeshift --create --comments "Pre-Shocked-$ver" --tags D >/dev/null
}

if [[ "$SNAPSHOT_MODE" == "ask" ]]; then
  available=()
  command -v snapper >/dev/null 2>&1 && available+=(Snapper)
  command -v timeshift >/dev/null 2>&1 && available+=(Timeshift)

  if ((${#available[@]})) && [[ -t 0 ]]; then
    printf '\nAvailable snapshot tools: %s\n' "${available[*]}"
    read -r -p 'Create pre-install snapshot(s) before continuing? [y/N] ' answer
    case "$answer" in
      [Yy]|[Yy][Ee][Ss])
        if ((${#available[@]} == 2)); then
          SNAPSHOT_MODE="both"
        elif [[ "${available[0]}" == "Snapper" ]]; then
          SNAPSHOT_MODE="snapper"
        else
          SNAPSHOT_MODE="timeshift"
        fi
        ;;
      *) SNAPSHOT_MODE="none" ;;
    esac
  else
    SNAPSHOT_MODE="none"
  fi
fi

sudo -v || fail "administrator authentication was cancelled or rejected"

case "$SNAPSHOT_MODE" in
  snapper)
    create_snapper || fail "Snapper snapshot requested but could not be created"
    ;;
  timeshift)
    create_timeshift || fail "Timeshift snapshot requested but could not be created"
    ;;
  both)
    create_snapper || fail "both snapshots requested, but Snapper snapshot failed"
    create_timeshift || fail "both snapshots requested, but Timeshift snapshot failed"
    ;;
esac

printf '\nInstalling Shocked %s...\n' "$ver"
set +e
sudo apt-get install "$DEB_PATH"
rc=$?
set -e
((rc == 0)) || fail "apt/dpkg exited with status $rc" "$rc"

installed="$(dpkg-query -W -f='${Version}' shocked 2>/dev/null || true)"
[[ "$installed" == "$ver" ]] || fail "installed version '${installed:-missing}' does not match '$ver'"

printf '\nShocked %s installed successfully.\n' "$installed"
if systemctl is-active --quiet shocked.service 2>/dev/null; then
  printf 'Backend service: active\n'
else
  printf 'Backend service: NOT ACTIVE\n'
  systemctl status shocked.service --no-pager -l || true
fi

if command -v shocked-ctl >/dev/null 2>&1; then
  printf '\nRunning Shocked doctor (diagnostic only):\n'
  shocked-ctl doctor || true
fi

printf '\nInstaller transcript: %s\n' "$INSTALL_LOG"
