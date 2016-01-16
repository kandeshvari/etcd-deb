VERSION = 2.2.4
RELEASE = 3
SOURCE = https://github.com/coreos/etcd/releases/download/v$(VERSION)/etcd-v$(VERSION)-linux-amd64.tar.gz

all:
	cp -a deb-root etcd-$(VERSION)
	mkdir -p tmp etcd-$(VERSION)/usr/bin/
	curl -L "$(SOURCE)" | tar -xzf - -C tmp --strip-components 1
	mv tmp/etcd tmp/etcdctl etcd-$(VERSION)/usr/bin/
	fakeroot dpkg-deb --build etcd-$(VERSION) && mv etcd-$(VERSION).deb etcd-$(VERSION)-$(RELEASE)_amd64.deb

clean:
	@rm -rf etcd-$(VERSION) tmp *.deb

