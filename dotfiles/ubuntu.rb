require 'ftools'
require 'rubygems'
require 'highline/import'

DOTFILES             = {'profile' => 'bashrc','gitconfig' => 'gitconfig'}
HOME_DIRECTORY       = "/home/#{`whoami`.gsub!(/\n/, "")}/"
REPOSITORY_DIRECTORY = "#{HOME_DIRECTORY}.config/repository/dotfiles/"

def symlink(source, destination)
  `ln -s #{REPOSITORY_DIRECTORY}#{source} #{HOME_DIRECTORY}.#{destination}`
  puts "Symlinking .#{destination} from #{REPOSITORY_DIRECTORY}#{source}"
end

def archive_existing(file)
  if File.exists?("#{HOME_DIRECTORY}.#{file}") && !File.symlink?("#{HOME_DIRECTORY}.#{file}")
    `mv #{HOME_DIRECTORY}#{file} #{HOME_DIRECTORY}#{file}.bak`
    puts "Archiving old #{file} to #{file}.bak"
  elsif File.symlink?("#{HOME_DIRECTORY}.#{file}")
    `rm #{HOME_DIRECTORY}.#{file}`
    puts "Removing old symlink .#{file}"
  else
    puts ".#{file} does not currently exist in your home directory"
  end
end


if __FILE__ == $0

  choose do |menu|
    menu.prompt = <<-EOF
    Installing the dotfiles archives exiting dotfiles in your home directory which are to be replaced and symlinks the dotfiles in the repository to the appropriate files your home directory.
    EOF

    menu.choice(:install_dotfiles){
      DOTFILES.keys.each do |file|
        archive_existing(DOTFILES[file])
        symlink(file, DOTFILES[file])
      end
    }
  end

end
