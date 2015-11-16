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
    it { 
      is_expected.not_to contain_file($user_home + "/.bash_aliases")
    }

    it 'should report an error when create_bash_aliases is not true or false' do
      params.merge!({'create_bash_aliases' => 'invalid_val'})
      expect { catalogue }.to raise_error(Puppet::Error)
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
  end
end
