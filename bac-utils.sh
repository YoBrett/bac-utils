#!/bin/bash
######################################################################################
## PROGRAM   : bac-utils.sh
## PROGRAMER : Brett Collingwood
## EMAIL-1   : brett@amperecomputing.com
## EMAIL-2   : brett.a.collingwood@gmail.com
## MUSE      : Kit
## VERSION   : 1.0.0
## DATE      : 2026-02-26
## PURPOSE   : This script installs Brett's preferred tools in a fresh debian based
##           : linux installation.
## #---------------------------------------------------------------------------------#
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
## INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
## PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
## HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
## SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
######################################################################################

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/log"
LOG_FILE="$LOG_DIR/bac-utils.log"
TOOLS=("net-tools" "tmux" "git" "htop" "btop" "stress-ng" "screenfetch" "lm-sensors" "coreutils" "bandwhich")

# Detect real user (for log file ownership)
REAL_USER="${SUDO_USER:-$USER}"
REAL_UID="${SUDO_UID:-$EUID}"
REAL_GID="${SUDO_GID:-$(id -g $REAL_USER)}"

# Create log directory and file with correct ownership
mkdir -p "$LOG_DIR"
chown "$REAL_USER:$REAL_GID" "$LOG_DIR"
touch "$LOG_FILE"
chown "$REAL_USER:$REAL_GID" "$LOG_FILE"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------------

log() {
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    # Print to screen with colors
    echo -e "${timestamp} - ${message}"
    # Strip colors, carriage returns, and other non-printables for log file
    # Keep only: Tab (\11), Newline (\12), and Printable ASCII (\40-\176)
    echo -e "${timestamp} - ${message}" | sed 's/\x1b\[[0-9;]*m//g' | tr -cd '\11\12\40-\176' >> "$LOG_FILE"
}

handle_error() {
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${RED}${timestamp} - [ERROR] ${message}${NC}"
    # Error message already plain text here, no need to strip unless color codes are in message
    echo "${timestamp} - [ERROR] ${message}" >> "$LOG_FILE"
    log "Pausing for 5 seconds..."
    sleep 5
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run as root.${NC}"
        exit 1
    fi
}

check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "debian" && "$ID" != "ubuntu" && "$ID_LIKE" != *"debian"* ]]; then
            echo -e "${RED}Error: This script is intended for Debian-based systems only.${NC}"
            echo -e "${YELLOW}Detected OS: $NAME ($ID)${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: Cannot determine OS. /etc/os-release not found.${NC}"
        exit 1
    fi
}

# ------------------------------------------------------------------------------------
# Main Execution
# ------------------------------------------------------------------------------------

check_root
check_os

# Initialize log file
touch "$LOG_FILE"
log "----------------------------------------"
log "Starting bac-utils installation v1.0.0"
log "----------------------------------------"

# Update package lists
log "Updating package lists..."
if apt-get update -y >> "$LOG_FILE" 2>&1; then
    log "${GREEN}Package list update successful.${NC}"
else
    handle_error "Failed to update package lists."
fi

# Install tools
log "Installing tools: ${TOOLS[*]}"

for tool in "${TOOLS[@]}"; do
    log "Attempting to install: $tool"
    
    # Check if already installed
    if dpkg -s "$tool" >/dev/null 2>&1; then
        log "${YELLOW}$tool is already installed. Skipping.${NC}"
        continue
    fi

    # Install with non-interactive mode
    if DEBIAN_FRONTEND=noninteractive apt-get install -y "$tool" >> "$LOG_FILE" 2>&1; then
        log "${GREEN}Successfully installed: $tool${NC}"
    else
        handle_error "Failed to install: $tool. Check log for details."
    fi
done

log "----------------------------------------"
log "Installation process complete."
log "Log saved to: $LOG_FILE"
log "----------------------------------------"
