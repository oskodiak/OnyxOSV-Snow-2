#!/usr/bin/env bash
#
# OnyxOSV-Snow-2 System Foundation Installer
# Usage:
#   curl -L https://raw.githubusercontent.com/oskodiak/OnyxOSV-Snow-2/main/install | bash
#

set -euo pipefail

REPO_URL="https://github.com/oskodiak/OnyxOSV-Snow-2.git"
INSTALL_DIR="$HOME/onyxosv-snow-2"

# Colors for clean presentation
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║               OnyxOSV-Snow-2 Installer           ║"
    echo "║        Professional NixOS for Workstations       ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

status() {
    echo -e "${BLUE}▶${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

prepare_system() {
    status "Preparing system foundation..."

    # Require NixOS
    if [[ ! -f /etc/NIXOS ]]; then
        echo "Error: This installer must be run on NixOS."
        exit 1
    fi

    # Ensure git + python3 via nix-shell if missing
    if [[ -z "${OSV_DEPS_READY:-}" ]] && ( ! command -v git &>/dev/null || ! command -v python3 &>/dev/null ); then
        status "Missing git or python3, entering temporary nix-shell..."

        cat > /tmp/osv2-install-wrapper.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_URL="https://raw.githubusercontent.com/oskodiak/OnyxOSV-Snow-2/main/install"
export OSV_DEPS_READY=1
curl -L "$SCRIPT_URL" | bash
EOF

        chmod +x /tmp/osv2-install-wrapper.sh
        exec nix-shell -p git python3 --run "/tmp/osv2-install-wrapper.sh"
    fi

    success "System foundation ready"
}

setup_workspace() {
    status "Configuring workspace..."

    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
    fi

    git clone "$REPO_URL" "$INSTALL_DIR" &>/dev/null
    cd "$INSTALL_DIR"

    success "Workspace configured at $INSTALL_DIR"
}

get_tty_path() {
    if [[ -n "${TTY:-}" && -r "$TTY" ]]; then
        printf '%s' "$TTY"
        return 0
    fi

    if [[ -r /dev/tty ]]; then
        printf '%s' /dev/tty
        return 0
    fi

    echo "Error: Unable to locate a controlling terminal for the installer." >&2
    echo "Please run this installer from an interactive shell." >&2
    exit 1
}

launch_installer() {
    echo
    echo -e "${DIM}System ready. Launching OnyxOSV-Snow-2 Textual installer...${NC}"
    echo

    local tty_path
    tty_path=$(get_tty_path)

    # Attach Textual app to the real terminal TTY
    python3 installer-pipe/snow_installer.py < "$tty_path" > "$tty_path" 2>&1
}

main() {
    banner
    echo
    echo "Preparing system for OnyxOSV-Snow-2 installation."
    echo

    prepare_system
    setup_workspace
    launch_installer
}

main "$@"
