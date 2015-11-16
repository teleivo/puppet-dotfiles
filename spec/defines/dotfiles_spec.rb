require 'spec_helper'

describe 'dotfiles', :type => :define do
  context 'on Ubuntu 14.04 64bit' do
    $user = 'teleivo'
    $user_home = '/home/teleivo'
    $dotfiles_path = $user_home + "/.dotfiles"

    let(:title) { $user_home }

    let(:params) {
      { 
        'user' => $user,
      }
    }

    it { is_expected.to contain_vcsrepo($dotfiles_path)
      .with(
        'ensure'   => 'present',
        'provider' => 'git',
        'source'   => 'https://github.com/teleivo/dotfiles.git',
        'user'     => $user,
      )
    }
    it { is_expected.not_to contain_file($user_home + "/.bash_aliases") }
    it { is_expected.not_to contain_file($user_home + "/.gitconfig") }
    it { is_expected.not_to contain_file($user_home + "/.bashrc_git") }

    it 'should not compile when user is not a string' do
      params.merge!({'user' => true})
      should_not compile
    end

    it 'should not compile when user_home is not an absolute path' do
      params.merge!({'user_home' => 'home/teleivo'})
      should_not compile
    end

    it 'should not compile when create_bash_aliases is not true or false' do
      params.merge!({'create_bash_aliases' => 'invalid_val'})
      should_not compile
    end
    it 'should create .bash_aliases symlink with create_bash_aliases set to true' do
      params.merge!({'create_bash_aliases' => true})

      is_expected.to contain_file($user_home + "/.bash_aliases")
        .with(
          'ensure' => 'link',
          'owner'  => $user,
          'target' => $dotfiles_path + "/bash_aliases",
        )
    end

    it 'should not compile when create_gitconfig is not true or false' do
      params.merge!({'create_gitconfig' => 'invalid_val'})
      should_not compile
    end
    it 'should create .gitconfig symlink with create_gitconfig set to true' do
      params.merge!({'create_gitconfig' => true})

      is_expected.to contain_file($user_home + "/.gitconfig")
        .with(
          'ensure' => 'link',
          'owner'  => $user,
          'target' => $dotfiles_path + "/gitconfig",
        )
    end

    it 'should not compile when manage_gitprompt is not true or false' do
      params.merge!({'manage_gitprompt' => 'invalid_val'})
      should_not compile
    end
    it 'should create .bashrc_git symlink and source it in bashrc with manage_gitprompt set to true' do
      params.merge!({'manage_gitprompt' => true})

      is_expected.to contain_file($user_home + "/.bashrc_git")
        .with(
          'ensure' => 'link',
          'owner'  => $user,
          'target' => $dotfiles_path + "/bashrc_git",
        )

      is_expected.to contain_file_line($user + "_bashrc_gitprompt")
        .with(
          'ensure' => 'present',
          'path'   => $user_home + "/.bashrc",
          'line'   => '[ -f ~/.bashrc_git ] && . ~/.bashrc_git',
        )
    end
  end
end
