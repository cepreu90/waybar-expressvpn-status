# Building and Publishing Guide

This guide explains how to build and publish packages for waybar-expressvpn-status.

## Prerequisites

### For Debian/Ubuntu packages (.deb)

```bash
sudo apt-get install debhelper devscripts build-essential
```

### For Arch packages (AUR)

```bash
sudo pacman -S base-devel git
```

## Building Packages

### Build .deb Package

1. **Prepare the environment:**
   ```bash
   cd waybar-expressvpn-status
   ```

2. **Build the package:**
   ```bash
   dpkg-buildpackage -us -uc -b
   ```

3. **The .deb file will be created in the parent directory:**
   ```bash
   ls ../waybar-expressvpn-status*.deb
   ```

4. **Test the package:**
   ```bash
   sudo dpkg -i ../waybar-expressvpn-status_1.0.0-1_all.deb
   ```

### Build AUR Package

1. **Clone and prepare:**
   ```bash
   cd waybar-expressvpn-status
   ```

2. **Build with makepkg:**
   ```bash
   makepkg -si
   ```

3. **Or just build without installing:**
   ```bash
   makepkg
   ```

## Publishing to AUR

1. **Create an AUR account:** https://aur.archlinux.org/register

2. **Set up SSH keys:**
   ```bash
   ssh-keygen -f ~/.ssh/aur
   cat ~/.ssh/aur.pub  # Add this to your AUR account
   ```

3. **Configure SSH:**
   ```bash
   cat >> ~/.ssh/config << EOF
   Host aur.archlinux.org
     IdentityFile ~/.ssh/aur
     User aur
   EOF
   ```

4. **Clone the AUR repository:**
   ```bash
   git clone ssh://aur@aur.archlinux.org/waybar-expressvpn-status.git aur-waybar-expressvpn-status
   ```

5. **Copy files and push:**
   ```bash
   cd aur-waybar-expressvpn-status
   cp ../waybar-expressvpn-status/PKGBUILD .
   
   # Generate .SRCINFO
   makepkg --printsrcinfo > .SRCINFO
   
   # Commit and push
   git add PKGBUILD .SRCINFO
   git commit -m "Initial commit: waybar-expressvpn-status v1.0.0"
   git push
   ```

## Creating GitHub Releases

### Manual Release

1. **Create a tag:**
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

2. **Build the .deb package** (as shown above)

3. **Create GitHub release:**
   - Go to GitHub → Releases → "Create a new release"
   - Select the tag `v1.0.0`
   - Upload the `.deb` file
   - Upload the `PKGBUILD` file
   - Copy content from `CHANGELOG.md` into the release notes
   - Publish release

### Automated Release (GitHub Actions)

The repository includes GitHub Actions workflows that will automatically:

1. **On push to main:** Run CI tests
2. **On tag push (v*):** 
   - Build .deb package
   - Create GitHub release
   - Upload artifacts

**Setup secrets for automated AUR publishing:**

Go to GitHub → Settings → Secrets and add:
- `AUR_USERNAME`: Your AUR username
- `AUR_EMAIL`: Your AUR email
- `AUR_SSH_PRIVATE_KEY`: Your AUR SSH private key

Then just push a tag:
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## Updating Versions

When releasing a new version:

1. **Update version in all files:**
   ```bash
   # VERSION file
   echo "1.1.0" > VERSION
   
   # PKGBUILD
   # Update: pkgver=1.1.0
   
   # debian/changelog
   dch -v 1.1.0-1 "New release"
   
   # Makefile
   # Update: VERSION = 1.1.0
   ```

2. **Update CHANGELOG.md:**
   ```markdown
   ## [1.1.0] - 2025-XX-XX
   
   ### Added
   - New feature description
   
   ### Fixed
   - Bug fix description
   ```

3. **Commit and tag:**
   ```bash
   git add VERSION PKGBUILD debian/changelog Makefile CHANGELOG.md
   git commit -m "Bump version to 1.1.0"
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin main v1.1.0
   ```

## Testing Before Release

1. **Test manual installation:**
   ```bash
   sudo make install
   waybar-expressvpn-status
   waybar-expressvpn-toggle
   sudo make uninstall
   ```

2. **Test .deb package:**
   ```bash
   dpkg-buildpackage -us -uc -b
   sudo dpkg -i ../waybar-expressvpn-status*.deb
   waybar-expressvpn-status
   sudo dpkg -r waybar-expressvpn-status
   ```

3. **Test AUR package:**
   ```bash
   makepkg -si
   waybar-expressvpn-status
   sudo pacman -R waybar-expressvpn-status
   ```

4. **Test in Waybar:**
   - Add configuration to Waybar
   - Restart Waybar
   - Check status display
   - Test click toggle

## Checklist for Release

- [ ] Update version in all files
- [ ] Update CHANGELOG.md
- [ ] Test manual installation
- [ ] Test .deb package build
- [ ] Test AUR package build
- [ ] Test functionality in Waybar
- [ ] Commit all changes
- [ ] Create and push tag
- [ ] Verify GitHub Actions run successfully
- [ ] Update AUR repository
- [ ] Announce release (optional)

## Troubleshooting

### .deb build fails

- Check `debian/control` for correct dependencies
- Ensure `debian/rules` is executable: `chmod +x debian/rules`
- Clean build artifacts: `debuild clean`

### PKGBUILD fails

- Test PKGBUILD syntax: `namcap PKGBUILD`
- Update checksums: Use `SKIP` for git sources
- Ensure source URL is correct

### GitHub Actions fail

- Check workflow syntax
- Verify secrets are set correctly
- Review action logs for specific errors

## Additional Resources

- [Debian Packaging Guide](https://www.debian.org/doc/manuals/maint-guide/)
- [AUR Submission Guidelines](https://wiki.archlinux.org/title/AUR_submission_guidelines)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)

---

Need help? Open an issue on GitHub!
