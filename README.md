# puppet-dotfiles

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-dotfiles.png?branch=master)](https://travis-ci.org/teleivo/puppet-dotfiles)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with dotfiles](#setup)
    * [Beginning with dotfiles](#beginning-with-dotfiles)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Defines](#defines)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development](#development)

## Module Description

The dotfiles module configures dotfiles via a .dotfiles directory stored in a vcs repository.

## Setup

### Beginning with dotfiles

The quickest way to get dotfiles set up is to apply a manifest like this one:

```puppet
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
```

## Reference

### Defines

#### dotfiles
~~~
dotfiles { '/home/teleivo':
  user      => 'teleivo',
  require   => User['teleivo'],
}
~~~
##### `user`

*Required.* Specifies the user as which .dotfiles directory is cloned.
Valid options: string.

##### `user_home`

The user home path where .dotfiles directory is cloned.
Valid options: string containing an absolute path.
Defaults to $title.

##### `create_bash_aliases`

Specifies whether symlink '.bash_aliases -> .dotfiles/bash_aliases' is created.
Valid options: 'true', 'false'.
Defaults to 'false'.

## Limitations

This module only deploys a .dotfiles directory from repository [teleivo/dotfiles](https://github.com/teleivo/dotfiles).  
This module is currently only tested on Ubuntu 14.04 64bit.  

## Development

Please feel free to open pull requests!

### Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To install all dependencies for the testing environment:
```bash
sudo gem install bundler
bundle install
```

To run tests, lint and syntax checks once:
```bash
bundle exec rake test
```

To run the tests on any change of puppet files in the manifests folder:
```bash
bundle exec guard
```

