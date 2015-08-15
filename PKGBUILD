# Maintainer: Ryan Davies <ryan@ryandavies.co.nz>
# Contributor: Greg Sutcliffe <greg.sutcliffe@gmail.com>>

# Currently does a full bundle install, there are no split packages.

pkgname=foreman
pkgver=1.6.0
pkgrel=0.3
_version=1.6.0
pkgdesc="Infrastruce management app built on Ruby-on_rails. Integrates with Puppet for complete lifecycle management or real or virtual servers"
arch=('any')
url="http://theforeman.org"
license=('GPL3')
depends=('ruby1.9' 'ruby1.9-bundler' 'libxslt' 'libmysqlclient' 'postgresql-libs' 'libvirt' 'puppet' 'websockify')
conflicts=('foreman-git')
backup=("etc/foreman/settings.yaml" "etc/foreman/database.yml")
options=(emptydirs !strip)
install="foreman.install"
source=(https://github.com/theforeman/foreman/archive/${_version//_/-}.tar.gz
        foreman.systemd
        config_application.rb.patch
        foreman.tmpfiles.conf
        foreman.cron.d
        foreman.logrotate)
noextract=()
md5sums=('222523508f825128b82ec3193a3a1498'
         'a643f3b725dfab78270c3a4c5f6be8c4'
         '18fff3491642381dae1020b6dc891576'
         '9a24ac601fb92a388eda1367ca951a82'
         '6c7c9f66e66da561c176a9affb56aeda'
         'a78a5b740b79f89d13dd0603dac97483')

package() {
  cd $srcdir/foreman-${_version//_/-}
  # Not needed in a 'production' server
  rm bundler.d/test.rb
  rm bundler.d/development.rb
  rm bundler.d/console.rb

  # Patches
  patch -p0 < $srcdir/config_application.rb.patch
  echo 'gem "puppet"' > bundler.d/aur.rb
  echo 'gem "iconv"' >> bundler.d/aur.rb
  echo 'gem "thin"' >> bundler.d/aur.rb

  # Force noVNC socket to use python2
  sed -i "s/python$/python2/" extras/noVNC/websockify.py

  # Main codebase
  install -d -m0755 $pkgdir/usr/share/foreman/
  cp -r ./ $pkgdir/usr/share/foreman/

  # Symlink config file to etc
  install -Dp -m0644 config/settings.yaml.example $pkgdir/etc/foreman/settings.yaml
  ln -sn /etc/foreman/settings.yaml $pkgdir/usr/share/foreman/config/settings.yaml
  install -Dp -m0644 config/database.yml.example $pkgdir/etc/foreman/database.yml
  ln -sn /etc/foreman/database.yml $pkgdir/usr/share/foreman/config/database.yml

  # tmp
  install -d -m0755 $pkgdir/usr/share/foreman/tmp

  # logdirs
  install -d -m0755 $pkgdir/var/log/foreman
  rm -rf $pkgdir/usr/share/foreman/log
  ln -sn /var/log/foreman $pkgdir/usr/share/foreman/log
  touch $pkgdir/var/log/foreman/production.log
  chmod 0666 $pkgdir/var/log/foreman/production.log

  # system files
  install -Dm 644 $srcdir/foreman.systemd       $pkgdir/usr/lib/systemd/system/foreman.service
  install -Dm 644 $srcdir/foreman.tmpfiles.conf $pkgdir/usr/lib/tmpfiles.d/foreman.conf
  install -Dm 644 $srcdir/foreman.cron.d        $pkgdir/etc/cron.d/foreman
  install -Dm 644 $srcdir/foreman.logrotate     $pkgdir/etc/logrotate.d/foreman

}

# vim:set ts=2 sw=2 et:
