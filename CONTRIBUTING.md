# Contributing to waybar-expressvpn-status

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/waybar-expressvpn-status.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit with a clear message: `git commit -m "Add feature: description"`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Open a Pull Request

## Code Style

- Use consistent indentation (2 spaces for JavaScript)
- Add comments for complex logic
- Follow existing code patterns
- Keep functions focused and concise
- Use descriptive variable names

## Testing

Before submitting a PR:

1. Test the status script: `node indicators/expressvpn-status.js`
2. Test the toggle script: `node indicators/expressvpn-toggle.js`
3. Verify Waybar integration
4. Test installation: `sudo make install`
5. Ensure documentation is up to date

## Package Maintenance

When updating version:

1. Update `VERSION` file
2. Update version in `PKGBUILD`
3. Update version in `debian/changelog`
4. Update version in `Makefile`
5. Add entry to `CHANGELOG.md`
6. Create a git tag: `git tag -a v1.x.x -m "Release v1.x.x"`

## Bug Reports

When filing a bug report, include:

- Your Linux distribution and version
- Waybar version: `waybar --version`
- Node.js version: `node --version`
- ExpressVPN CLI version: `expressvpn --version`
- Error messages or unexpected behavior
- Steps to reproduce

## Feature Requests

We welcome feature requests! Please:

- Check if the feature already exists
- Clearly describe the use case
- Explain how it benefits users
- Provide examples if possible

## Documentation

Help improve documentation by:

- Fixing typos or unclear instructions
- Adding examples
- Improving troubleshooting section
- Translating documentation

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Focus on what's best for the community

## Questions

If you have questions:

- Check existing issues and discussions
- Read the README thoroughly
- Open a new issue with the "question" label

Thank you for contributing!
