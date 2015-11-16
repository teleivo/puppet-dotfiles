# See README.md for documentation.
define dotfiles (
  $user,
  $user_home = $title,
  $create_bash_aliases = false,
) {
  validate_string($user)
  validate_absolute_path($user_home)
  validate_bool($create_bash_aliases)

  $dotfiles_path = "${user_home}/.dotfiles"
  vcsrepo { $dotfiles_path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/teleivo/dotfiles.git',
    user     => $user,
  }
  
  if ($create_bash_aliases) {
    file { "${user_home}/.bash_aliases":
      ensure => link,
      owner  => $user,
      target => "${dotfiles_path}/bash_aliases",
    }
  }
}
