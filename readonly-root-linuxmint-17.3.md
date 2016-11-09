# How to adjust linux Mint 17.3 and mount root partition read-only

#### Special files in /etc

##### /etc/mtab

This file is modified on each mount and umount. Solution: Create a symlink from /etc/mtab to /proc/self/mounts

```
rm /etc/mtab
ln -s /proc/self/mounts mtab
```

##### /etc/resolv.conf

If you have only a static nameserver configuration, then there is no problem. Otherwise
```
rm /etc/resolv.conf
ln -s /run/resolvconf/resolv.conf /etc/resolv.conf
```


#### Network manager must not write to /var/lib

```
service network-manager stop
rm -rm /var/lib/NetworkManager
ln -s /run/NetworkManager /var/lib/NetworkManager
service network-manager start
```

#### Deb packages should not be stored permanently

```
rm -rf /var/cache/apt/archives
ln -s /tmp /var/cache/apt/archives
```

#### /tmp is to be in ramdisk

```
if ! fgrep ' /tmp ' /etc/fstab ; then
echo 'tmpfs /tmp tmpfs   defaults,noatime,nodiratime,nosuid,nodev 0 0' >> /etc/fstab
fi
```

#### use zram for /var/log and /var/tmp

see https://github.com/ruggorgulo/zram-service

```
dpkg -i zram-service-1.0.deb
service rsyslog stop
rm -rf /var/log/*
rm -rf /var/tmp/*
zram-service.sh start
```

