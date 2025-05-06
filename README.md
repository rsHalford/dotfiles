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
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM
EOF
```


# Yay

```sh
mkdir "$SOURCES_DIR"
cd "$SOURCES_DIR"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```


# GnuPG

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


# Services

Enable and start all required services:

```sh
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now fprintd.service
sudo systemctl enable --now pcscd.service

systemctl --user enable --now bluetooth-manager.service
systemctl --user enable --now fnott.service
systemctl --user enable --now foot-server.service
systemctl --user enable --now syncthing.service
systemctl --user enable --now waybar.service


# Need to double check
systemctl --user enable --now hyprshade.service
systemctl --user enable --now bluetooth-applet.service
sudo systemctl enable --now sshd.service
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
