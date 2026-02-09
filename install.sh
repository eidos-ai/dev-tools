#!/usr/bin/env bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Header
clear
echo -e "${BOLD}${CYAN}"
echo "╔════════════════════════════════════════════════╗"
echo "║   Universal AGENTS.md Installer                ║"
echo "║   Share AI instructions across your team       ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo ""

# Function to print colored messages
info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

success() {
    echo -e "${GREEN}✓${RESET} $1"
}

warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

error() {
    echo -e "${RED}✗${RESET} $1"
}

# Function to create backup
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        success "Backed up existing file to: $backup"
    fi
}

# Function to ensure directory exists with user confirmation
ensure_directory() {
    local dir=$1
    local description=$2

    if [ ! -d "$dir" ]; then
        echo ""
        warning "Directory does not exist: $dir"
        read -p "$(echo -e ${CYAN}Create directory? \(y/n\): ${RESET})" create_dir
        if [[ ! $create_dir =~ ^[Yy]$ ]]; then
            error "Installation cancelled - directory creation declined"
            exit 1
        fi
        mkdir -p "$dir"
        success "Created directory: $dir"
    fi
}

# Function to handle file installation with conflict resolution
install_file() {
    local source=$1
    local target=$2
    local display_name=$3

    if [ ! -f "$source" ]; then
        error "$display_name not found in current directory"
        return 1
    fi

    if [ -f "$target" ]; then
        echo ""
        warning "File already exists: $target"
        echo ""
        echo -e "${BOLD}What would you like to do?${RESET}"
        echo "  1. Overwrite (backup existing file)"
        echo "  2. Append (add to existing file)"
        echo "  3. Cancel (skip this file)"
        echo ""

        while true; do
            read -p "$(echo -e ${CYAN}Choose option \(1-3\): ${RESET})" choice
            case $choice in
                1)
                    backup_file "$target"
                    cp "$source" "$target"
                    success "Installed $display_name → $target"
                    return 0
                    ;;
                2)
                    backup_file "$target"
                    echo "" >> "$target"
                    cat "$source" >> "$target"
                    success "Appended $display_name → $target"
                    return 0
                    ;;
                3)
                    warning "Skipped $display_name"
                    return 0
                    ;;
                *)
                    error "Invalid option. Please choose 1, 2, or 3."
                    ;;
            esac
        done
    else
        cp "$source" "$target"
        success "Installed $display_name → $target"
        return 0
    fi
}

# Step 1: Select IDE/CLI
echo -e "${BOLD}Step 1: Select your AI coding tool${RESET}"
echo ""
PS3="$(echo -e ${CYAN}Choose option \(1-4\): ${RESET})"
options=("Claude Code" "Windsurf" "Cursor" "Antigravity")
select tool in "${options[@]}"; do
    case $tool in
        "Claude Code"|"Windsurf"|"Cursor"|"Antigravity")
            success "Selected: $tool"
            echo ""
            break
            ;;
        *)
            error "Invalid option. Please try again."
            ;;
    esac
done

# Step 2: Select components to install
echo -e "${BOLD}Step 2: Select components to install${RESET}"
echo ""
info "Use numbers to toggle selection, 'a' for all, 'd' to done"
echo ""

# Component names and states (parallel arrays)
component_names=("AGENTS.md" "Skills")
component_states=(0 0)  # 0=off, 1=on

display_components() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║   Universal AGENTS.md Installer                ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
    echo -e "${BOLD}Selected tool: ${GREEN}$tool${RESET}"
    echo ""
    echo -e "${BOLD}Select components to install:${RESET}"
    echo ""

    for idx in 0 1; do
        local display_num=$((idx + 1))
        if [ "${component_states[$idx]}" -eq 1 ]; then
            echo -e "  ${GREEN}[✓]${RESET} $display_num. ${component_names[$idx]}"
        else
            echo -e "  [ ] $display_num. ${component_names[$idx]}"
        fi
    done

    echo ""
    echo -e "${CYAN}Options:${RESET}"
    echo "  1-2: Toggle component"
    echo "  a: Select all"
    echo "  d: Done (continue)"
    echo ""
}

while true; do
    display_components
    read -p "$(echo -e ${CYAN}Your choice: ${RESET})" choice

    case $choice in
        1|2)
            idx=$((choice - 1))
            if [ "${component_states[$idx]}" -eq 1 ]; then
                component_states[$idx]=0
            else
                component_states[$idx]=1
            fi
            ;;
        a|A)
            component_states=(1 1)
            ;;
        d|D)
            # Check if at least one component is selected
            selected_count=0
            for state in "${component_states[@]}"; do
                if [ "$state" -eq 1 ]; then
                    ((selected_count++))
                fi
            done

            if [ $selected_count -eq 0 ]; then
                clear
                display_components
                error "Please select at least one component"
                echo ""
                sleep 2
            else
                break
            fi
            ;;
        *)
            ;;
    esac
done

clear
echo -e "${BOLD}${CYAN}"
echo "╔════════════════════════════════════════════════╗"
echo "║   Installation Summary                         ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo ""
echo -e "${BOLD}Tool:${RESET} $tool"
echo -e "${BOLD}Components:${RESET}"
for idx in 0 1; do
    if [ "${component_states[$idx]}" -eq 1 ]; then
        echo -e "  ${GREEN}✓${RESET} ${component_names[$idx]}"
    fi
done
echo ""

# Dry run check
echo -e "${BOLD}Pre-installation Check:${RESET}"
echo ""

dry_run_errors=0

# Determine target directory based on tool
case $tool in
    "Claude Code")
        TARGET_DIR="$HOME/.claude"
        TARGET_FILE="$TARGET_DIR/CLAUDE.md"
        ;;
    "Windsurf")
        TARGET_DIR="$HOME/.codeium/windsurf"
        TARGET_FILE="$TARGET_DIR/AGENTS.md"
        ;;
    "Cursor")
        TARGET_DIR=""
        TARGET_FILE=""
        ;;
    "Antigravity")
        TARGET_DIR="$HOME/.gemini"
        TARGET_FILE="$TARGET_DIR/GEMINI.md"
        ;;
esac

# Check AGENTS.md
if [ "${component_states[0]}" -eq 1 ]; then
    if [ -f "AGENTS.md" ]; then
        success "Source file found: AGENTS.md"
        if [ "$tool" != "Cursor" ]; then
            if [ -f "$TARGET_FILE" ]; then
                warning "Target file exists: $TARGET_FILE (will prompt for action)"
            else
                info "Target file: $TARGET_FILE (will be created)"
            fi
        fi
    else
        error "Source file missing: AGENTS.md"
        dry_run_errors=$((dry_run_errors + 1))
    fi
fi

# Check skills directory
if [ "${component_states[1]}" -eq 1 ]; then
    if [ -d "skills" ]; then
        total_skill_count=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
        # Count skills excluding example-skill
        skill_count=$(find skills -mindepth 1 -maxdepth 1 -type d ! -name "example-skill" | wc -l | tr -d ' ')
        file_count=$(find skills -type f -name "SKILL.md" | wc -l | tr -d ' ')

        if [ "$total_skill_count" -eq 0 ]; then
            warning "Source directory found: skills/ but no skill subdirectories"
        elif [ "$skill_count" -eq 0 ]; then
            warning "Source directory found: skills/ but only example-skill (will be skipped)"
        else
            success "Source directory found: skills/ ($skill_count skills to install, example-skill excluded)"

            # Validate SKILL.md files exist
            if [ "$file_count" -lt "$total_skill_count" ]; then
                warning "Some skill directories missing SKILL.md files"
            fi

            # Check target directory for all tools (not just non-Cursor)
            if [ -n "$TARGET_DIR" ]; then
                skills_target="$TARGET_DIR/skills"
                if [ "$tool" == "Cursor" ]; then
                    skills_target="$HOME/.cursor/skills"
                fi

                if [ -d "$skills_target" ]; then
                    warning "Target directory exists: $skills_target (will merge)"
                else
                    info "Target directory: $skills_target (will be created)"
                fi
            fi
        fi
    else
        warning "Source directory missing: skills/ (will be skipped)"
    fi
fi

# Check target directory permissions (except Cursor)
if [ "$tool" != "Cursor" ] && [ -n "$TARGET_DIR" ]; then
    if [ -d "$TARGET_DIR" ]; then
        if [ -w "$TARGET_DIR" ]; then
            success "Target directory writable: $TARGET_DIR"
        else
            error "Target directory not writable: $TARGET_DIR"
            dry_run_errors=$((dry_run_errors + 1))
        fi
    else
        parent_dir=$(dirname "$TARGET_DIR")
        if [ -w "$parent_dir" ]; then
            success "Can create target directory: $TARGET_DIR"
        else
            error "Cannot create target directory: $TARGET_DIR (parent not writable)"
            dry_run_errors=$((dry_run_errors + 1))
        fi
    fi
fi

echo ""

# Exit if there are errors
if [ $dry_run_errors -gt 0 ]; then
    error "Pre-installation check failed with $dry_run_errors error(s)"
    echo ""
    exit 1
fi

# Confirm
read -p "$(echo -e ${CYAN}Proceed with installation? \(y/n\): ${RESET})" confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    error "Installation cancelled"
    exit 0
fi

echo ""
echo -e "${BOLD}Installing...${RESET}"
echo ""

# Installation logic
case $tool in
    "Claude Code")
        TARGET_DIR="$HOME/.claude"
        ensure_directory "$TARGET_DIR" "Claude Code configuration"

        # AGENTS.md (index 0)
        if [ "${component_states[0]}" -eq 1 ]; then
            install_file "AGENTS.md" "$TARGET_DIR/CLAUDE.md" "AGENTS.md"
        fi

        # Skills (index 1)
        if [ "${component_states[1]}" -eq 1 ]; then
            if [ -d "skills" ]; then
                mkdir -p "$TARGET_DIR/skills"
                skill_dirs=$(find skills -mindepth 1 -maxdepth 1 -type d)
                if [ -n "$skill_dirs" ]; then
                    installed_count=0
                    while IFS= read -r skill_dir; do
                        skill_name=$(basename "$skill_dir")
                        if [ "$skill_name" != "example-skill" ]; then
                            cp -r "$skill_dir" "$TARGET_DIR/skills/"
                            info "  → $skill_name"
                            ((installed_count++))
                        fi
                    done <<< "$skill_dirs"
                    if [ $installed_count -gt 0 ]; then
                        success "Installed skills → ~/.claude/skills/"
                    else
                        warning "No skills to install (only example-skill found)"
                    fi
                else
                    warning "No skill subdirectories found in skills/"
                fi
            else
                warning "skills/ directory not found, skipping"
            fi
        fi

        echo ""
        success "Installation complete for Claude Code!"
        ;;

    "Windsurf")
        TARGET_DIR="$HOME/.codeium/windsurf"
        ensure_directory "$TARGET_DIR" "Windsurf configuration"

        # AGENTS.md (index 0)
        if [ "${component_states[0]}" -eq 1 ]; then
            install_file "AGENTS.md" "$TARGET_DIR/AGENTS.md" "AGENTS.md"
        fi

        # Skills (index 1)
        if [ "${component_states[1]}" -eq 1 ]; then
            if [ -d "skills" ]; then
                mkdir -p "$TARGET_DIR/skills"
                skill_dirs=$(find skills -mindepth 1 -maxdepth 1 -type d)
                if [ -n "$skill_dirs" ]; then
                    installed_count=0
                    while IFS= read -r skill_dir; do
                        skill_name=$(basename "$skill_dir")
                        if [ "$skill_name" != "example-skill" ]; then
                            cp -r "$skill_dir" "$TARGET_DIR/skills/"
                            info "  → $skill_name"
                            ((installed_count++))
                        fi
                    done <<< "$skill_dirs"
                    if [ $installed_count -gt 0 ]; then
                        success "Installed skills → ~/.codeium/windsurf/skills/"
                    else
                        warning "No skills to install (only example-skill found)"
                    fi
                else
                    warning "No skill subdirectories found in skills/"
                fi
            else
                warning "skills/ directory not found, skipping"
            fi
        fi

        echo ""
        success "Installation complete for Windsurf!"
        ;;

    "Cursor")
        TARGET_DIR="$HOME/.cursor"
        ensure_directory "$TARGET_DIR" "Cursor configuration"

        # AGENTS.md (index 0) - Manual
        if [ "${component_states[0]}" -eq 1 ]; then
            echo ""
            echo -e "${BOLD}${YELLOW}AGENTS.md (Manual Installation):${RESET}"
            echo "  1. Open Cursor"
            echo "  2. Go to: Cursor Settings → Rules for AI"
            echo "  3. Copy the contents of: $(pwd)/AGENTS.md"
            echo "  4. Paste into the Rules text area"
            echo ""
            info "AGENTS.md requires manual installation via Settings UI"
            echo ""
        fi

        # Skills (index 1) - Automatic
        if [ "${component_states[1]}" -eq 1 ]; then
            if [ -d "skills" ]; then
                mkdir -p "$TARGET_DIR/skills"
                skill_dirs=$(find skills -mindepth 1 -maxdepth 1 -type d)
                if [ -n "$skill_dirs" ]; then
                    installed_count=0
                    while IFS= read -r skill_dir; do
                        skill_name=$(basename "$skill_dir")
                        if [ "$skill_name" != "example-skill" ]; then
                            cp -r "$skill_dir" "$TARGET_DIR/skills/"
                            info "  → $skill_name"
                            ((installed_count++))
                        fi
                    done <<< "$skill_dirs"
                    if [ $installed_count -gt 0 ]; then
                        success "Installed skills → ~/.cursor/skills/"
                    else
                        warning "No skills to install (only example-skill found)"
                    fi
                else
                    warning "No skill subdirectories found in skills/"
                fi
            else
                warning "skills/ directory not found, skipping"
            fi
        fi

        echo ""
        success "Installation complete for Cursor!"
        ;;

    "Antigravity")
        TARGET_DIR="$HOME/.gemini"
        ensure_directory "$TARGET_DIR" "Antigravity configuration"

        # AGENTS.md (index 0)
        if [ "${component_states[0]}" -eq 1 ]; then
            install_file "AGENTS.md" "$TARGET_DIR/GEMINI.md" "AGENTS.md"
        fi

        # Skills (index 1) - Not supported for Antigravity
        if [ "${component_states[1]}" -eq 1 ]; then
            echo ""
            warning "Skills/Workflows not supported for Antigravity"
            echo "  → Only GEMINI.md (global rules) installation is supported"
            echo ""
        fi

        echo ""
        success "Installation complete for Antigravity!"
        ;;
esac

echo ""
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${GREEN}    Installation process completed!${RESET}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${RESET}"
echo ""
