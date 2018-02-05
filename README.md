# OSX Homedir

### Bootstrapping a brand spanking new machine

On a freshly installed **macOS Sierra** machine the following commands will get everything configured.

```
sudo xcodebuild -license
curl -L https://raw.githubusercontent.com/scottmuc/osx-homedir/work/bin/curl-bash-bootstrap.bash 2> /dev/null | bash
~/bin/coalesce_this_machine
```

**Manual Steps**

* Map capslock to control
* Set trackpad to tap-to-click
* Launch Google Chrome and bind it to my account
* Launch shiftit and get it setup
* Launch flycut and get it setup

### So What's Included?

The following is made available by being cloned in the `$HOME` directory:

* **bash** configuration
* **git** configuration
* **~/bin** (added to PATH)
* **neovim** configuration

The rest is installed/configured by `~/bin/coalesce_this_machine`:

* runs **sprout-wrap** automation which does the following:
  * fixes my Dock
  * sets a fast key repeat rate
  * makes the function keys act as function keys
  * changes my menubar clock format
* runs **homebrew** things.
* installs **neovim** plugins
* runs OSX softwareupdates
