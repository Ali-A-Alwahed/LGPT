#!/usr/bin/env bash
#
# install-lgpt.sh — add the LGPT License v1.0 to a project.
#
#   curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh | bash
#
# Zero dependencies. Runs on bash 3.2+ and any POSIX shell with curl or wget.
#
set -euo pipefail

# --- Pinned integrity data -------------------------------------------------
# The SHA-256 below is the digest of the canonical LICENSE.txt as published at
# https://github.com/Ali-A-Alwahed/LGPT. If it does not match, the script aborts
# without writing anything. To re-pin after an intentional license revision,
# run: sha256sum LICENSE.txt
LGPT_VERSION="1.0"
LGPT_SHA256="89d54b0cf5852c9212d80729c802a5371b41e8ce1499a32f8133382519c62b37"
LGPT_RAW_URL="https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/LICENSE.txt"
LGPT_REPO_URL="https://github.com/Ali-A-Alwahed/LGPT"
LGPT_COPYRIGHT_HOLDER="Ali A Alwahed"
LGPT_PROFILE_URL="https://github.com/Ali-A-Alwahed"
LGPT_ORG="Sonzaistudios"
LGPT_WEBSITE="https://sonzaistudios.org"
# ---------------------------------------------------------------------------

LICENSE_FILE="LICENSE.txt"
NOTICE_FILE="NOTICE"

TARGET_DIR="."
PROJECT_NAME=""
ASSUME_YES="false"
VERIFY="true"
FORCE="false"
MODE="install"

TMP_FILE=""
cleanup() {
    if [ -n "$TMP_FILE" ]; then rm -f "$TMP_FILE"; fi
    return 0
}
trap cleanup EXIT

# --- Output helpers --------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
    C_RED=$'\033[31m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_CYAN=$'\033[36m'
else
    C_RESET=""; C_BOLD=""; C_DIM=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_CYAN=""
fi

info()    { printf '%s\n' "${C_CYAN}::${C_RESET} $*"; }
success() { printf '%s\n' "${C_GREEN}✓${C_RESET} $*"; }
warn()    { printf '%s\n' "${C_YELLOW}!${C_RESET} $*" >&2; }
err()     { printf '%s\n' "${C_RED}✗${C_RESET} $*" >&2; }
die()     { err "$*"; exit 1; }

usage() {
    cat <<'HELP_EOF'
install-lgpt.sh — add the LGPT License v1.0 to your project.

install-lgpt.sh [options]

OPTIONS
    --dir <path>     Target directory. Default: current directory.
    --name <name>    Project name recorded in the NOTICE file.
                     Default: the target directory's basename.
    --yes, -y        Do not prompt for confirmation.
    --force          Overwrite an existing LICENSE.txt even if it is NOT an
                     LGPT license. Off by default: the script will refuse to
                     destroy another project's license.
    --verify         Verify the SHA-256 digest (on by default).
    --no-verify      Skip checksum verification. Not recommended.
    --uninstall      Remove the LGPT LICENSE and NOTICE files.
    --help, -h       Show this help.
    --version, -v    Print the license version handled by this script.

EXAMPLES
    # Add LGPT to the current project
    curl -fsSL https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/scripts/install-lgpt.sh | bash

    # Add to a specific project, unattended, with verification enforced
    curl -fsSL .../install-lgpt.sh | bash -s -- --dir ~/code/my-app --name my-app --yes

    # Remove it
    bash install-lgpt.sh --dir ~/code/my-app --uninstall

LICENSE
    The license text itself is licensed under CC BY 4.0 so that it may be freely
    copied and shared. This script is licensed under the MIT License.
HELP_EOF
}

# --- Argument parsing ------------------------------------------------------
while [ $# -gt 0 ]; do
    case "$1" in
        --dir)        [ $# -ge 2 ] || die "--dir requires a value"; TARGET_DIR="$2"; shift 2 ;;
        --dir=*)      TARGET_DIR="${1#*=}"; shift ;;
        --name)       [ $# -ge 2 ] || die "--name requires a value"; PROJECT_NAME="$2"; shift 2 ;;
        --name=*)     PROJECT_NAME="${1#*=}"; shift ;;
        -y|--yes)     ASSUME_YES="true"; shift ;;
        --force)      FORCE="true"; shift ;;
        --verify)     VERIFY="true"; shift ;;
        --no-verify)  VERIFY="false"; shift ;;
        --uninstall)  MODE="uninstall"; shift ;;
        -h|--help)    usage; exit 0 ;;
        -v|--version) printf 'LGPT License v%s\n' "$LGPT_VERSION"; exit 0 ;;
        *)            err "Unknown option: $1"; printf '\n' >&2; usage >&2; exit 2 ;;
    esac
done

# --- Preflight -------------------------------------------------------------
HAS_SHA="false"
# sha256_of FILE -> lowercase hex SHA-256 digest on stdout.
#
# Note: bare `shasum` defaults to SHA-1 on most systems (it is a Perl script,
# not GNU coreutils), so the digest algorithm must always be named explicitly.
sha256_of() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        return 1
    fi
}
if command -v sha256sum >/dev/null 2>&1 || command -v shasum >/dev/null 2>&1; then
    HAS_SHA="true"
fi
[ "$HAS_SHA" = "false" ] && [ "$VERIFY" = "true" ] && die "Neither sha256sum nor shasum found. Re-run with --no-verify to skip verification."

# Prefer curl: it is the only one of the two that can be pinned to HTTPS-only
# via --proto, which blocks a downgrade redirect to http:// or file://.
DOWNLOADER=""
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
else
    die "Neither curl nor wget found. Install one, or download ${LGPT_RAW_URL} manually."
fi

[ -d "$TARGET_DIR" ] || die "Target directory does not exist: $TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [ -z "$PROJECT_NAME" ]; then
    if git -C "$TARGET_DIR" rev-parse --git-dir >/dev/null 2>&1; then
        PROJECT_NAME="$(basename "$(git -C "$TARGET_DIR" rev-parse --show-toplevel)")"
    else
        PROJECT_NAME="$(basename "$TARGET_DIR")"
    fi
fi

# --- Confirmation ----------------------------------------------------------
confirm() {
    [ "$ASSUME_YES" = "true" ] && return 0
    [ -t 0 ] || die "Refusing to overwrite without a TTY. Re-run with --yes."
    printf '%s' "$1 [y/N] "
    read -r reply
    case "$reply" in [yY]|[yY][eE][sS]) return 0 ;; *) return 1 ;; esac
}

# --- Uninstall -------------------------------------------------------------
if [ "$MODE" = "uninstall" ]; then
    printf '%s\n' "${C_BOLD}Removing LGPT from${C_RESET} ${C_BOLD}${TARGET_DIR}${C_RESET}"
    for f in "$LICENSE_FILE" "$NOTICE_FILE"; do
        path="${TARGET_DIR}/${f}"
        if [ -f "$path" ]; then
            if grep -q "LGPT License" "$path" 2>/dev/null; then
                confirm "  ${C_DIM}delete${C_RESET} ${f}?" || { warn "Skipped ${f}"; continue; }
                rm -f "$path"
                success "Removed ${f}"
            else
                warn "${f} exists but does not look like an LGPT file. Left untouched."
            fi
        else
            info "${f} not present. Nothing to do."
        fi
    done
    printf '\n%s\n' "${C_DIM}Note: removing these files does not retroactively release anything you already distributed under LGPT.${C_RESET}"
    exit 0
fi

# --- Install ---------------------------------------------------------------
printf '\n%s\n' "${C_BOLD}LGPT License v${LGPT_VERSION} installer${C_RESET}"
printf '%s\n\n' "${C_DIM}${LGPT_REPO_URL}${C_RESET}"
printf '%s\n' "  ${C_BOLD}Target:${C_RESET}  ${TARGET_DIR}"
printf '%s\n' "  ${C_BOLD}Project:${C_RESET} ${PROJECT_NAME}"
printf '%s\n\n' "  Will write:"
printf '%s\n' "    ${LICENSE_FILE}"
printf '%s\n\n' "    ${NOTICE_FILE}"

confirm "  Proceed?" || { info "Cancelled."; exit 0; }
printf '\n'

TMP_FILE="$(mktemp "${TMPDIR:-/tmp}/lgpt-license.XXXXXX")"

info "Downloading license text..."
if [ "$DOWNLOADER" = "curl" ]; then
    curl -fsSL --retry 3 --retry-delay 2 --proto '=https' --tlsv1.2 \
        -o "$TMP_FILE" "$LGPT_RAW_URL" \
        || die "Download failed. Check your network connection, or fetch ${LGPT_RAW_URL} manually."
else
    wget -q --https-only --tries=3 -O "$TMP_FILE" "$LGPT_RAW_URL" \
        || die "Download failed. Check your network connection, or fetch ${LGPT_RAW_URL} manually."
fi

[ -s "$TMP_FILE" ] || die "Downloaded file is empty. Aborting."

# --- Integrity verification ---
if [ "$VERIFY" = "true" ]; then
    info "Verifying SHA-256 digest..."
    actual="$(sha256_of "$TMP_FILE")"
    if [ "$actual" != "$LGPT_SHA256" ]; then
        err "Checksum MISMATCH — refusing to write anything."
        printf '  expected: %s\n' "$LGPT_SHA256" >&2
        printf '  actual:   %s\n\n' "$actual" >&2
        die "This could mean a corrupted download, an interception, or that the license was revised. Inspect the source, then re-run with --no-verify only if you have verified it yourself."
    fi
    success "Checksum verified."
else
    warn "Checksum verification SKIPPED. You are trusting the download."
fi

# --- Sanity check that this really is the license --------------------------
if ! grep -q "LGPT License v" "$TMP_FILE" 2>/dev/null; then
    die "Downloaded content does not look like an LGPT license. Aborting."
fi

# --- Write LICENSE.txt -----------------------------------------------------
license_path="${TARGET_DIR}/${LICENSE_FILE}"
if [ -f "$license_path" ]; then
    if cmp -s "$TMP_FILE" "$license_path"; then
        success "${LICENSE_FILE} already present and identical. Left as is."
    elif grep -q "LGPT License v" "$license_path" 2>/dev/null; then
        # Already an LGPT license, just an older revision. Safe to upgrade.
        warn "${LICENSE_FILE} exists and is an older/different LGPT revision."
        confirm "  ${C_DIM}upgrade${C_RESET} it?" \
            || die "Aborted. ${LICENSE_FILE} was not modified."
        cp "$TMP_FILE" "$license_path"
        chmod 644 "$license_path" 2>/dev/null || true
        success "Upgraded ${LICENSE_FILE}"
    else
        # A foreign license. Never clobber this, even with --yes: the user
        # most likely copied the wrong repo, or this script is in the wrong dir.
        err "${LICENSE_FILE} exists and is NOT an LGPT license."
        printf '%s\n' "  detected: $(head -n 1 "$license_path" 2>/dev/null | cut -c1-70)" >&2
        if [ "$FORCE" = "true" ]; then
            warn "  --force given. Overwriting anyway."
            cp "$TMP_FILE" "$license_path"
            chmod 644 "$license_path" 2>/dev/null || true
            success "Overwrote ${LICENSE_FILE}"
        else
            die "Refusing to overwrite another project's license.
       Back up or delete ${LICENSE_FILE} first, then re-run.
       To override deliberately, re-run with --force."
        fi
    fi
else
    cp "$TMP_FILE" "$license_path"
    chmod 644 "$license_path" 2>/dev/null || true
    success "Wrote ${LICENSE_FILE}"
fi

# --- Write NOTICE ----------------------------------------------------------
notice_path="${TARGET_DIR}/${NOTICE_FILE}"
if [ -f "$notice_path" ]; then
    warn "${NOTICE_FILE} already exists. Left untouched — merge the notice manually if needed."
else
    cat > "$notice_path" <<NOTICE_EOF
${PROJECT_NAME}
Copyright (c) 2026 ${PROJECT_NAME} contributors

This product includes software developed by ${LGPT_COPYRIGHT_HOLDER} and
licensed under the LGPT License v1.0.

------------------------------------------------------------------------

Developer:
${LGPT_COPYRIGHT_HOLDER}

GitHub Profile:
${LGPT_PROFILE_URL}

Organization:
${LGPT_ORG}

Website:
${LGPT_WEBSITE}

License:
LGPT License v${LGPT_VERSION}

GitHub Link:
${LGPT_REPO_URL}

------------------------------------------------------------------------

Special Thanks To:
${LGPT_COPYRIGHT_HOLDER} for creating the LGPT License and establishing the
licensing framework used by this software.
NOTICE_EOF
    success "Wrote ${NOTICE_FILE}"
fi

# --- Next steps ------------------------------------------------------------
printf '\n%s\n\n' "${C_BOLD}${C_GREEN}Done.${C_RESET}${C_BOLD} ${PROJECT_NAME} is now licensed under LGPT v${LGPT_VERSION}.${C_RESET}"
cat <<NEXT
${C_BOLD}Next steps${C_RESET}
  1. Add the badge to your README:

       [![License: LGPT v1.0](https://img.shields.io/badge/License-LGPT%20v1.0-8A2BE2?style=for-the-badge)](${LGPT_REPO_URL})

  2. Commit the files:

       git add ${LICENSE_FILE} ${NOTICE_FILE}
       git commit -m "Add LGPT License v${LGPT_VERSION}"
       git push

  3. If you distribute the software in source headers, add:

       SPDX-License-Identifier: LicenseRef-LGPT-${LGPT_VERSION}

${C_DIM}Full guide: ${LGPT_REPO_URL}/blob/main/docs/ADOPTING.md${C_RESET}
NEXT