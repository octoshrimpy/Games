require 'rack'
require 'json'

class String
  def to_query
    replace_syms = self.gsub(/([^\"])(\w+)(:)/) {"#{$1}\"#{$2}\":"}.gsub(/(:)(\w+)([^\"])/) {"\"#{$2}\"#{$3}"}
    Rack::Utils.build_nested_query(JSON.parse(replace_syms)) rescue puts "Failed: #{replace_syms}"
  end
end

if ARGV.count != 1
  puts "Must pass a single stringified hash"
else
  puts ARGV[0].to_s.to_query
end
