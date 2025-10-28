#!/bin/bash
# Release helper script for waybar-expressvpn-status

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  test          - Run all tests"
    echo "  validate      - Validate PKGBUILD syntax only (no build)"
    echo "  build-deb     - Build .deb package"
    echo "  build-aur     - Build AUR package (requires Arch Linux)"
    echo "  install       - Install locally"
    echo "  uninstall     - Uninstall"
    echo "  release       - Create a new release (interactive)"
    echo "  clean         - Clean build artifacts"
    exit 1
}

function info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

function warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

function error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

function test_scripts() {
    info "Testing Node.js scripts..."
    node --check indicators/expressvpn-status.js || error "expressvpn-status.js has syntax errors"
    node --check indicators/expressvpn-toggle.js || error "expressvpn-toggle.js has syntax errors"
    
    info "Checking Makefile..."
    make --dry-run install > /dev/null || error "Makefile is invalid"
    
    info "All tests passed!"
}

function validate_pkgbuild() {
    info "Validating PKGBUILD..."
    
    if [ ! -f PKGBUILD ]; then
        error "PKGBUILD not found"
    fi
    
    # Basic syntax check
    bash -n PKGBUILD || error "PKGBUILD has syntax errors"
    
    # Check required fields
    if ! grep -q "^pkgname=" PKGBUILD; then
        error "PKGBUILD missing pkgname"
    fi
    
    if ! grep -q "^pkgver=" PKGBUILD; then
        error "PKGBUILD missing pkgver"
    fi
    
    info "PKGBUILD validation passed!"
    
    # Show package info
    source PKGBUILD
    info "Package: $pkgname"
    info "Version: $pkgver-$pkgrel"
    info "Description: $pkgdesc"
}

function build_deb() {
    info "Building .deb package..."
    
    if ! command -v dpkg-buildpackage &> /dev/null; then
        error "dpkg-buildpackage not found. Install: sudo apt-get install devscripts"
    fi
    
    dpkg-buildpackage -us -uc -b
    
    info "Package built successfully!"
    info "Output: $(ls -1 ../waybar-expressvpn-status*.deb | head -1)"
}

function build_aur() {
    info "Building AUR package..."
    
    if ! command -v makepkg &> /dev/null; then
        error "makepkg not found. Install: sudo pacman -S base-devel"
    fi
    
    # Check if git tag exists
    if ! git rev-parse "v$(cat VERSION)" >/dev/null 2>&1; then
        warn "Git tag v$(cat VERSION) not found. Using local PKGBUILD for testing..."
        
        if [ ! -f PKGBUILD.local ]; then
            error "PKGBUILD.local not found. Cannot build without tag."
        fi
        
        info "Building from local files with PKGBUILD.local (skipping deps)..."
        makepkg -f -p PKGBUILD.local --nodeps
    else
        # Use --nodeps to skip dependency checks (for testing PKGBUILD)
        # Use --skipinteg to skip integrity checks (since we use SKIP for git sources)
        info "Building with makepkg --nodeps --skipinteg..."
        makepkg -f --nodeps --skipinteg
    fi
    
    info "Package built successfully!"
    PKG_FILE=$(ls -1 waybar-expressvpn-status*.pkg.tar.zst 2>/dev/null | head -1)
    if [ -n "$PKG_FILE" ]; then
        info "Output: $PKG_FILE"
        info "To install: sudo pacman -U $PKG_FILE"
    else
        warn "Package file not found (may have failed)"
    fi
}

function install_local() {
    info "Installing waybar-expressvpn-status..."
    sudo make install
    info "Installation complete!"
}

function uninstall_local() {
    info "Uninstalling waybar-expressvpn-status..."
    sudo make uninstall
    info "Uninstall complete!"
}

function clean_build() {
    info "Cleaning build artifacts..."
    rm -f ../waybar-expressvpn-status*.deb
    rm -f waybar-expressvpn-status*.pkg.tar.zst
    rm -rf pkg/ src/
    rm -rf debian/files debian/*.log debian/*.substvars debian/waybar-expressvpn-status/
    info "Clean complete!"
}

function create_release() {
    info "Creating new release..."
    
    # Get current version
    CURRENT_VERSION=$(cat VERSION)
    echo "Current version: $CURRENT_VERSION"
    
    # Ask for new version
    read -p "Enter new version (e.g., 1.1.0): " NEW_VERSION
    
    if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error "Invalid version format. Use: X.Y.Z"
    fi
    
    info "Updating version files..."
    
    # Update VERSION
    echo "$NEW_VERSION" > VERSION
    
    # Update PKGBUILD
    sed -i "s/^pkgver=.*/pkgver=$NEW_VERSION/" PKGBUILD
    
    # Update Makefile
    sed -i "s/^VERSION = .*/VERSION = $NEW_VERSION/" Makefile
    
    # Update debian/changelog
    warn "Don't forget to update debian/changelog manually!"
    read -p "Press enter to open editor for debian/changelog..."
    ${EDITOR:-nano} debian/changelog
    
    # Update CHANGELOG.md
    warn "Don't forget to update CHANGELOG.md!"
    read -p "Press enter to open editor for CHANGELOG.md..."
    ${EDITOR:-nano} CHANGELOG.md
    
    info "Version updated to $NEW_VERSION"
    
    # Commit
    read -p "Commit changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add VERSION PKGBUILD Makefile debian/changelog CHANGELOG.md
        git commit -m "Bump version to $NEW_VERSION"
        info "Changes committed"
    fi
    
    # Create tag
    read -p "Create git tag v$NEW_VERSION? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"
        info "Tag created"
        
        warn "To push: git push origin main v$NEW_VERSION"
    fi
}

# Main
case "${1:-}" in
    test)
        test_scripts
        ;;
    validate)
        validate_pkgbuild
        ;;
    build-deb)
        build_deb
        ;;
    build-aur)
        build_aur
        ;;
    install)
        install_local
        ;;
    uninstall)
        uninstall_local
        ;;
    release)
        create_release
        ;;
    clean)
        clean_build
        ;;
    *)
        usage
        ;;
esac
