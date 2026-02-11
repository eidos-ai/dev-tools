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

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}✗ Claude Code CLI not found${NC}"
    echo "Please install Claude Code first: https://github.com/anthropics/claude-code"
    exit 1
fi

echo -e "${GREEN}✓${NC} Claude Code CLI found"
echo ""

# Function to browse directories
browse_directory() {
    # Start from ~/Code if it exists, otherwise $HOME
    local current_dir="$HOME/Code"
    [ ! -d "$current_dir" ] && current_dir="$HOME"
    
    while true; do
        clear
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "${CYAN}  Directory Browser${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo ""
        echo "Current: $current_dir"
        echo ""
        
        # Check if current directory is a git repo
        if [ -d "$current_dir/.git" ]; then
            echo -e "${GREEN}✓ This is a git repository${NC}"
            echo ""
        fi
        
        echo "Directories:"
        echo "─────────────────────────────────────────"
        
        # List directories
        local dirs=()
        local i=1
        
        # Add parent directory option if not at root
        if [ "$current_dir" != "/" ]; then
            echo "  0) ⬆️  .. (go to parent directory)"
        fi
        
        # List subdirectories - handle both files and no files
        local found_any=0
        while IFS= read -r dir; do
            [ -z "$dir" ] && continue
            local basename=$(basename "$dir")
            local is_git=""
            [ -d "$dir/.git" ] && is_git=" ${GREEN}[git]${NC}"
            printf "  %2d) 📁 %s%b\n" $i "$basename" "$is_git"
            dirs+=("$dir")
            ((i++))
            found_any=1
        done < <(find "$current_dir" -maxdepth 1 -type d ! -path "$current_dir" ! -name ".*" 2>/dev/null | sort)
        
        if [ $found_any -eq 0 ]; then
            echo "  (no subdirectories)"
        fi
        
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
        
        read -p "Choice: " choice
        
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
                    echo ""
                    echo -e "${RED}Not a git repository${NC}"
                    read -p "Press Enter to continue..."
                fi
                ;;
            m|M)
                echo "manual"
                return 0
                ;;
            q|Q)
                echo ""
                echo "Installation cancelled"
                exit 0
                ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
                    current_dir="${dirs[$((choice-1))]}"
                else
                    echo ""
                    echo -e "${RED}Invalid choice${NC}"
                    read -p "Press Enter to continue..."
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
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
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

# Create .claude directory if it doesn't exist
mkdir -p "$TARGET_REPO/.claude"

# Check if prompt file already exists
if [ -f "$TARGET_REPO/.claude/type-analysis-prompt.txt" ]; then
    echo -e "${YELLOW}⚠️  Prompt file already exists${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping prompt installation"
    else
        cp "$SCRIPT_DIR/type-analysis-prompt.txt" "$TARGET_REPO/.claude/type-analysis-prompt.txt"
        echo -e "${GREEN}✓${NC} Prompt installed to: $TARGET_REPO/.claude/type-analysis-prompt.txt"
    fi
else
    cp "$SCRIPT_DIR/type-analysis-prompt.txt" "$TARGET_REPO/.claude/type-analysis-prompt.txt"
    echo -e "${GREEN}✓${NC} Prompt installed to: $TARGET_REPO/.claude/type-analysis-prompt.txt"
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "What was installed:"
echo "  • Pre-push hook: $TARGET_REPO/.git/hooks/pre-push"
echo "  • Analysis prompt: $TARGET_REPO/.claude/type-analysis-prompt.txt"
echo ""
echo "The hook will now run on every 'git push' and check for:"
echo "  ✓ Type hint issues"
echo "  ✓ Generic types (Dict[str, Any], etc.)"
echo "  ✓ Hardcoded secrets and API keys"
echo ""
echo "To test it:"
echo "  cd $TARGET_REPO"
echo "  # Make a commit with Python files"
echo "  git push"
echo ""
echo "To disable temporarily:"
echo "  git push --no-verify"
echo ""
echo "To uninstall:"
echo "  rm $TARGET_REPO/.git/hooks/pre-push"
echo "  rm $TARGET_REPO/.claude/type-analysis-prompt.txt"
