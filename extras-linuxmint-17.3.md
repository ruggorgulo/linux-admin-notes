# Extra packages and configuration of Linux Mint 17.3

To make it more comfortable for me.

## Disable unused services

Avahi
```
echo manual > /etc/init/avahi-deamon.override
```

Bluetooth service
```
echo manual > /etc/init/bluetooth.override
```

Local printer service (CUPS)
```
echo manual > /etc/init/cups-browsed.override
echo manual > /etc/init/cups.override
```

Samba - Access local files from windows machines
```
echo manual > /etc/init/samba.override
echo manual > /etc/init/smbd.override
echo manual > /etc/init/nmbd.override
```

Scanner support
```
echo manual > /etc/init/saned.override
```

## Firewall

Install *ufw* and do basic configuration
```
apt-get install ufw
ufw enable
ufw deny out 5353/udp
ufw deny out 5298/any
ufw limit ssh
```

Enable extra ports depending on particular needs.
Use either `limit` or `allow` depending on amount of packets received
(especially for UDP the `limit` may be too limiting)

| $port_number | What it is |
| 22 | ssh (already configured above)|
| 80 | http |
| 443 | https |
| 2222 | spare port e.g. for ssh port forwarding to virtual machines |
| 7007 | spare port e.g. some extra user services |
| 8008 | spare port e.g. for user http server |
| 9009 | spare port e.g. some extra user services |

```
ufw limit $port_number
```

## Replace boot manager

Grub 2 is default boot manager. It works, but each upgrade of kernel or initramfs
generates huge slowdown in apt-process. It tries to autodetect something and it
really annoys me.

### Alternative one: syslinux

Syslinux works when booting from external USB disk (or flash stick).
When some modern file system (e.g. btrfs, f2fs, ...) is used for `/`,
then setup extra boot partition (vfat, ext4 without journal, ...).
Add cca 50MiB for each installed kernel version.

```
apt-get install extlinux syslinux-common syslinux
sed -i 's/EXTLINUX_UPDATE="true"/EXTLINUX_UPDATE="false"/g' /etc/default/extlinux
cp /usr/lib/syslinux/hdt.c32 /boot/extlinux/
cp /usr/lib/syslinux/menu.c32 /boot/extlinux/
cp /usr/lib/syslinux/poweroff.com /boot/extlinux/
cp /usr/lib/syslinux/reboot.c32 /boot/extlinux/
cp /usr/lib/syslinux/vesamenu.c32 /boot/extlinux/
cp /usr/lib/syslinux/linux.c32 /boot/extlinux/

dd if=/usr/lib/extlinux/mbr.bin of=/dev/sda bs=440 count=1
extlinux --install /boot/extlinux/
```

### Alternative two: grub legacy

TBD

### Final step: uninstall grub2

```
apt-get remove --purge grub-common grub-gfxpayload-lists grub-pc grub-pc-bin grub2-common
```

## Uninstall unused packages

Casper runs a "live" preinstalled system from read-only media
```
apt-get remove --purge casper lupin-casper
```

Adobe flash is security nightmare (piece of c..p)
```
apt-get remove --purge adobe-flashplugin
```

I don't have any braile display
```
apt-get remove --purge brltty
```

I don't use ReiserFS
```
apt-get remove --purge reiserfsprogs
```

I don't like avahi, it does not bring me anything good
```
apt-get remove --purge avahi-autoipd avahi-utils avahi-daemon libavahi-core7
```

I don't use Mint Upload, nor Mint Wecome screen
```
apt-get remove --purge mintupload mintwelcome
```

I want to have upgrade supervised
```
apt-get remove --purge mintupload mintwelcome
```

Unofficial Mint LXDE comes with polish localization installed, but I don't need it
```
apt-get remove --purge firefox-locale-pl thunderbird-locale-pl language-pack-gnome-pl language-pack-gnome-pl-base language-pack-pl language-pack-pl-base myspell-pl wpolish\
rm -rf /var/lib/apt/lists/*i18n_*-pl
```

I don't use modem any more
```
apt-get remove --purge modemmanager
```

In case there is no AMD/ATI graphics card:
```
apt-get remove --purge radeontool
```

## Newer kernel

As of October 2016 there are several kernels available. Each kernel is available both
as generic or lowlatency variant. Each version could have it's own versions of
companion software.

##### Kernel 3.14

This is original version inclued in Mint 17.3. Install at least 3.19 instead.

##### Kernel 3.16

Available as nickname *utopic*.  Install at least 3.19 instead.

##### Kernel 3.19

Available as nickname *vivid*. Works like a charm.

Note: apt-cache search --names-only vivid

| Kernel | Headers |
| linux-image-extra-virtual-lts-vivid | Transitional package.
| linux-image-generic-lts-vivid       | Generic Linux kernel image
| linux-image-lowlatency-lts-vivid    | lowlatency Linux kernel image
| linux-image-virtual-lts-vivid       | This package will always depend on the latest minimal generic kernel image.
| linux-lowlatency-lts-vivid          | Complete lowlatency Linux kernel
| linux-generic-lts-vivid             | Complete Generic Linux kernel and headers




| version | $name | note |
| 3.14 | | |
| 3.16 | utopic | original version included in Mint 17.3 |
| 3.19 | vivid | support of f2fs |
| 4.2 | willy
| 4.4 | xenial

Generic variant:
```
apt-get install linux-image-extra-virtual-lts-$name
```

Low latency variant:
```
apt-get install linux-image-lowlatency-lts-$name
```

In case of installation vivid or newer, install also:
```
apt-get install f2fs-tools
```


## Display manager

The default Mint Display Manager (mdm) consumes huge amount of memory even when user is logged in.
On login screen is changes background picture often, rendering machine unusable during the change.
Uninstall it:
```
apt-get remove --purge mdm mint-mdm-themes mint-mdm-themes-gdm mint-mdm-themes-html
```

### Alternative one: LightDM

Consumes only 

```
apt-get install lightdm lightdm-gtk-greeter
```

### Alternative two: LXDM

Consumes only 4176 + 3684 KiB of ram.

```
apt-get install lxdm
```

## ngetty instead of getty

Use ngetty instead of getty and save memory
```
apt-get install ngetty
```

Write following configuration to /etc/init/tty-ngetty.conf
```
# tty - ngetty
#
# This service maintains ngetty on all tty from the point the system is
# started until it is shut down again.

start on stopped rc RUNLEVEL=[2345] and (
            not-container or
            container CONTAINER=lxc or
            container CONTAINER=lxc-libvirt)

stop on runlevel [!2345]

#respawn
exec /sbin/ngetty-argv :-D:-S:-d/:-p/run/ngetty.pid:/sbin/ngetty::1:2:3:4:5:6
```

And finally disable original getty. It cannot be removed due to depencencies.
```
for i in 1 2 3 4 5 6 ; do
    echo manual > /etc/init/tty$i.override
done
```

## Add more package repositories

Trusty backports - /etc/apt/sources.list.d/backports.list
```
deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse
```

GetDeb - /etc/apt/sources.list.d/getdeb.list
```
deb http://archive.getdeb.net/ubuntu trusty-getdeb apps
```

Fresh Git - /etc/apt/sources.list.d/git-core.list
```
deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main 
```

Mate update from webupd8 team - /etc/apt/sources.list.d/webupd8team-mate.list
```
deb http://ppa.launchpad.net/webupd8team/mate/ubuntu trusty main
```

Webupd8 main repository /etc/apt/sources.list.d/webupd8-main.list
```
deb http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu trusty main
```

Lot of GTK/Metacity themes for Mate desktop - /etc/apt/sources.list.d/webupd8-themes.list
```
deb http://ppa.launchpad.net/webupd8team/themes/ubuntu trusty main
```

X2Go - /etc/apt/sources.list.d/x2go.list
```
deb http://ppa.launchpad.net/x2go/stable/ubuntu trusty main
```

### Don't forget to update

```
apt-get update
```


## Install usefull packages

##### SSH server
```
apt-get install openssh-server openssh-sftp-server
```

##### Emacs editor

| Variant | install command |
| Emacs 24 console only | `apt-get install emacs24-nox emacs-goodies-el python-mode` |
| Emacs 24 - gtk | `apt-get install emacs24  emacs-goodies-el python-mode` |
| Emacs 23 console only | `apt-get install emacs23-nox emacs-goodies-el python-mode` |
| Emacs 23 - gtk | `apt-get install emacs23  emacs-goodies-el python-mode` |
| XEmacs 21 - gui | `apt-get install xemacs21 python-mode` |

##### Other development tools
| Tool | install command |
| Geany editor | `apt-get install geany geany-plugin-codenav geany-plugin-commander geany-plugin-lua geany-plugin-macro geany-plugin-markdown geany-plugin-prettyprinter geany-plugin-shiftcolumn geany-plugin-tableconvert geany-plugin-treebrowser geany-plugin-vc` |
| Meld diff | `apt-get install meld` |
| git | `apt-get install git gitk` |


##### X2Go
X2Go is installed (obtained) from x2go ppa repository (see repositories)
| Component | install command |
| server | `apt-get install x2goserver x2goserver-xsession` |
| Server Mate support | `apt-get install x2gomatebindings` |
| Server LXDE support | `apt-get install x2golxdebindings` |
| Server printing support | `apt-get install x2goserver-printing cups-x2go` |
|Client connection | `apt-get install x2goclient` |

Manually add users allowed to print ower x2go to the corresponding group.
The group fuse is neccessary because X2Go needs access
to the client to transfer the print file:
```
sudo adduser USERNAME x2goprint
sudo adduser USERNAME fuse
```

##### avr development

Install compiler, programmer & tools
```
apt-get install avrdude gcc-avr avr-libc binutils-avr arduino-core
echo 'ATTRS{idVendor}=="xxxx", ATTRS{idProduct}=="yyyy", MODE="0666"' > /etc/udev/rules.d/99-avr-programmer.rules
```

add user to groups uucp , lock , tty
```
users=$(awk -F : '$3>=1000 {print $1, "\"\" off";}' | sort)
```

alternatives for arduino ide:
| Ino | | https://github.com/amperka/ino |
| arduino-mk | `apt-get install arduino-mk` | https://github.com/sudar/Arduino-Makefile
| emacs-arduino-mode | | https://github.com/bookest/arduino-mode
| arduino-cmake | |  https://github.com/queezythegreat/arduino-cmake

Consistent naming of Arduino devices: https://wiki.archlinux.org/index.php/Arduino#Consistent_naming_of_Arduino_devices
Error opening serial port: dtto
Missing twi.o: dtto

##### arm-stm32 development

```
apt-get install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi openocd gdb-arm-none-eabi
echo 'ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666"' > /etc/udev/rules.d/99-stlink.rules
```
