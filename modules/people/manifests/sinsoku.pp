class people::sinsoku {
  include redis

  $home = "/Users/${::boxen_user}"
  $dotfiles = "${home}/dotfiles"

  package {
    [
      'bash-completion',
      'git-flow',
    ]:
  }
  package {
    'vim':
      ensure => latest;
  }

  repository { $dotfiles: source => 'sinsoku/dotfiles' }

  # bash
  file { "${home}/.bash_profile":
    ensure => link,
    force => true,
    target => "${dotfiles}/bash/.bash_profile",
    require => Repository[$dotfiles],
  }
  file { "${home}/.bashrc":
    ensure => link,
    force => true,
    target => "${dotfiles}/bash/.bashrc.mac",
    require => Repository[$dotfiles],
  }

  # font: ricty
  homebrew::tap { 'sanemat/font': }
  package { 'ricty':
    require => Homebrew::Tap["sanemat/font"]
  }
  exec { 'setup ricty':
    command => "cp -f ${homebrew::config::installdir}/share/fonts/Ricty*.ttf ~/Library/Fonts/ && fc-cache -vf",
    require => Package["ricty"]
  }

  # git
  file { "${home}/.gitconfig":
    ensure => link,
    force => true,
    target => "${dotfiles}/git/.gitconfig",
    require => Repository[$dotfiles],
  }

  # vim
  $vim_dir = "${home}/.vim"
  $bundle_dir = "${vim_dir}/bundle"
  $neobundle_dir = "${bundle_dir}/neobundle.vim"

  file {
    $vim_dir:
      ensure => directory;
    $bundle_dir:
      ensure => directory;
  }

  file { "${home}/.vim/vimrc":
    ensure => link,
    force => true,
    target => "${dotfiles}/vim/.vim/vimrc",
    require => [
      Repository[$dotfiles],
      File[$vim_dir],
    ]
  }

  repository { $neobundle_dir:
    source => 'Shougo/neobundle.vim',
    require => File[$bundle_dir]
  }
  exec { 'setup neobundle':
    command => "${neobundle_dir}/bin/neoinstall",
    require => Repository[$neobundle_dir],
  }
}
