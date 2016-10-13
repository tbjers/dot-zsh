#!/usr/bin/env bash
#
# tbjers/dot-zsh ellipsis package

pkg.link() {
  fs.link_files common

  case $(os.platform) in
    osx)
      fs.link_files platform/osx
      ;;
    linux)
      fs.link_files platform/linux
      ;;
  esac
}

check_shell() {
  CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
  if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
    echo "Zsh is not installed! Please install it first."
    exit
  fi
  unset CHECK_ZSH_INSTALLED
}

change_shell() {
  TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    if hash chsh >/dev/null 2>&1; then
      echo "Changing your default shell to Zsh."
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
    else
      echo "Cannot change your default shell because chsh is not installed."
    fi
  fi
}

pkg.install() {
  check_shell
  change_shell

  curl https://cdn.rawgit.com/zsh-users/antigen/v1.2.0/bin/antigen.zsh > $PKG_PATH/antigen.zsh

  fs.link_file $PKG_PATH
}
