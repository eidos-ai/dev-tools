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

# Function to find git repositories
find_git_repos() {
    echo -e "${CYAN}Searching for git repositories...${NC}"
    
    # Common development directories
    SEARCH_DIRS=(
        "$HOME/Code"
        "$HOME/Projects"
        "$HOME/dev"
        "$HOME/Development"
        "$HOME/workspace"
        "$HOME/repos"
    )
    
    REPOS=()
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            while IFS= read -r repo; do
                REPOS+=("$repo")
            done < <(find "$dir" -maxdepth 3 -name ".git" -type d 2>/dev/null | sed 's|/.git$||')
        fi
    done
    
    echo "${REPOS[@]}"
}

# Ask user for selection method
echo "How would you like to select the target repository?"
echo ""
echo "  1) Browse detected git repositories"
echo "  2) Enter path manually"
echo ""
read -p "Choice (1-2): " CHOICE

case $CHOICE in
    1)
        # Find and display repositories
        REPOS=($(find_git_repos))
        
        if [ ${#REPOS[@]} -eq 0 ]; then
            echo -e "${YELLOW}No git repositories found in common locations${NC}"
            echo "Falling back to manual entry..."
            echo ""
            read -p "Repository path: " TARGET_REPO
        else
            echo ""
            echo -e "${CYAN}Found ${#REPOS[@]} git repositories:${NC}"
            echo ""
            
            for i in "${!REPOS[@]}"; do
                REPO_NAME=$(basename "${REPOS[$i]}")
                REPO_PATH="${REPOS[$i]}"
                printf "  %2d) %s\n" $((i+1)) "$REPO_PATH"
            done
            
            echo ""
            echo "  0) Enter path manually"
            echo ""
            read -p "Select repository (0-${#REPOS[@]}): " REPO_CHOICE
            
            if [ "$REPO_CHOICE" -eq 0 ]; then
                read -p "Repository path: " TARGET_REPO
            elif [ "$REPO_CHOICE" -ge 1 ] && [ "$REPO_CHOICE" -le ${#REPOS[@]} ]; then
                TARGET_REPO="${REPOS[$((REPO_CHOICE-1))]}"
                echo -e "${GREEN}Selected:${NC} $TARGET_REPO"
            else
                echo -e "${RED}Invalid selection${NC}"
                exit 1
            fi
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
