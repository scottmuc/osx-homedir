# OSX Homedir

### Bootstrapping a brand spanking new machine

```
sudo xcodebuild -license
git init
git remote add origin git@github.com:scottmuc/osx-homedir.git
git fetch --all
git checkout master
bin/coalesce_this_machine
```

**Post Coalescence**

* Map capslock to control
* Set trackpad to tap-to-click
* Launch Dropbox and begin file sync (get Dropbox password from 1Password on  my phone).
* Launch 1Password and sync with keychain on Dropbox (add the license
  that's stored in 1Password
* Launch Google Chrome and bind it to my account
* Launch Evernote and begin file sync
* Launch shiftit and get it setup
* Launch flycut and get it setup

