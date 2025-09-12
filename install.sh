#!/bin/bash

# Vim Window Navigation Installation Script
# This script helps install the vim window navigation configuration for Hammerspoon

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Hammerspoon is installed
check_hammerspoon() {
    print_status "Checking if Hammerspoon is installed..."
    
    if [ -d "/Applications/Hammerspoon.app" ]; then
        print_success "Hammerspoon is installed"
        return 0
    else
        print_error "Hammerspoon is not installed"
        print_status "Please install Hammerspoon from https://www.hammerspoon.org/"
        return 1
    fi
}

# Check if Hammerspoon config directory exists
check_config_dir() {
    print_status "Checking Hammerspoon configuration directory..."
    
    local config_dir="$HOME/.hammerspoon"
    
    if [ -d "$config_dir" ]; then
        print_success "Configuration directory exists: $config_dir"
        
        # Check if there's an existing init.lua
        if [ -f "$config_dir/init.lua" ]; then
            print_warning "Existing init.lua found in $config_dir"
            echo "What would you like to do?"
            echo "1) Backup existing config and replace with vim window navigation"
            echo "2) Add vim window navigation to existing config"
            echo "3) Cancel installation"
            read -p "Enter your choice (1-3): " choice
            
            case $choice in
                1)
                    backup_existing_config
                    install_new_config
                    ;;
                2)
                    add_to_existing_config
                    ;;
                3)
                    print_status "Installation cancelled"
                    exit 0
                    ;;
                *)
                    print_error "Invalid choice"
                    exit 1
                    ;;
            esac
        else
            install_new_config
        fi
    else
        print_status "Creating configuration directory: $config_dir"
        mkdir -p "$config_dir"
        install_new_config
    fi
}

# Backup existing configuration
backup_existing_config() {
    local config_dir="$HOME/.hammerspoon"
    local backup_file="$config_dir/init.lua.backup.$(date +%Y%m%d_%H%M%S)"
    
    print_status "Backing up existing configuration to: $backup_file"
    cp "$config_dir/init.lua" "$backup_file"
    print_success "Backup created: $backup_file"
}

# Install new configuration
install_new_config() {
    local config_dir="$HOME/.hammerspoon"
    
    print_status "Installing vim window navigation configuration..."
    cp "init.lua" "$config_dir/init.lua"
    print_success "Configuration installed to: $config_dir/init.lua"
}

# Add to existing configuration
add_to_existing_config() {
    local config_dir="$HOME/.hammerspoon"
    local current_dir=$(pwd)
    
    print_status "Adding vim window navigation to existing configuration..."
    
    # Add a comment and include statement to the existing config
    cat >> "$config_dir/init.lua" << EOF

-- Vim Window Navigation
-- Added by install script on $(date)
dofile("$current_dir/init.lua")
EOF
    
    print_success "Vim window navigation added to existing configuration"
}

# Check permissions
check_permissions() {
    print_status "Checking accessibility permissions..."
    
    # This is a basic check - the user will need to manually grant permissions
    print_warning "Please ensure Hammerspoon has accessibility permissions:"
    echo "1. Open System Preferences > Security & Privacy > Privacy > Accessibility"
    echo "2. Add Hammerspoon if it's not already listed"
    echo "3. Make sure the checkbox next to Hammerspoon is checked"
    echo ""
    read -p "Press Enter when you've checked the permissions..."
}

# Reload Hammerspoon configuration
reload_hammerspoon() {
    print_status "Reloading Hammerspoon configuration..."
    
    # Try to reload via osascript
    if command -v osascript >/dev/null 2>&1; then
        osascript -e 'tell application "Hammerspoon" to reload config' 2>/dev/null || {
            print_warning "Could not automatically reload Hammerspoon"
            print_status "Please manually reload the configuration:"
            echo "1. Open Hammerspoon"
            echo "2. Press Cmd+Ctrl+R or click 'Reload Config'"
        }
    else
        print_warning "osascript not available, please manually reload Hammerspoon"
    fi
}

# Test configuration
test_configuration() {
    print_status "Testing configuration..."
    
    echo "The following keybindings should now work:"
    echo "• Cmd+Ctrl+h - Focus window left"
    echo "• Cmd+Ctrl+j - Focus window down"
    echo "• Cmd+Ctrl+k - Focus window up"
    echo "• Cmd+Ctrl+l - Focus window right"
    echo ""
    echo "Additional keybindings:"
    echo "• Cmd+Ctrl+Shift+hjkl - Move windows"
    echo "• Cmd+Ctrl+Ctrl+hjkl - Resize windows"
    echo ""
    read -p "Press Enter to continue..."
}

# Main installation function
main() {
    echo "=========================================="
    echo "Vim Window Navigation for Hammerspoon"
    echo "=========================================="
    echo ""
    
    # Check prerequisites
    if ! check_hammerspoon; then
        exit 1
    fi
    
    # Install configuration
    check_config_dir
    
    # Check permissions
    check_permissions
    
    # Reload configuration
    reload_hammerspoon
    
    # Test configuration
    test_configuration
    
    echo ""
    print_success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Make sure Hammerspoon is running"
    echo "2. Test the keybindings with multiple windows open"
    echo "3. Check the README.md for configuration options"
    echo "4. Modify the hotkey_modifier in init.lua if needed"
    echo ""
    echo "For support, check the README.md file or create an issue on GitHub."
}

# Run main function
main "$@"
