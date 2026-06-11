#!/usr/bin/env bash

# ==============================================================================
# MLIR Installer (no sudo required)
# Written for FRoG (Firedrake Routines on GPU)
# Author: Divij Ghose <dtg125[at]ic[dot]ac[dot]uk>
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
MLIR_VERSION="19.1.0"
DOWNLOAD_DIR="${HOME}/.local/mlir/downloads"
INSTALL_DIR="${HOME}/.local/mlir"
MLIR_ARCHIVE=""   # populated by download_mlir()
MLIR_HOME=""      # populated by extract_mlir()
SHELL_RC=""       # populated by configure_environment()

MLIR_URL_LINUX_x86_64="https://github.com/llvm/llvm-project/releases/download/llvmorg-${MLIR_VERSION}/LLVM-${MLIR_VERSION}-Linux-X64.tar.xz"
MLIR_URL_LINUX_arm64="https://github.com/llvm/llvm-project/releases/download/llvmorg-${MLIR_VERSION}/LLVM-${MLIR_VERSION}-Linux-ARM64.tar.xz"
MLIR_URL_MACOS_arm64="https://github.com/llvm/llvm-project/releases/download/llvmorg-${MLIR_VERSION}/LLVM-${MLIR_VERSION}-macOS-ARM64.tar.xz"


# ------------------------------------------------------------------------------
# Detect OS and Architecture
# ------------------------------------------------------------------------------
detect_platform() {
    # --- 1. Detect OS ---
    local raw_os
    raw_os=$(uname -s 2>/dev/null)

    if [[ $? -ne 0 || -z "${raw_os}" ]]; then
        echo "[ERROR] Failed to detect operating system via 'uname -s'." >&2
        echo "        Please ensure 'uname' is available on your PATH." >&2
        exit 1
    fi

    case "${raw_os}" in
        Linux)  OS="linux" ;;
        Darwin) OS="macos" ;;
        *)
            echo "[ERROR] Unsupported operating system: '${raw_os}'." >&2
            echo "        This script only supports Linux and macOS." >&2
            exit 1
            ;;
    esac

    # --- 2. Detect Architecture ---
    local raw_arch
    raw_arch=$(uname -m 2>/dev/null)

    if [[ $? -ne 0 || -z "${raw_arch}" ]]; then
        echo "[ERROR] Failed to detect architecture via 'uname -m'." >&2
        echo "        Please ensure 'uname' is available on your PATH." >&2
        exit 1
    fi

    case "${raw_arch}" in
        x86_64)          ARCH="x86_64" ;;
        aarch64 | arm64) ARCH="arm64"  ;;
        *)
            echo "[ERROR] Unsupported architecture: '${raw_arch}'." >&2
            echo "        This script only supports x86_64 and arm64." >&2
            exit 1
            ;;
    esac

    # --- 3. Validate OS + Architecture combination ---
    if [[ "${OS}" == "macos" && "${ARCH}" == "x86_64" ]]; then
        echo "[ERROR] Unsupported platform: macOS x86_64 (Intel Mac)." >&2
        echo "        Only macOS arm64 (Apple Silicon) is supported." >&2
        exit 1
    fi

    echo "[INFO] Detected OS   : ${raw_os} -> ${OS}"
    echo "[INFO] Detected Arch : ${raw_arch} -> ${ARCH}"
    echo "[INFO] Platform      : ${OS}-${ARCH}"
}

# ------------------------------------------------------------------------------
# Download MLIR Binary
# ------------------------------------------------------------------------------
download_mlir() {
    # --- 1. Resolve the correct URL based on OS + architecture ---
    local url
    case "${OS}-${ARCH}" in
        linux-x86_64) url="${MLIR_URL_LINUX_x86_64}" ;;
        linux-arm64)  url="${MLIR_URL_LINUX_arm64}"  ;;
        macos-arm64)  url="${MLIR_URL_MACOS_arm64}"  ;;
        *)
            echo "[ERROR] Cannot resolve download URL for platform: '${OS}-${ARCH}'." >&2
            exit 1
            ;;
    esac

    # --- 2. Derive the filename from the URL and set the output path ---
    local filename
    filename=$(basename "${url}")
    MLIR_ARCHIVE="${DOWNLOAD_DIR}/${filename}"

    echo "[INFO] MLIR version : ${MLIR_VERSION}"
    echo "[INFO] Download URL : ${url}"
    echo "[INFO] Destination  : ${MLIR_ARCHIVE}"

    # --- 3. Create the download directory if it doesn't exist ---
    if ! mkdir -p "${DOWNLOAD_DIR}"; then
        echo "[ERROR] Failed to create download directory: '${DOWNLOAD_DIR}'" >&2
        exit 1
    fi

    # --- 4. Check that wget is available ---
    if ! command -v wget &>/dev/null; then
        echo "[ERROR] 'wget' was not found on your PATH." >&2
        echo "        Install it or load the appropriate module, then re-run." >&2
        exit 1
    fi

    # --- 5. Skip download if the archive already exists ---
    if [[ -f "${MLIR_ARCHIVE}" ]]; then
        echo "[INFO] Archive already exists, skipping download: ${MLIR_ARCHIVE}"
        return 0
    fi

    # --- 6. Download with wget ---
    echo "[INFO] Starting download..."
    if ! wget \
            --progress=bar:force \
            --timeout=60 \
            --tries=3 \
            --waitretry=5 \
            --output-document="${MLIR_ARCHIVE}.part" \
            "${url}"; then
        echo "[ERROR] Download failed for URL: ${url}" >&2
        rm -f "${MLIR_ARCHIVE}.part"
        exit 1
    fi

    # --- 7. Promote the .part file to the final archive only on success ---
    mv "${MLIR_ARCHIVE}.part" "${MLIR_ARCHIVE}"
    echo "[INFO] Download complete: ${MLIR_ARCHIVE}"
}

# ------------------------------------------------------------------------------
# Extract MLIR Archive
# ------------------------------------------------------------------------------
extract_mlir() {
    echo "[INFO] Preparing to extract: ${MLIR_ARCHIVE}"

    # --- 1. Verify the archive exists and is a regular file ---
    if [[ ! -f "${MLIR_ARCHIVE}" ]]; then
        echo "[ERROR] Archive not found: '${MLIR_ARCHIVE}'" >&2
        echo "        Run the download step first." >&2
        exit 1
    fi

    # --- 2. Check that tar and xz are available ---
    if ! command -v tar &>/dev/null; then
        echo "[ERROR] 'tar' was not found on your PATH." >&2
        echo "        Please ensure 'tar' is installed and re-run." >&2
        exit 1
    fi

    if ! command -v xz &>/dev/null; then
        echo "[ERROR] 'xz' was not found on your PATH." >&2
        echo "        Try loading it via your module system:" >&2
        echo "          module load xz" >&2
        echo "        Or install it to your home directory and add it to PATH." >&2
        exit 1
    fi

    # --- 3. Peek inside the archive to find the top-level directory name ---
    local top_level_dir

    # Use the second line which is guaranteed to have a slash, then cut on it.
    # The || true prevents set -e from killing the script if tar tf fails.
    top_level_dir=$(tar tf "${MLIR_ARCHIVE}" 2>/dev/null | head -2 | tail -1 | cut -d'/' -f1 || true)

    if [[ -z "${top_level_dir}" ]]; then
        echo "[ERROR] Could not read contents of archive: '${MLIR_ARCHIVE}'" >&2
        echo "        Run the manual diagnostics to investigate:" >&2
        echo "          tar tf ${MLIR_ARCHIVE} 2>&1 | head -5" >&2
        echo "        The file may be corrupt. Deleting it so it can be re-downloaded." >&2
        rm -f "${MLIR_ARCHIVE}"
        exit 1
    fi

    echo "[INFO] Resolved top-level dir: ${top_level_dir}"
    MLIR_HOME="${INSTALL_DIR}/${top_level_dir}"

    # --- 4. Skip extraction if the top-level directory already exists ---
    if [[ -d "${MLIR_HOME}" ]]; then
        echo "[INFO] Already extracted, skipping: ${MLIR_HOME}"
        return 0
    fi

    # --- 5. Create the install directory if it doesn't exist ---
    if ! mkdir -p "${INSTALL_DIR}"; then
        echo "[ERROR] Failed to create install directory: '${INSTALL_DIR}'" >&2
        exit 1
    fi

    # --- 6. Extract the archive ---
    echo "[INFO] Extracting to: ${INSTALL_DIR} (this may take a while)..."
    if ! tar xf "${MLIR_ARCHIVE}" -C "${INSTALL_DIR}"; then
        echo "[ERROR] Extraction failed for archive: '${MLIR_ARCHIVE}'" >&2
        echo "        The file may be corrupt. Deleting it so it can be re-downloaded." >&2
        rm -f "${MLIR_ARCHIVE}"
        rm -rf "${MLIR_HOME:?}"
        exit 1
    fi

    echo "[INFO] Extraction complete: ${MLIR_HOME}"
}

# ------------------------------------------------------------------------------
# Configure Environment
# ------------------------------------------------------------------------------
configure_environment() {
    local mlir_bin_dir="${MLIR_HOME}/bin"

    # --- 1. Verify the bin/ directory actually exists in the extracted tree ---
    if [[ ! -d "${mlir_bin_dir}" ]]; then
        echo "[ERROR] Expected bin/ directory not found: '${mlir_bin_dir}'" >&2
        echo "        The archive may have an unexpected layout." >&2
        exit 1
    fi

    local mlir_bin_dir="${MLIR_HOME}/bin"

    case "${SHELL}" in
        */bash) SHELL_RC="${HOME}/.bashrc"    ;;
        */zsh)  SHELL_RC="${HOME}/.zshrc"     ;;
        */fish) SHELL_RC="${HOME}/.config/fish/config.fish" ;;
        *)
            echo "[WARN] Unrecognised shell '${SHELL}', defaulting to ~/.bashrc" >&2
            SHELL_RC="${HOME}/.bashrc"
            ;;
    esac





    # --- 3. Skip if the export line is already present (idempotent) ---
    if grep -qF "${mlir_bin_dir}" "${SHELL_RC}" 2>/dev/null; then
        echo "[INFO] PATH already configured in ${SHELL_RC}, skipping."
    else
        {
            echo ""
            echo "# Added by MLIR installer"
            echo "export PATH=\"${mlir_bin_dir}:\$PATH\""
        } >> "${SHELL_RC}"
        echo "[INFO] Added to ${SHELL_RC}:"
        echo "         export PATH=\"${mlir_bin_dir}:\$PATH\""
    fi

    # --- 5. Also export into the current shell session so it's usable immediately ---
    export PATH="${mlir_bin_dir}:${PATH}"
    echo "[INFO] PATH updated for this session."
}

# ------------------------------------------------------------------------------
# Verify Installation
# ------------------------------------------------------------------------------
verify_installation() {
    local mlir_bin_dir="${MLIR_HOME}/bin"
    local mlir_opt="${mlir_bin_dir}/mlir-opt"

    echo ""
    echo "[INFO] Verifying installation..."

    # --- 1. Check the mlir-opt binary exists and is executable ---
    if [[ ! -x "${mlir_opt}" ]]; then
        echo "[ERROR] mlir-opt binary not found or not executable: '${mlir_opt}'" >&2
        echo "        The archive may be source-only and require building from source." >&2
        echo "        See: https://mlir.llvm.org/getting_started/" >&2
        exit 1
    fi

    # --- 2. Run mlir-opt --version and capture output ---
    local version_output
    if ! version_output=$("${mlir_opt}" --version 2>&1); then
        echo "[ERROR] mlir-opt --version failed unexpectedly." >&2
        echo "        Output: ${version_output}" >&2
        echo "        The binary may be corrupt or incompatible with this system." >&2
        exit 1
    fi

    # --- 3. Sanity-check that the output actually mentions LLVM/MLIR ---
    if ! echo "${version_output}" | grep -qiE "llvm|mlir"; then
        echo "[WARN] mlir-opt --version output did not mention LLVM or MLIR." >&2
        echo "       Output: ${version_output}" >&2
    fi

    # --- 4. Cross-check the reported version against the expected version ---
    if ! echo "${version_output}" | grep -qF "${MLIR_VERSION}"; then
        echo "[WARN] Reported version does not match expected ${MLIR_VERSION}." >&2
        echo "       Output: ${version_output}" >&2
    else
        echo "[INFO] Version check passed: ${MLIR_VERSION}"
    fi

    echo "[INFO] mlir-opt --version output:"
    echo "       ${version_output}"

    echo ""
    echo "================================================================"
    echo "  MLIR ${MLIR_VERSION} successfully installed!"
    echo "  Location : ${MLIR_HOME}"
    echo "  Binary   : ${mlir_opt}"
    echo "  To use in new shells, reload your config:"
    echo "    source ${SHELL_RC}"
    echo "================================================================"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    detect_platform
    download_mlir
    extract_mlir
    configure_environment
    verify_installation
}

main "$@"