require "evil_icons"
require "evil_icons/generator"
require "uglifier"
require 'csso'

svg_path = EvilIcons.images_dir

namespace :evil_icons do

  desc "Generate SVG icons sprite"
  task :process => [:normalize_filenames, :optimize] do
    generator = EvilIcons::Generator.new(svg_path)
    generator.generate("sprite.svg")
  end

  desc "Normalize filenames"
  task :normalize_filenames do
    filenames = Dir.entries(svg_path).select { |f| File.extname(f) == '.svg' }

    filenames.each do |old_name|
      next unless old_name.include?('_')

      new_name = File.join svg_path, old_name.gsub('_', '-')
      old_name = File.join svg_path, old_name

      File.delete(new_name) if File.exists?(new_name)
      File.rename(old_name, new_name)
    end
  end

  desc "Optimize SVG"
  task :optimize do
    system "svgo -f #{svg_path} --disable=mergePaths"
  end

end