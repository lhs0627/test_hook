#!/bin/bash
###############################################################################
# Uninstallation script for Git Chinese character check hooks
###############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

GIT_HOOKS_DIR=".git/hooks"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Uninstalling Git Chinese Check Hooks${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a Git repository!${NC}"
    exit 1
fi

echo -e "${YELLOW}Removing hooks...${NC}"

# Remove pre-commit hook
if [ -f "$GIT_HOOKS_DIR/pre-commit" ]; then
    rm -f "$GIT_HOOKS_DIR/pre-commit"
    echo -e "${GREEN}  [✓] pre-commit hook removed${NC}"
else
    echo -e "${YELLOW}  [!] pre-commit hook not found${NC}"
fi

# Remove commit-msg hook
if [ -f "$GIT_HOOKS_DIR/commit-msg" ]; then
    rm -f "$GIT_HOOKS_DIR/commit-msg"
    echo -e "${GREEN}  [✓] commit-msg hook removed${NC}"
else
    echo -e "${YELLOW}  [!] commit-msg hook not found${NC}"
fi

echo ""
echo -e "${GREEN}Hooks uninstalled successfully!${NC}"
echo ""
