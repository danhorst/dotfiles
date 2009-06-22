require 'ftools'
require 'rubygems'
require 'highline/import'

DOTFILES             = ['profile','bashrc','preexec.bash','gitconfig']
HOME_DIRECTORY       = "/Users/danh/"
REPOSITORY_DIRECTORY = "/Users/danh/bin/dotfiles/"

def symlink(file)
  `ln -s #{REPOSITORY_DIRECTORY}#{file} #{HOME_DIRECTORY}.#{file}`
  puts "Symlinking #{file}"
end

def archive_existing(file)
  if File.exists?("#{HOME_DIRECTORY}.#{file}") && !File.symlink?("#{REPOSITORY_DIRECTORY}.#{file}")
    `mv #{HOME_DIRECTORY}#{file} #{HOME_DIRECTORY}#{file}.bak`
    puts "Archiving old #{file}"
    symlink(file)
  else
    puts ".#{file} is not a file in your home directory. No action has been taken."
  end
end

def copy_existing(file)
  if File.exists?("#{HOME_DIRECTORY}.#{file}") && !File.symlink?("#{HOME_DIRECTORY}.#{file}")
    `mv #{HOME_DIRECTORY}.#{file} #{REPOSITORY_DIRECTORY}#{file}`
    puts "Moving #{file}"
    symlink(file)
  else
    puts ".#{file} is not a file in your home directory. No action has been taken."
  end
end

if __FILE__ == $0

  choose do |menu|
    menu.prompt = <<-EOF
    Installing the dotfiles archives any exiting dotfiles you may have in your home directory and symlinks the dotfiles in the repository into your home directory.
    Initializing the dotfile repository copies any dotfiles present in your home direcotry over top of those in the repository.
    EOF

    menu.choice(:install_dotfiles)    { DOTFILES.each {|d| archive_existing(d)} }
    menu.choice(:initialize_dotfiles) { DOTFILES.each {|d| copy_existing(d)} }
  end

end
