# TODO:
- [ ] sign up for arch news feed: [Arch Linux](https://archlinux.org/)
- [ ] and/or mailing list: [Info | arch-announce@lists.archlinux.org - lists.archlinux.org](https://lists.archlinux.org/mailman3/lists/arch-announce.lists.archlinux.org/)
- [ ] sort out GTK styling: [GTK - ArchWiki](https://wiki.archlinux.org/title/GTK)
- [ ] and QT styling: [Qt - ArchWiki](https://wiki.archlinux.org/title/Qt)
- [ ] idle and lock programs (use finger print to unlock)
- [ ] improve hyprland animations
- [ ] basically RTFM again as it has changed a bit since
- [ ] subscribe to RSS feeds for all major software installed



# Install all required packages with the below command

```sh
sudo pacman -Syu - < packages.txt
```


# Stow

On first stow command, use the following to prevent future new files from being created:

```sh
stow --no-folding module_name
```


# Change current user shell to ZSH

```sh
chsh -s /usr/bin/zsh
```


# Hosts

Edit the `/etc/hosts` file to include the hostname at the end of the file:

```sh
echo "127.0.1.1        $HOSTNAME.localdomain $HOSTNAME" | sudo tee -a /etc/hosts
```


# Autologin

Create the drop-in file directory for a `autologin.conf` to be added:

```sh
sudo mkdir /etc/systemd/system/getty@tty1.service.d
```

Then populate the drop-in file with the following:

```sh
cat << EOF | sudo tee -a /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-f -- $USER' --autologin $USER tty1
EOF
```


# Pacman

Update the `/etc/pacman.conf` file to have colour output and change the number of parallel downloads to match CPU count:

```
...
COLORS
...
ParallelDownloads = 8
...
```

Make sure both lines are uncommented.


# Yay

```sh
mkdir "$SOURCES_DIR"
cd "$SOURCES_DIR"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```


# GnuPG

Setup configuration files for using yubikey, making sure all file permissions are correct:

```sh
cat << EOF >> ~/.local/share/gnupg/scdaemon.conf
disable-ccid
EOF
cat << EOF >> ~/.local/share/gnupg/gpg-agent.conf
pinentry-program /usr/bin/pinentry-gnome3
enable-ssh-support
ttyname $GPG_TTY
default-cache-ttl 60
max-cache-ttl 120
EOF
find ~/.local/share/gnupg -type d -exec chmod 700 {} \;
find ~/.local/share/gnupg -type f -exec chmod 600 {} \;
```


Retrieve public key from keyoxide servers.

```sh
gpg -k
sudo systemctl enable --now pcscd.service
gpg --recv "$KEYID"
```

Then update the trust level to ultimate.

```sh
gpg --edit-key "$KEYID"
trust
5
y
save
```


# SSH

Export public key from the ssh agent:

```sh
ssh-add -L | grep "cardno:xxxxxxxxx" > ~/.ssh/id_rsa_yubikey.pub
```

Create a host entry for GitHub to test against:

```sh
cat << EOF >> ~/.ssh/config
Host github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_rsa_yubikey.pub
EOF
```

```sh
ssh -T git@github.com
```


# 1Password

This maybe unnecessary rather than just using `yay -Syu 1password`, but it's what the docs say...

```sh
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
cd "$SOURCES_DIR"
git clone https://aur.archlinux.org/1password.git
cd 1password
makepkg -si
```

Updating is done with just `git pull` and `makepkg -si`.

To install the CLI, download the latest release from [1Password CLI Releases](https://app-updates.agilebits.com/product_history/CLI2)

```sh
ARCH="amd64" && \
wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.31.0/op_linux_${ARCH}_v2.31.0.zip" -O op.zip && \
unzip -d op op.zip && \
sudo mv op/op /usr/local/bin/ && \
rm -r op.zip op && \
sudo groupadd -f onepassword-cli && \
sudo chgrp onepassword-cli /usr/local/bin/op && \
sudo chmod g+s /usr/local/bin/op
```

Install gnome-keyring, start the systemd service and add the following to `/etc/pam.d/hyprlock`:

```
#%PAM-1.0

auth       include      login
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```

Automatically change keyring password with user password:

```
#%PAM-1.0
...
password  optional  pam_gnome_keyring.so
```

Integrate with Zen Browser until it is officially supported by 1Password:

```sh
sudo mkdir /etc/1password
sudo touch /etc/1password/custom_allowed_browsers
echo "zen-bin" | sudo tee -a /etc/1password/custom_allowed_browsers
```


# Pass

Before being able to clone the the password store, the remote machine needs to be added to `~/.ssh/config`:

```
Host $REMOTE_HOST
    HostName $IPAddress
    User $HOST_USER
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_rsa_yubikey.pub
```

Using `gopass` to manage and clone the password store from the remote machine:

```sh
mkdir "$PASSWORD_STORE_DIR"
cd "$PASSWORD_STORE_DIR"
gopass clone "$REMOTE_HOST":~/.password-store
```


# fprintd

Enroll a user's fingerprint

```sh
sudo fprintd-enroll "$USER"
```

To verify the fingerprint has been registered successfully:

```sh
fprintd-verify
```

Then edit `/etc/pam.d/sudo` to use either the fingerprint reader or password for sudo operations.

```
#%PAM-1.0
auth    sufficient  pam_fprintd_grosshack.so
auth    sufficient  pam_unix.so try_first_pass likeauth nullok
...
```


# Polkit

Using Hyprland's hyprpolkitagent to get password prompts for GUI applications (e.g. 1Password).

First copy the `/usr/lib/pam.d/polkit-1` to `/etc/pam.d/`, then edit it to make use of fprintd:

```
#%PAM-1.0
auth    sufficient  pam_fprintd_grosshack.so
auth    sufficient  pam_unix.so try_first_pass likeauth nullok
...
```


# Services

Enable and start all required services:

```sh
sudo systemctl enable --now cups.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now fprintd.service
sudo systemctl enable --now pcscd.service
sudo systemctl enable --now sshd.service

systemctl --user enable --now blueman-manager.service
systemctl --user enable --now bluetooth-applet.service
systemctl --user enable --now foot-server.service
systemctl --user enable --now gnome-keyring-daemon.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now mpd.service
systemctl --user enable --now mpd-mpris.service
systemctl --user enable --now sunsetr.service
systemctl --user enable --now syncthing.service
systemctl --user enable --now waybar.service
```


# Bluetooth

If the device continuously connects and disconnects.

```sh
bluetoothctl
> power on
> agent on
> pair 00:00:00:00:00:00
# type the pair code into the keyboard as prompted
> connect 00:00:00:00:00:00
> trust 00:00:00:00:00:00
> agent off
> quit
```


# Music

Using mpd as the local music server. First the correct directories need to be created (based on `mpd.conf`):

```sh
mkdir ~/.local/share/mpd
mkdir ~/.local/share/mpd/playlists
mkdir ~/.local/share/mpd/state
```


# Man

To make sure commands such as `apropos` or `fuzzel_man` can find manual pages:

```sh
sudo mandb
```


# Virtual Machines

Create the same directory path that the `.qcow2` image originated from:

```sh
mkdir -p ~/.local/share/gnome-boxes/images
```

Then copy the image into that folder from an external drive, and load into QEMU using `virsh`.

```sh
cp /run/media/$USER/media/images/virtual-machine.qcow2 ~/.local/share/gnome-boxes/images/
cp /run/media/$USER/media/images/virtual-machine.xml ~/.local/share/gnome-boxes/
cd ~/.local/share/gnome-boxes/
virsh define virtual-machine.xml
```

List all available images:

```sh
virsh -c qemu:///session list --all
```

If the user is required to access virtual machines from `qemu:///system`, add them to the `libvirt` user group.

```sh
sudo usermod --append --groups libvirt "$USER"
```


# Kanagawa Theme

```
background           #1F1F28
foreground           #DCD7BA
selection_background #2D4F67
selection_foreground #C8C093
regular0             #16161D
regular1             #C34043
regular2             #76946A
regular3             #C0A36E
regular4             #7E9CD8
regular5             #957FB8
regular6             #6A9589
regular7             #C8C093
bright0              #727169
bright1              #E82424
bright2              #98BB6C
bright3              #E6C384
bright4              #7FB4CA
bright5              #938AA9
bright6              #7AA89F
bright7              #DCD7BA
color16              #FFA066
color17              #FF5D62
```
