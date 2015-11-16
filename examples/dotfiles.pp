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
  user    => 'teleivo',
  require => [
    Package['git'],
    User['teleivo'],
  ]
}
