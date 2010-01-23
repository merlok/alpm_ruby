self.description = "Query info on a package"

p = pmpkg("foobar")
p.files = ["bin/foobar"]
p.desc = "test description"
p.groups = ["foo"]
p.url = "http://www.archlinux.org"
p.license = "GPL2"
p.arch = "i686"
# test old style date
p.builddate = "Mon Oct  1 01:40:21 2007 UTC"
p.packager = "Arch Linux"

self.addpkg2db("local", p)

self.args = "-Qi %s" % p.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=%s" % p.name)
self.addrule("PACMAN_OUTPUT=%s" % p.desc)
self.addrule("PACMAN_OUTPUT=2007")
