## ETCD

Highly-available key value store for shared configuration and service discovery

This package provides upstart config script and etcd binaries, unmodified from the upstream
releases, in /usr/bin/.

It does install etcd as a service to be started automatically.


### INSTALLATION

	apt-get install fakeroot
	make clean && make
	
copy *.deb file to repo or install with:

	dkpg -i etcd-<version>-1_amd64.deb
	
