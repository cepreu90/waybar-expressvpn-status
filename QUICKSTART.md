# 🚀 Quick Start Guide

## For Package Maintainers

### Initial Setup

1. **Update your information in package files:**
   ```bash
   # Edit PKGBUILD - replace maintainer info
   sed -i 's/Your Name <your.email@example.com>/Your Name <youremail@domain.com>/g' PKGBUILD
   
   # Edit debian/control - replace maintainer info
   sed -i 's/Your Name <your.email@example.com>/Your Name <youremail@domain.com>/g' debian/control
   
   # Edit debian/changelog - replace maintainer info
   sed -i 's/Your Name <your.email@example.com>/Your Name <youremail@domain.com>/g' debian/changelog
   
   # Edit debian/copyright - replace maintainer info
   sed -i 's/Your Name <your.email@example.com>/Your Name <youremail@domain.com>/g' debian/copyright
   ```

### Test Everything Works

```bash
# Use the helper script
./release.sh test

# Or manually
node --check indicators/expressvpn-status.js
node --check indicators/expressvpn-toggle.js
make --dry-run install
```

### Build Packages

#### Quick Method (using helper script):

```bash
# Build .deb
./release.sh build-deb

# Build AUR
./release.sh build-aur

# Test local installation
./release.sh install
waybar-expressvpn-status  # Test it works
./release.sh uninstall
```

#### Manual Method:

```bash
# For .deb
dpkg-buildpackage -us -uc -b

# For AUR
makepkg -si
```

### First Release

1. **Make sure your git is ready:**
   ```bash
   git add .
   git commit -m "Initial package setup"
   git push origin main
   ```

2. **Create first release:**
   ```bash
   ./release.sh release
   # Follow the prompts
   ```

3. **Or manually:**
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin main v1.0.0
   ```

### Publish to AUR

1. **Setup (one-time):**
   ```bash
   # Generate SSH key for AUR
   ssh-keygen -f ~/.ssh/aur
   
   # Add to your AUR account: https://aur.archlinux.org/account/
   cat ~/.ssh/aur.pub
   
   # Configure SSH
   cat >> ~/.ssh/config << EOF
   Host aur.archlinux.org
     IdentityFile ~/.ssh/aur
     User aur
   EOF
   ```

2. **Initial publish:**
   ```bash
   # Clone AUR repo
   git clone ssh://aur@aur.archlinux.org/waybar-expressvpn-status.git aur-pkg
   cd aur-pkg
   
   # Copy PKGBUILD
   cp ../PKGBUILD .
   
   # Generate .SRCINFO
   makepkg --printsrcinfo > .SRCINFO
   
   # Push
   git add PKGBUILD .SRCINFO
   git commit -m "Initial import: waybar-expressvpn-status 1.0.0"
   git push
   ```

### Setup GitHub Actions (Automated Releases)

1. **Generate AUR SSH key for GitHub:**
   ```bash
   ssh-keygen -f ./aur-github -N ""
   ```

2. **Add to AUR account:**
   - Go to: https://aur.archlinux.org/account/
   - Add the public key: `cat aur-github.pub`

3. **Add secrets to GitHub:**
   - Go to: `https://github.com/YOUR_USERNAME/waybar-expressvpn-status/settings/secrets/actions`
   - Add these secrets:
     - `AUR_USERNAME`: Your AUR username
     - `AUR_EMAIL`: Your AUR email  
     - `AUR_SSH_PRIVATE_KEY`: Content of `aur-github` file

4. **Now just push tags to trigger releases:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

## For End Users

### Install from AUR (Arch Linux)

```bash
yay -S waybar-expressvpn-status
# or
paru -S waybar-expressvpn-status
```

### Install from .deb (Debian/Ubuntu)

```bash
# Download from releases
wget https://github.com/YOUR_USERNAME/waybar-expressvpn-status/releases/download/v1.0.0/waybar-expressvpn-status_1.0.0-1_all.deb

# Install
sudo dpkg -i waybar-expressvpn-status_1.0.0-1_all.deb
sudo apt-get install -f  # Fix dependencies
```

### Manual Install

```bash
git clone https://github.com/YOUR_USERNAME/waybar-expressvpn-status.git
cd waybar-expressvpn-status
sudo make install
```

### Configure Waybar

1. **Add to `~/.config/waybar/config.jsonc`:**
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

2. **Add to `~/.config/waybar/style.css`:**
   ```css
   #custom-expressvpn.connected {
       color: rgb(48, 135, 48);
   }
   
   #custom-expressvpn.disconnected {
       color: #a55555;
   }
   ```

3. **Restart Waybar:**
   ```bash
   killall waybar
   waybar &
   ```

## Common Tasks

### Update to New Version

```bash
# Update files
./release.sh release

# Or manually update VERSION, PKGBUILD, debian/changelog, CHANGELOG.md

# Commit and tag
git add .
git commit -m "Release v1.1.0"
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin main v1.1.0
```

### Test Package Building

```bash
# Clean previous builds
./release.sh clean

# Build and test
./release.sh build-deb
sudo dpkg -i ../waybar-expressvpn-status*.deb
waybar-expressvpn-status
sudo dpkg -r waybar-expressvpn-status
```

### Troubleshooting

```bash
# Test scripts directly
node indicators/expressvpn-status.js
node indicators/expressvpn-toggle.js

# Check if installed correctly
which waybar-expressvpn-status
which waybar-expressvpn-toggle

# View Waybar logs
killall waybar
waybar 2>&1 | grep expressvpn
```

## Project Structure

```
waybar-expressvpn-status/
├── indicators/              # Source scripts
│   ├── expressvpn-status.js
│   └── expressvpn-toggle.js
├── examples/                # Configuration examples
│   ├── waybar-config.jsonc
│   └── waybar-style.css
├── debian/                  # Debian packaging
│   ├── control
│   ├── rules
│   ├── changelog
│   ├── compat
│   └── copyright
├── .github/workflows/       # CI/CD
│   ├── ci.yml
│   └── release.yml
├── Makefile                 # Installation script
├── PKGBUILD                 # AUR package definition
├── README.md                # User documentation
├── BUILD.md                 # Build instructions
├── CONTRIBUTING.md          # Contribution guidelines
├── CHANGELOG.md             # Version history
├── VERSION                  # Current version
├── LICENSE                  # MIT license
└── release.sh              # Release helper script
```

## Need Help?

- 📖 Read [BUILD.md](BUILD.md) for detailed build instructions
- 🤝 Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- 🐛 Open an issue on GitHub
- 📧 Contact the maintainer

---

**Happy packaging! 🎉**
