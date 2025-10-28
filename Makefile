PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/waybar-expressvpn-status
EXAMPLEDIR = $(DOCDIR)/examples

VERSION = 1.0.0

.PHONY: all install uninstall clean

all:
	@echo "Run 'make install' to install waybar-expressvpn-status"

install:
	@echo "Installing waybar-expressvpn-status $(VERSION)..."
	install -Dm755 indicators/expressvpn-status.js $(DESTDIR)$(BINDIR)/waybar-expressvpn-status
	install -Dm755 indicators/expressvpn-toggle.js $(DESTDIR)$(BINDIR)/waybar-expressvpn-toggle
	install -Dm755 configure-waybar.sh $(DESTDIR)$(BINDIR)/waybar-expressvpn-configure
	install -Dm644 README.md $(DESTDIR)$(DOCDIR)/README.md
	install -Dm644 LICENSE $(DESTDIR)$(DOCDIR)/LICENSE
	install -Dm644 examples/waybar-config.jsonc $(DESTDIR)$(EXAMPLEDIR)/waybar-config.jsonc
	install -Dm644 examples/waybar-style.css $(DESTDIR)$(EXAMPLEDIR)/waybar-style.css
	@echo "Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "1. Run the configuration helper:"
	@echo "   waybar-expressvpn-configure"
	@echo ""
	@echo "Or manually add to your Waybar config (~/.config/waybar/config.jsonc):"
	@echo ""
	@cat examples/waybar-config.jsonc
	@echo ""

uninstall:
	@echo "Uninstalling waybar-expressvpn-status..."
	rm -f $(DESTDIR)$(BINDIR)/waybar-expressvpn-status
	rm -f $(DESTDIR)$(BINDIR)/waybar-expressvpn-toggle
	rm -f $(DESTDIR)$(BINDIR)/waybar-expressvpn-configure
	rm -rf $(DESTDIR)$(DOCDIR)
	@echo "Uninstall complete!"

clean:
	@echo "Nothing to clean"
