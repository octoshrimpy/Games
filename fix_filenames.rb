require 'json'
@images = Dir.glob("../Portfolio/app/assets/images/rpg/**/*.png")

def rename(old_path, new_path)
  return unless new_path != old_path
  puts "OLD: \e[31m#{old_path}\e[0m\nNEW: \e[32m#{new_path}\e[0m"
  `mv #{old_path} #{new_path}`
end

def remove_nested_filenames
  @images.each do |old_path|
    new_path = old_path.dup
    *folders, filename = new_path.split("/")
    folders.reverse.each do |folder_name|
      escaped_folder = Regexp.escape(folder_name)
      new_path.gsub!(/_#{escaped_folder}|#{escaped_folder}_/, "")
    end
    rename(old_path, new_path)
  end
end

def rename_nested_images
  @images.each do |old_path|
    *folders, filename = old_path.split("/")
    if folders.last == filename.split(".").first
      new_path = (folders + ["light_purple.png"]).join("/")
      rename(old_path, ne
      w_path)
    end
  end
end

def flip_hair_colors
  images = Dir.glob("../Portfolio/app/assets/images/rpg/*/hair/**/*_*.png")
  images.each do |img_path|
    *folders, filename = img_path.split("/")
    new_filename = filename.split("_").reverse.join("_")
    new_path = (folders + [new_filename]).join("/")
    rename(img_path, new_path)
  end
end

def fix_broken_flips
  images = Dir.glob("../Portfolio/app/assets/images/rpg/*/hair/**/*.png_*")
  images.each do |img_path|
    new_path = img_path.gsub(/\.png(\w*)/, '\1' + ".png")
    rename(img_path, new_path)
  end
end

# permitted = {}
# @images.each do |img_path|
#   tree = img_path.gsub("../Portfolio/app/assets/images/rpg/", "").gsub(".png", "").split("/")
#   current_tree = permitted
#   tree.each_with_index do |branch, idx|
#     if idx == tree.length - 1
#       current_tree << branch
#       current_tree.uniq!
#     elsif idx == tree.length - 2
#       current_tree[branch.to_sym] ||= []
#       current_tree = current_tree[branch.to_sym]
#     else
#       current_tree[branch.to_sym] ||= {}
#       current_tree = current_tree[branch.to_sym]
#     end
#   end
# end
# puts "#{permitted.to_json}"

def batch_rename(rename_hash, options={})
  exact_match_required = options[:exact] || false
  rename_hash.each do |name_to_replace, name_for_replace|
    @images.each do |img_path|
      *folders, filename = img_path.split("/")
      next unless filename.include?(name_to_replace)
      if exact_match_required
        new_name = filename.split(".").first == name_to_replace ? name_for_replace : filename
      else
        new_name = filename.gsub(name_to_replace, name_for_replace)
      end
      new_path = (folders + [new_name]).join("/")
      rename(img_path, new_path)
    end
  end
end
# exact_renames = {
#   "blonde" => "gold",
#   "blonde2" => "blonde",
#   "blue2" => "light_blue",
#   "brown2" => "light_brown",
#   "d" => "light_purple",
#   "brunette2" => "maroon",
#   "gold" => "yellow",
#   "gray" => "gray_dark",
#   "gray2" => "gray_light",
#   "green2" => "light_green",
#   "light_blonde" => "fire_blonde",
#   "light_blonde2" => "orange_blonde",
#   "dark_blonde" => "autumn_blonde",
#   "pink2" => "hot_pink",
#   "raven2" => "light_raven",
#   "redhead" => "red",
#   "redhead2" => "ginger",
#   "white_blonde" => "sandy_blonde",
#   "white_blonde2" => "dirty_blonde"
# }
# batch_rename(exact_renames, exact: true)
# fuzzy_renames = {
#   "_longsleeve" => "",
# }
# batch_rename(fuzzy_renames)

def fix_extensions
  files_only = Dir.glob("../Portfolio/app/assets/images/rpg/**/*").select { |e| File.file? e }
  files_only.each do |img_path|
    next if img_path[-4..-1] == ".png"
    *folders, filename = img_path.split("/")
    new_filename = [filename.split("."), "png"].join(".")
    new_path = (folders + [new_filename]).join("/")
    rename(img_path, new_path)
  end
end
