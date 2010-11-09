#!/usr/bin/env ruby

VALID_FILE_PATTERN = /\.(js|css)$/
@extension = ""

def options
  # NOTE case sensitive filename
  "--line-break 0" if @extension == "css"
  "--line-break 512"
end

def minify_file(input_file)
  `java -jar /home/dbrubak1/bin/yuicompressor-2.4.2.jar #{input_file}.#{@extension} -o #{input_file}.min.#{@extension} --charset utf-8 #{options}`
end

if ARGV.empty?
  log "Please enter the filename of the JavaScript or CSS file to be minified."
  Kernel::exit
end

ARGV.each do |file|
  if File.exists? file
    @extension = File.basename(file).split('.').last
    if file.match(VALID_FILE_PATTERN)
      minify_file file.gsub(VALID_FILE_PATTERN, '')
    else
      puts "The file:\n#{file}\nMust be a JavaScript file with an extension of \".js\" or a CSS file with an extension of \".css\"."
    end
  else
    puts "The file:\n#{file}\nDoes not exist."
  end
end
