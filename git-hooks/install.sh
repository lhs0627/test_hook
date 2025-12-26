#!/bin/bash
###############################################################################
# Installation script for Git Chinese character check hooks
#
# Usage:
#   ./install.sh           Install all hooks (pre-commit + commit-msg)
#   ./install.sh --code    Install only pre-commit hook (code check)
#   ./install.sh --msg     Install only commit-msg hook (message check)
#   ./install.sh --all     Install all hooks
###############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
INSTALL_PRE_COMMIT=false
INSTALL_COMMIT_MSG=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --code|--pre-commit)
            INSTALL_PRE_COMMIT=true
            shift
            ;;
        --msg|--commit-msg)
            INSTALL_COMMIT_MSG=true
            shift
            ;;
        --all)
            INSTALL_PRE_COMMIT=true
            INSTALL_COMMIT_MSG=true
            shift
            ;;
        -h|--help)
            echo "Git Chinese Character Check Hooks - Installation"
            echo ""
            echo "Usage: $0 [OPTION]"
            echo ""
            echo "Options:"
            echo "  (no argument)  Install all hooks (default)"
            echo "  --all          Install all hooks"
            echo "  --code         Install only pre-commit hook (checks code files)"
            echo "  --msg          Install only commit-msg hook (checks commit messages)"
            echo "  -h, --help     Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0              # Install all hooks"
            echo "  $0 --code       # Install only code check"
            echo "  $0 --msg        # Install only message check"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option '$1'${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Default: install all if no specific option provided
if [ "$INSTALL_PRE_COMMIT" = false ] && [ "$INSTALL_COMMIT_MSG" = false ]; then
    INSTALL_PRE_COMMIT=true
    INSTALL_COMMIT_MSG=true
fi

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$SCRIPT_DIR"

# Find the Git repository root by navigating up from script directory
REPO_ROOT=""
CURRENT_DIR="$SCRIPT_DIR"

# Navigate up to find the directory containing .git
while [ "$CURRENT_DIR" != "/" ]; do
    PARENT_DIR="$(dirname "$CURRENT_DIR")"
    # Check if parent has .git directory or if parent is a .git directory
    if [ -d "$PARENT_DIR/.git" ] || [[ "$(basename "$PARENT_DIR")" == ".git" ]]; then
        # If we're inside .git, go one more level up
        if [[ "$(basename "$PARENT_DIR")" == ".git" ]]; then
            REPO_ROOT="$(dirname "$PARENT_DIR")"
        else
            REPO_ROOT="$PARENT_DIR"
        fi
        break
    fi
    CURRENT_DIR="$PARENT_DIR"
done

# Final validation
if [ -z "$REPO_ROOT" ] || [ ! -d "$REPO_ROOT/.git" ]; then
    echo -e "${RED}Error: Cannot find Git repository root!${NC}"
    echo -e "${YELLOW}Script location: $SCRIPT_DIR${NC}"
    echo -e "${YELLOW}Please run this script from within a Git repository.${NC}"
    exit 1
fi

GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Installing Git Chinese Check Hooks${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Repository root: ${YELLOW}$REPO_ROOT${NC}"
echo -e "${GREEN}Hooks directory: ${YELLOW}$GIT_HOOKS_DIR${NC}"
echo ""

# Create .git/hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

echo -e "${GREEN}Installing hooks...${NC}"

# Install pre-commit hook
if [ "$INSTALL_PRE_COMMIT" = true ]; then
    if [ ! -f "$HOOKS_DIR/pre-commit" ]; then
        echo -e "${RED}Error: pre-commit hook not found in $HOOKS_DIR${NC}"
        exit 1
    fi
    if [ -f "$GIT_HOOKS_DIR/pre-commit" ]; then
        echo -e "${YELLOW}Backing up existing pre-commit hook...${NC}"
        mv "$GIT_HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo -e "${GREEN}  [✓] pre-commit hook installed${NC}"
fi

# Install commit-msg hook
if [ "$INSTALL_COMMIT_MSG" = true ]; then
    if [ ! -f "$HOOKS_DIR/commit-msg" ]; then
        echo -e "${RED}Error: commit-msg hook not found in $HOOKS_DIR${NC}"
        exit 1
    fi
    if [ -f "$GIT_HOOKS_DIR/commit-msg" ]; then
        echo -e "${YELLOW}Backing up existing commit-msg hook...${NC}"
        mv "$GIT_HOOKS_DIR/commit-msg" "$GIT_HOOKS_DIR/commit-msg.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    cp "$HOOKS_DIR/commit-msg" "$GIT_HOOKS_DIR/commit-msg"
    chmod +x "$GIT_HOOKS_DIR/commit-msg"
    echo -e "${GREEN}  [✓] commit-msg hook installed${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Active hooks:${NC}"
if [ "$INSTALL_PRE_COMMIT" = true ]; then
    echo -e "  ${YELLOW}pre-commit${NC}  : Checks code files for Chinese characters"
fi
if [ "$INSTALL_COMMIT_MSG" = true ]; then
    echo -e "  ${YELLOW}commit-msg${NC}  : Checks commit messages for Chinese characters"
fi
echo ""
if [ "$INSTALL_PRE_COMMIT" = true ]; then
    echo -e "${BLUE}Code check features:${NC}"
    echo -e "  • Scans staged files before commit"
    echo -e "  • Excludes common i18n patterns (t(), \$t(), i18n.t())"
    echo -e "  • Reports exact line numbers and content"
    echo -e "  • Blocks commits with Chinese characters"
fi
echo ""
echo -e "${BLUE}Usage examples:${NC}"
echo -e "  ${YELLOW}git-hooks/install.sh${NC}         # Install all hooks"
echo -e "  ${YELLOW}git-hooks/install.sh --code${NC}   # Install only code check"
echo -e "  ${YELLOW}git-hooks/install.sh --msg${NC}    # Install only message check"
echo ""
echo -e "${BLUE}To uninstall:${NC}"
if [ "$INSTALL_PRE_COMMIT" = true ] && [ "$INSTALL_COMMIT_MSG" = true ]; then
    echo -e "  ${YELLOW}git-hooks/uninstall.sh${NC}"
    echo -e "  or: rm -f .git/hooks/pre-commit .git/hooks/commit-msg"
elif [ "$INSTALL_PRE_COMMIT" = true ]; then
    echo -e "  ${YELLOW}rm -f .git/hooks/pre-commit${NC}"
elif [ "$INSTALL_COMMIT_MSG" = true ]; then
    echo -e "  ${YELLOW}rm -f .git/hooks/commit-msg${NC}"
fi
echo ""
