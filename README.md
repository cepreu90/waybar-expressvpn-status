# waybar-expressvpn-status

A professional Waybar module for displaying ExpressVPN connection status with one-click connect/disconnect functionality.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

## ✨ Features

- 🎯 Real-time VPN status display in Waybar
- 🖱️ One-click connect/disconnect toggle
- 🔔 Desktop notifications for connection changes (optional)
- 🎨 Fully customizable icons and colors
- 📦 Easy installation via package managers

## 📦 Installation

### Arch Linux (AUR)

```bash
# Using yay
yay -S waybar-expressvpn-status

# Using paru
paru -S waybar-expressvpn-status

# Manual installation
git clone https://github.com/cepreu90/waybar-expressvpn-status.git
cd waybar-expressvpn-status
makepkg -si
```

### Debian/Ubuntu (.deb)

```bash
# Download the latest .deb from releases
wget https://github.com/cepreu90/waybar-expressvpn-status/releases/download/v1.0.0/waybar-expressvpn-status_1.0.0-1_all.deb

# Install
sudo dpkg -i waybar-expressvpn-status_1.0.0-1_all.deb
sudo apt-get install -f  # Install dependencies if needed
```

### Manual Installation

```bash
git clone https://github.com/cepreu90/waybar-expressvpn-status.git
cd waybar-expressvpn-status
sudo make install
```

### Uninstall

```bash
sudo make uninstall
```

## 🔧 Configuration

### Waybar Config

Add this to your `~/.config/waybar/config.jsonc`:

```jsonc
"custom/expressvpn": {
    "exec": "waybar-expressvpn-status",
    "interval": 3,
    "return-type": "json",
    "tooltip": true,
    "format": "{icon}",
    "format-icons": {
        "connected": "",
        "disconnected": "",
        "connecting": ""
    },
    "on-click": "waybar-expressvpn-toggle"
}
```

### Waybar Style

Add this to your `~/.config/waybar/style.css`:

```css
#custom-expressvpn.connected {
    color: rgb(48, 135, 48);
}

#custom-expressvpn.disconnected {
    color: #a55555;
}

#custom-expressvpn.connecting {
    color: #ffaa00;
}
```

### Custom Icons

You can customize the icons by changing the `format-icons` in your config:

```jsonc
"format-icons": {
    "connected": "🔒",
    "disconnected": "🔓",
    "connecting": "⏳"
}
```

Or use any Nerd Font icon you prefer.

## 🎯 Usage

Once installed and configured:

1. The module will automatically display your VPN status
2. Click the icon to toggle the VPN connection
3. Receive desktop notifications (if `libnotify` is installed)

## 📋 Requirements

- **Waybar** - The status bar
- **Node.js** - Runtime for the scripts
- **ExpressVPN** - VPN client (with CLI)
- **libnotify** (optional) - For desktop notifications

## 🔍 Troubleshooting

### Module not appearing

1. Check that ExpressVPN CLI is installed: `expressvpn --version`
2. Verify scripts are executable: `ls -l /usr/bin/waybar-expressvpn-*`
3. Test the status script manually: `waybar-expressvpn-status`

### Permission issues

If you get permission errors when toggling:

```bash
# Make sure your user can run expressvpn commands
sudo chmod u+s /usr/bin/expressvpn
```

### Notifications not working

Install libnotify:

```bash
# Arch
sudo pacman -S libnotify

# Debian/Ubuntu
sudo apt install libnotify-bin
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Waybar team for the excellent status bar
- ExpressVPN for their Linux client
- The Arch Linux and Debian communities

## 📞 Support

If you encounter any issues or have questions:

- Open an issue on [GitHub](https://github.com/cepreu90/waybar-expressvpn-status/issues)
- Check existing issues for solutions

---

**Made with ❤️ for the Linux community**