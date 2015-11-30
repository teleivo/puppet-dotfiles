# See README.md for documentation.
define dotfiles (
  $user,
  $user_home = $title,
  $create_bash_aliases = false,
  $create_gitconfig = false,
  $manage_gitprompt = false,
) {
  validate_string($user)
  validate_absolute_path($user_home)
  validate_bool($create_bash_aliases)
  validate_bool($create_gitconfig)
  validate_bool($manage_gitprompt)

  $dotfiles_path = "${user_home}/.dotfiles"
  vcsrepo { $dotfiles_path:
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/teleivo/dotfiles.git',
    user     => $user,
  }
  
  if ($create_bash_aliases) {
    file { "${user_home}/.bash_aliases":
      ensure  => link,
      owner   => $user,
      target  => "${dotfiles_path}/bash_aliases",
      require => Vcsrepo[$dotfiles_path],
    }
  }

  if ($create_gitconfig) {
    file { "${user_home}/.gitconfig":
      ensure  => link,
      owner   => $user,
      target  => "${dotfiles_path}/gitconfig",
      require => Vcsrepo[$dotfiles_path],
    }
  }

  if ($manage_gitprompt) {
    file { "${user_home}/.bashrc_git":
      ensure  => link,
      owner   => $user,
      target  => "${dotfiles_path}/bashrc_git",
      require => Vcsrepo[$dotfiles_path],
    }

    file_line { "${user}_bashrc_gitprompt":
      ensure  => present,
      path    => "${user_home}/.bashrc",
      line    => '[ -f ~/.bashrc_git ] && . ~/.bashrc_git',
      require => File["${user_home}/.bashrc_git"],
    }
  }
}
