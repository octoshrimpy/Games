require 'net/http'
require 'json'
require 'time'

TableRow = Struct.new(:id, :size, :model, :color, :price, :discount, :flop_reason, :firmness, :cum_tube, :suction, :img, :form)

def build_structs_from_page(page=0)
  adoptions = []
  http_source = Net::HTTP.get('bad-dragon.com', "/inventorytoys/showlist/all/id/desc/all/#{page*100}")
  http_source.gsub(/<tr(.|\n)*?<\/tr>/) do |tr|
    adoption_attrs = []
    tr.gsub(/<td(.|\n)*?<\/td>/) do |td|
      td_content = td.gsub(/(<td(.|\n)*?>)|(<\/td>)/, "")
      image_content = ""
      td_content.gsub(/<a href="(.|\n)*?">/) do |image_a_tag|
        image_content = image_a_tag.gsub(/<a href="|">/, "")
      end
      td_content = image_content if image_content.length > 10
      adoption_attrs << td_content
    end
    adoptions << TableRow.new(*adoption_attrs)
  end
  adoptions
end

def convert_to_json(adoptions)
  adoption_json = {}
  adoptions.each do |adoption|
    next if adoption.id.nil?
    adoption_json[adoption.id] = {
      size: adoption.size,
      model: adoption.model,
      color: adoption.color,
      price: adoption.price,
      discount: adoption.discount,
      flop_reason: adoption.flop_reason,
      firmness: adoption.firmness,
      cum_tube: adoption.cum_tube == "Yes",
      suction: adoption.suction == "Yes",
      img: adoption.img
    }
  end
  adoption_json
end

def output_json_to_file(json)
  File.open("dragons.js", "w") do |f|
    f.puts "last_updated = Date.parse(\"#{Time.now.rfc2822}\");\ndragons_js = #{JSON.pretty_generate(json)}"
  end
end

def reload_dragons!
  adoption_list = []
  page = 0

  loop do
    new_adoptions = build_structs_from_page(page)
    page += 1
    adoption_list += new_adoptions
    break if new_adoptions.count < 100
  end

  json_adoptions = convert_to_json(adoption_list)

  output_json_to_file(json_adoptions)
end

reload_dragons!
