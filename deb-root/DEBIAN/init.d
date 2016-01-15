#! /bin/sh
### BEGIN INIT INFO
# Provides:          etcd
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO
#
# Init script for etcd Debian package. Based on skeleton init script:
#
# Version:	@(#)skeleton  2.85-23  28-Jul-2004  miquels@cistron.nl
#

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="Highly-available key value store"
PIDFILE=/var/run/etcd.pid
SCRIPTNAME=/etc/init.d/etcd


test -f /lib/lsb/init-functions || exit 1
. /lib/lsb/init-functions

# Check if configuration file is present
test -f /etc/default/etcd && . /etc/default/etcd


ARGS=

if [ -n "$INITIAL_CLUSTER" ]; then
	ARGS="$ARGS \
		--initial-cluster=$INITIAL_CLUSTER \
		--initial-cluster-state=$INITIAL_CLUSTER_STATE \
		--initial-cluster-token=$INITIAL_CLUSTER_TOKEN"
fi

if [ -n "$INITIAL_ADVERTISE_PEER_URLS" ]; then
	ARGS="$ARGS --initial-advertise-peer-urls=$INITIAL_ADVERTISE_PEER_URLS"
fi

if [ -n "$DISCOVERY" ]; then
	ARGS="$ARGS \
		--discovery=$DISCOVERY \
		--discovery-fallback=$DISCOVERY_FALLBACK \
		--discovery-proxy=$DISCOVERY_PROXY"
fi

if [ -n "$DISCOVERY_SRV" ]; then
	ARGS="$ARGS --discovery-srv=$DISCOVERY_SRV"
fi

if [ -n "$SNAPSHOT_COUNT" ]; then
	ARGS="$ARGS --snapshot-count=$SNAPSHOT_COUNT"
fi

if [ -n "$ADVERTISE_CLIENT_URLS" ]; then
	ARGS="$ARGS --advertise-client-urls=$ADVERTISE_CLIENT_URLS"
fi

if [ -n "$LISTEN_PEER_URLS" ]; then
	ARGS="$ARGS --listen-peer-urls=$LISTEN_PEER_URLS"
fi

if [ -n "$LISTEN_CLIENT_URLS" ]; then
	ARGS="$ARGS --listen-client-urls=$LISTEN_CLIENT_URLS"
fi

#
#	Function that starts the daemon/service.
#
d_start() {
	start-stop-daemon -c etcd -b -p $PIDFILE -S --startas /usr/bin/etcd -- \
		--name=$NAME \
		--data-dir=$DATA_DIR \
		--cors=$CORS \
		$ARGS \
		2>/dev/null
}

#
#	Function that stops the daemon/service.
#
d_stop() {
	start-stop-daemon -p $PIDFILE -K
}


case "$1" in
  start)
	echo -n "Starting $DESC: etcd"
	d_start
	echo "."
	;;
  stop)
	echo -n "Stopping $DESC: etcd"
	d_stop
	echo "."
	;;
  restart|force-reload)
	echo -n "Restarting $DESC: etcd"
	d_stop
	sleep 1
	d_start
	echo "."
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0
