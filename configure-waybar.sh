#!/bin/bash
# Helper script to add waybar-expressvpn-status to Waybar config
# This is optional - you can also manually add the config

set -e

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
BACKUP_FILE="$HOME/.config/waybar/config.jsonc.backup-$(date +%Y%m%d-%H%M%S)"

echo "Waybar ExpressVPN Status - Configuration Helper"
echo "================================================"
echo ""

# Check if Waybar config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Waybar config not found at $CONFIG_FILE"
    echo "Please create a Waybar config first."
    exit 1
fi

# Check if already configured
if grep -q '"custom/expressvpn"' "$CONFIG_FILE"; then
    echo "✓ ExpressVPN module is already configured in your Waybar config."
    echo ""
    echo "To reconfigure, edit: $CONFIG_FILE"
    echo "Example config: /usr/share/doc/waybar-expressvpn-status/examples/"
    exit 0
fi

echo "This script will:"
echo "  1. Backup your current config to: $BACKUP_FILE"
echo "  2. Show you the configuration to add"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Create backup
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✓ Backup created: $BACKUP_FILE"
echo ""

# Show the config to add
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Add this to your Waybar config manually:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. In the modules list (e.g., \"modules-right\"), add:"
echo '   "custom/expressvpn",'
echo ""
echo "2. Anywhere in the config object, add:"
cat /usr/share/doc/waybar-expressvpn-status/examples/waybar-config.jsonc
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "3. Reload Waybar:"
echo "   pkill -SIGUSR2 waybar"
echo ""
echo "Example config available at:"
echo "  /usr/share/doc/waybar-expressvpn-status/examples/"
echo ""
