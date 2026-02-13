#!/bin/bash
# Installation script for Python Type Check Hook

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Python Type Hint & Security Check Hook Installer${NC}"
echo "=================================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Let user choose CLI
echo "Which AI CLI do you want to use?"
echo "  1) Claude Code"
echo "  2) Codex CLI"
echo "  3) Cursor CLI"
echo ""
read -p "Choice (1-3): " CLI_CHOICE

case $CLI_CHOICE in
    1)
        AI_CLI="claude"
        AI_CMD="claude --print --model haiku"
        AI_NAME="Claude Code"
        ;;
    2)
        AI_CLI="codex"
        AI_CMD="codex exec"
        AI_NAME="Codex"
        ;;
    3)
        AI_CLI="cursor-agent"
        AI_CMD="cursor-agent -p"
        AI_NAME="Cursor"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

if ! command -v "$AI_CLI" &> /dev/null; then
    echo -e "${RED}✗ $AI_NAME is not installed${NC}"
    echo "Install it from:"
    case "$AI_CLI" in
        claude)       echo "  https://github.com/anthropics/claude-code" ;;
        codex)        echo "  https://github.com/openai/codex" ;;
        cursor-agent) echo "  https://cursor.com" ;;
    esac
    exit 1
fi

echo -e "${GREEN}✓${NC} $AI_NAME selected"
echo ""

# Function to browse directories
# All display goes to /dev/tty, only final selection goes to stdout
browse_directory() {
    local current_dir="$HOME/Code"
    [ ! -d "$current_dir" ] && current_dir="$HOME"
    
    while true; do
        clear > /dev/tty
        {
            echo -e "${CYAN}════════════════════════════════════════${NC}"
            echo -e "${CYAN}  Directory Browser${NC}"
            echo -e "${CYAN}════════════════════════════════════════${NC}"
            echo ""
            echo "Current: $current_dir"
            echo ""
            
            if [ -d "$current_dir/.git" ]; then
                echo -e "${GREEN}✓ This is a git repository${NC}"
                echo ""
            fi
            
            echo "Directories:"
            echo "─────────────────────────────────────────"
        } > /dev/tty
        
        local dirs=()
        local i=1
        
        if [ "$current_dir" != "/" ]; then
            echo "  0) ⬆️  .. (go to parent directory)" > /dev/tty
        fi
        
        local found_any=0
        while IFS= read -r dir; do
            [ -z "$dir" ] && continue
            local basename=$(basename "$dir")
            local is_git=""
            [ -d "$dir/.git" ] && is_git=" ${GREEN}[git]${NC}"
            printf "  %2d) 📁 %s%b\n" $i "$basename" "$is_git" > /dev/tty
            dirs+=("$dir")
            ((i++))
            found_any=1
        done < <(find "$current_dir" -maxdepth 1 -type d ! -path "$current_dir" ! -name ".*" 2>/dev/null | sort)
        
        if [ $found_any -eq 0 ]; then
            echo "  (no subdirectories)" > /dev/tty
        fi
        
        {
            echo "─────────────────────────────────────────"
            echo ""
            echo "Navigation:"
            echo "  • Type number → Enter that directory"
            if [ "$current_dir" != "/" ]; then
                echo "  • Type 0 → Go to parent directory"
            fi
            if [ -d "$current_dir/.git" ]; then
                echo "  • Type 's' → Select this git repository"
            fi
            echo "  • Type 'm' → Enter path manually"
            echo "  • Type 'q' → Quit installer"
            echo ""
        } > /dev/tty
        
        read -p "Choice: " choice < /dev/tty 2> /dev/tty
        
        case $choice in
            0)
                if [ "$current_dir" != "/" ]; then
                    current_dir="$(dirname "$current_dir")"
                fi
                ;;
            s|S)
                if [ -d "$current_dir/.git" ]; then
                    echo "$current_dir"
                    return 0
                else
                    echo -e "${RED}Not a git repository${NC}" > /dev/tty
                    read -p "Press Enter to continue..." < /dev/tty
                fi
                ;;
            m|M)
                echo "manual"
                return 0
                ;;
            q|Q)
                echo "" > /dev/tty
                echo "Installation cancelled" > /dev/tty
                exit 0
                ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
                    current_dir="${dirs[$((choice-1))]}"
                else
                    echo -e "${RED}Invalid choice${NC}" > /dev/tty
                    read -p "Press Enter to continue..." < /dev/tty
                fi
                ;;
        esac
    done
}

# Ask user for selection method
echo "How would you like to select the target repository?"
echo ""
echo "  1) Browse directories interactively"
echo "  2) Enter path manually"
echo ""
read -p "Choice (1-2): " CHOICE

case $CHOICE in
    1)
        RESULT=$(browse_directory)
        if [ "$RESULT" = "manual" ]; then
            clear
            echo ""
            read -p "Repository path: " TARGET_REPO
        else
            TARGET_REPO="$RESULT"
            clear
            echo -e "${GREEN}Selected:${NC} $TARGET_REPO"
            echo ""
        fi
        ;;
    2)
        read -p "Repository path: " TARGET_REPO
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Expand ~ to home directory
TARGET_REPO="${TARGET_REPO/#\~/$HOME}"

# Check if directory exists
if [ ! -d "$TARGET_REPO" ]; then
    echo -e "${RED}✗ Directory not found: $TARGET_REPO${NC}"
    exit 1
fi

# Check if it's a git repository
if [ ! -d "$TARGET_REPO/.git" ]; then
    echo -e "${RED}✗ Not a git repository: $TARGET_REPO${NC}"
    echo "Please initialize git first: git init"
    exit 1
fi

echo -e "${GREEN}✓${NC} Valid git repository: $TARGET_REPO"
echo ""

# Check if hook already exists
if [ -f "$TARGET_REPO/.git/hooks/pre-push" ]; then
    echo -e "${YELLOW}⚠️  Pre-push hook already exists${NC}"
    echo "Current hook will be backed up to: .git/hooks/pre-push.backup"
    while true; do
        read -p "Continue? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[YyNn]$ ]]; then break; fi
        echo -e "${RED}Invalid input. Please press y or n.${NC}"
    done
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    cp "$TARGET_REPO/.git/hooks/pre-push" "$TARGET_REPO/.git/hooks/pre-push.backup"
fi

# Install the hook
echo "Installing pre-push hook..."
cp "$SCRIPT_DIR/pre-push" "$TARGET_REPO/.git/hooks/pre-push"
chmod +x "$TARGET_REPO/.git/hooks/pre-push"
echo -e "${GREEN}✓${NC} Hook installed to: $TARGET_REPO/.git/hooks/pre-push"

HOOKS_DIR="$TARGET_REPO/.git/hooks"

# Check if prompt file already exists
if [ -f "$HOOKS_DIR/type-analysis-prompt.txt" ]; then
    echo -e "${YELLOW}⚠️  Prompt file already exists${NC}"
    while true; do
        read -p "Overwrite? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[YyNn]$ ]]; then break; fi
        echo -e "${RED}Invalid input. Please press y or n.${NC}"
    done
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$SCRIPT_DIR/type-analysis-prompt.txt" "$HOOKS_DIR/type-analysis-prompt.txt"
        echo -e "${GREEN}✓${NC} Prompt installed to: $HOOKS_DIR/type-analysis-prompt.txt"
    else
        echo "Skipping prompt installation"
    fi
else
    cp "$SCRIPT_DIR/type-analysis-prompt.txt" "$HOOKS_DIR/type-analysis-prompt.txt"
    echo -e "${GREEN}✓${NC} Prompt installed to: $HOOKS_DIR/type-analysis-prompt.txt"
fi

# Save CLI preference to config
echo "AI_CLI=$AI_CLI" > "$HOOKS_DIR/type-check-config.conf"
echo -e "${GREEN}✓${NC} Config saved to: $HOOKS_DIR/type-check-config.conf"

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "What was installed:"
echo "  • Pre-push hook: $HOOKS_DIR/pre-push"
echo "  • Analysis prompt: $HOOKS_DIR/type-analysis-prompt.txt"
echo "  • CLI config: $HOOKS_DIR/type-check-config.conf"
echo ""
echo "The hook will now run on every 'git push' and check for:"
echo "  ✓ Type hint issues"
echo "  ✓ Generic types (Dict[str, Any], etc.)"
echo "  ✓ Hardcoded secrets and API keys"
echo ""
echo "To disable temporarily: git push --no-verify"
echo "To uninstall: rm $TARGET_REPO/.git/hooks/pre-push"
echo ""

# Offer full analysis
PY_FILES=$(find "$TARGET_REPO" -name "*.py" -not -path "*/.*" -not -path "*/venv/*" -not -path "*/__pycache__/*" -not -path "*/node_modules/*" 2>/dev/null)
PY_COUNT=$(echo "$PY_FILES" | grep -c "\.py$" 2>/dev/null || echo "0")

if [ "$PY_COUNT" -gt 0 ]; then
    echo "─────────────────────────────────────────"
    echo ""
    echo -e "Found ${CYAN}$PY_COUNT Python files${NC} in this repository."
    echo ""
    while true; do
        read -p "Run a full type hint analysis now? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[YyNn]$ ]]; then break; fi
        echo -e "${RED}Invalid input. Please press y or n.${NC}"
    done

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${YELLOW}Running full analysis on all Python files...${NC}"
        echo ""

        # Get relative paths for cleaner output
        FILE_LIST=$(echo "$PY_FILES" | while read f; do echo "${f#$TARGET_REPO/}"; done)

        # Build prompt directly (sed breaks with multiline file lists)
        PROMPT_TEMPLATE=$(cat "$HOOKS_DIR/type-analysis-prompt.txt")
        PROMPT="${PROMPT_TEMPLATE//\{FILES\}/$FILE_LIST}"
        (cd "$TARGET_REPO" && $AI_CMD "$PROMPT")

        echo ""
        echo "─────────────────────────────────────────"
        echo -e "${GREEN}Full analysis complete!${NC}"
    fi
fi
