# Maintainer: Mads maande20@gmail.com
pkgname=waybar-expressvpn-status
pkgver=1.0.0
pkgrel=1
pkgdesc="Waybar module for ExpressVPN status and control"
arch=('any')
url="https://github.com/cepreu90/waybar-expressvpn-status"
license=('MIT')
depends=('waybar' 'nodejs' 'expressvpn')
optdepends=('libnotify: for desktop notifications when toggling VPN')
makedepends=('git')
install=$pkgname.install
source=("git+$url.git#tag=v$pkgver")
sha256sums=('SKIP')

package() {
    cd "$pkgname"
    make DESTDIR="$pkgdir" PREFIX=/usr install
}
