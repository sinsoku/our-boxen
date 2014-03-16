class people::sinsoku {
  include redis

  package {
    'vim':
      ensure => latest;
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
}
