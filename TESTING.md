# Testing Guide

This guide explains how to test your package builds **before** creating a release.

## 🧪 Why Test Before Release?

Before pushing a git tag and creating an official release, you should:
- ✅ Verify scripts have no syntax errors
- ✅ Validate PKGBUILD format
- ✅ Test package builds locally
- ✅ Ensure installation works correctly

## 📝 Quick Test Commands

### Test Everything
```bash
./release.sh test
```
This checks:
- Node.js scripts syntax
- Makefile validity

### Validate PKGBUILD Only
```bash
./release.sh validate
```
This validates PKGBUILD without building.

### Build Packages Locally

#### Build AUR Package (Arch Linux)
```bash
./release.sh build-aur
```

**Note**: Before the v1.0.0 tag exists, this uses `PKGBUILD.local` which builds from your current directory instead of fetching from GitHub.

#### Build .deb Package (Debian/Ubuntu)
```bash
./release.sh build-deb
```

#### Test Installation
```bash
./release.sh install
waybar-expressvpn-status  # Test it works
./release.sh uninstall
```

## 🔄 Development Workflow

### Before First Release

1. **Test locally:**
   ```bash
   ./release.sh test
   ./release.sh validate
   ./release.sh build-aur    # Uses PKGBUILD.local
   ```

2. **Test installation:**
   ```bash
   ./release.sh install
   # Test the scripts work
   waybar-expressvpn-status
   ./release.sh uninstall
   ```

3. **Create the release:**
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin main v1.0.0
   ```

4. **After tag exists**, test the real PKGBUILD:
   ```bash
   ./release.sh build-aur    # Now uses the GitHub tag
   ```

### For Updates

1. **Update version files** (see BUILD.md)

2. **Test again:**
   ```bash
   ./release.sh test
   ./release.sh build-aur
   ```

3. **Create new tag:**
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin main v1.1.0
   ```

## 🐛 Common Issues

### "nodejs not found" when building AUR

**Solution**: This is expected! The script automatically skips dependency checks with `--nodeps` flag.

### "Git tag not found" 

**Solution**: Normal before first release. The script automatically uses `PKGBUILD.local` for testing.

### PKGBUILD.local vs PKGBUILD

| File | Purpose | When Used |
|------|---------|-----------|
| **PKGBUILD** | Production package | After git tag exists |
| **PKGBUILD.local** | Testing package | Before git tag exists |

**Key difference**: 
- `PKGBUILD` fetches code from GitHub tag
- `PKGBUILD.local` builds from current directory

## ✅ Pre-Release Checklist

Before creating a release tag:

- [ ] Run `./release.sh test` - passes
- [ ] Run `./release.sh validate` - passes  
- [ ] Run `./release.sh build-aur` - builds successfully
- [ ] Run `./release.sh build-deb` - builds successfully (if on Debian/Ubuntu)
- [ ] Test manual install: `./release.sh install && waybar-expressvpn-status`
- [ ] Update all version numbers (VERSION, PKGBUILD, debian/changelog, Makefile)
- [ ] Update CHANGELOG.md
- [ ] Update maintainer info if needed
- [ ] Commit all changes
- [ ] Create and push git tag

## 🚀 After Release

Once you've pushed the tag:

1. **GitHub Actions** automatically:
   - Builds .deb package
   - Creates GitHub release
   - Uploads artifacts

2. **Verify the release:**
   - Check GitHub releases page
   - Download and test the .deb file

3. **Publish to AUR** (one-time setup required):
   - Follow AUR publishing steps in BUILD.md
   - Future updates push automatically via GitHub Actions

## 💡 Tips

- **Clean between builds**: `./release.sh clean`
- **Test on clean system**: Use a VM or container
- **Version numbering**: Follow semantic versioning (X.Y.Z)
- **Git tags**: Always annotated (`-a`) with message

## 📚 Related Docs

- **BUILD.md** - Complete building and publishing guide
- **QUICKSTART.md** - Quick command reference
- **release.sh** - Automation script with all commands

---

Happy testing! 🧪
