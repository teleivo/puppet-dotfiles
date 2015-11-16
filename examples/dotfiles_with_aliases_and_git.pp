Exec {
    path => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ]
}

package { 'git': }

user { 'teleivo':
  ensure     => present,
  managehome => true,
  home       => '/home/teleivo',
}

::dotfiles { '/home/teleivo':
  user                => 'teleivo',
  create_bash_aliases => true,
  create_gitconfig    => true,
  manage_gitprompt    => true,
  require             => [
    Package['git'],
    User['teleivo'],
  ]
}
