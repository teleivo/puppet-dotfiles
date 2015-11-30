require 'spec_helper'

describe 'dotfiles', :type => :define do
  context 'on Ubuntu 14.04 64bit' do
    $user = 'teleivo'
    $user_home = '/home/teleivo'
    $dotfiles_path = $user_home + "/.dotfiles"

    let(:title) { $user_home }

    let(:valid_required_params) do
      { 
        :user => $user,
      }
    end

    context 'with only required parameters given' do
      let :params do
        valid_required_params
      end
      it { is_expected.to contain_vcsrepo($dotfiles_path)
        .with(
          'ensure'   => 'latest',
          'provider' => 'git',
          'source'   => 'https://github.com/teleivo/dotfiles.git',
          'user'     => $user,
        )
      }
      it { is_expected.not_to contain_file($user_home + "/.bash_aliases") }
      it { is_expected.not_to contain_file($user_home + "/.gitconfig") }
      it { is_expected.not_to contain_file($user_home + "/.bashrc_git") }
    end

    context 'with invalid parameters' do
      describe 'when user is not a string' do
        let :params do
          valid_required_params.merge({
            :user => true,
          })
        end
        it { should_not compile }
      end

      describe 'when user_home is not an absolute path' do
        let :params do
          valid_required_params.merge({
            :user_home => 'home/teleivo',
          })
        end
        it { should_not compile }
      end

      describe 'when create_bash_aliases is not true or false' do
        let :params do
          valid_required_params.merge({
            :create_bash_aliases => 'invalid_val',
          })
        end
        it { should_not compile }
      end

      describe 'when create_gitconfig is not true or false' do
        let :params do
          valid_required_params.merge({
            :create_gitconfig => 'invalid_val',
          })
        end
        it { should_not compile }
      end

      describe 'when manage_gitprompt is not true or false' do
        let :params do
          valid_required_params.merge({
            :manage_gitprompt => 'invalid_val',
          })
        end
        it { should_not compile }
      end
    end
    
    context 'with required parameters and custom parameters given' do
      describe 'with create_bash_aliases = true' do
        let :params do
          valid_required_params.merge({
            :create_bash_aliases => true,
          })
        end

        it { is_expected.to contain_file($user_home + "/.bash_aliases")
          .with(
            'ensure'  => 'link',
            'owner'   => $user,
            'target'  => $dotfiles_path + "/bash_aliases",
            'require' => "Vcsrepo[" + $dotfiles_path + "]",
          )
        }
      end

      describe 'with create_gitconfig = true' do
        let :params do
          valid_required_params.merge({
            :create_gitconfig => true,
          })
        end

        it { is_expected.to contain_file($user_home + "/.gitconfig")
          .with(
            'ensure' => 'link',
            'owner'   => $user,
            'target'  => $dotfiles_path + "/gitconfig",
            'require' => "Vcsrepo[" + $dotfiles_path + "]",
          )
        }
      end

      describe 'with manage_gitprompt = true' do
        let :params do
          valid_required_params.merge({
            :manage_gitprompt => true,
          })
        end
        it { is_expected.to contain_file($user_home + "/.bashrc_git")
          .with(
            'ensure'  => 'link',
            'owner'   => $user,
            'target'  => $dotfiles_path + "/bashrc_git",
            'require' => "Vcsrepo[" + $dotfiles_path + "]",
          )
        }
        it { is_expected.to contain_file_line($user + "_bashrc_gitprompt")
          .with(
            'ensure'  => 'present',
            'path'    => $user_home + "/.bashrc",
            'line'    => '[ -f ~/.bashrc_git ] && . ~/.bashrc_git',
            'require' => "File[" + $user_home + "/.bashrc_git]",
          )
        }
      end
    end
  end
end
