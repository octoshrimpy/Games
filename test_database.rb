require "sqlite3"
require 'pry-rails' # TODO Remove this!
require './roguelike/monkey_patches.rb'
# http://www.tutorialspoint.com/sqlite/
# http://zetcode.com/db/sqliteruby/

DEFAULT_SCHEMA = {
  name: 'TEXT',
  weight: 'INTEGER'
}

class BaseObject

  def initialize(attrs)
    to_set = symbolify_keys(attrs).filter(attributes)
    to_set.each do |key, value|
      value = true if value.is_a?(String) && value == 'true'
      value = false if value.is_a?(String) && value == 'false'
      instance_variable_set("@#{key}", value)
    end
  end

  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end

  def attributes
    self.class.attributes
  end

  def self.build_table(rows)
    attribute_string = rows.to_a.map {|row_name, row_type| "#{row_name.to_s} #{row_type}"}.join(', ')
    $sqldb.execute "CREATE TABLE #{class_name}(id INTEGER PRIMARY KEY UNIQUE NOT NULL, #{attribute_string})"
  end

  def self.all
    objs = $sqldb.execute "SELECT * FROM #{class_name}"
    objs.map { |obj| new(obj) }
  end

  def self.count
    $sqldb.get_first_row("SELECT count(id) FROM #{class_name}").first.last
  end

  def self.find(id)
    q = $sqldb.get_first_row( "SELECT * FROM #{class_name} WHERE id = ?", id )
    attrs = symbolify_keys(q)
    obj = new(attrs)
    obj.id ? obj : nil
  end

  def save
    attributes_to_set = {}
    attributes.each do |attr_key|
      val = self.method(attr_key).call
      attributes_to_set[attr_key] = val
    end
    if self.id
      update(attributes_to_set)
    else
      attributes_to_set[:id] = Schema.get_next_id('item')
      attributes_to_set = stringify_booleans(attributes_to_set)
      $sqldb.execute "INSERT INTO #{class_name}(#{attributes_to_set.keys.join(', ')}) VALUES (#{attributes_to_set.count.times.map{'?'}.join(', ')})", attributes_to_set.values
      q = $sqldb.get_first_row "SELECT id FROM item ORDER BY id DESC"
      self.class.find(q['id'])
    end
  end

  def update(attributes_to_update)
    return false unless self.id || attributes_to_update[:id]
    pairs = stringify_keys(attributes_to_update)
    pairs = stringify_booleans(pairs)
    $sqldb.execute "UPDATE #{class_name} SET #{pairs.keys.map{|k|"#{k} = ?"}.join(', ')} WHERE id = ?", pairs.values + [self.id]
    self.class.find(self.id)
  end

  def destroy
    $sqldb.execute "DELETE FROM #{class_name} WHERE id = ?", self.id
    true
  end

  def self.create(attrs)
    obj = new(attrs)
    obj.save
  end

  private

  def class_name
    self.class.class_name
  end

  def self.class_name
    @class_name ||= self.to_s.downcase
  end

  def symbolify_keys(hash); self.class.symbolify_keys(hash); end
  def self.symbolify_keys(hash)
    return {} unless hash
    new_hash = {}
    hash.each { |key, value| new_hash[key.to_s.to_sym] = value }
    new_hash
  end

  def stringify_keys(hash); self.class.stringify_keys(hash); end
  def self.stringify_keys(hash)
    return {} unless hash
    new_hash = {}
    hash.each { |key, value| new_hash[key.to_s] = value }
    new_hash
  end

  def stringify_booleans(hash); self.class.stringify_booleans(hash); end
  def self.stringify_booleans(hash)
    return {} unless hash
    new_hash = {}
    hash.each do |key, value|
      val = case value
      when true then 'true'
      when false then 'false'
      else value
      end
      new_hash[key] = val
    end
    new_hash
  end

end

class Item < BaseObject
  attr_accessor :id, :name, :power, :x, :is_big
end

class Schema
  def self.reset
    File.delete("test.db")
    $sqldb = SQLite3::Database.new "test.db"
    $sqldb.results_as_hash = true
    $sqldb.execute "CREATE TABLE constants(item_ids INTEGER)"
    $sqldb.execute "INSERT INTO constants(item_ids) VALUES (?)", 1

    Item.build_table(DEFAULT_SCHEMA.merge({
      power: 'INTEGER',
      x: 'INTEGER',
      y: 'INTEGER',
      is_big: 'TEXT'
    }))
  end

  def self.load
    $sqldb = SQLite3::Database.new "test.db"
    $sqldb.results_as_hash = true
  end

  def self.get_next_id(table)
    next_id = $sqldb.get_first_row("SELECT #{table}_ids FROM constants")["#{table}_ids"]
    $sqldb.execute "UPDATE constants SET #{table}_ids = ?", next_id + 1
    next_id
  end

end


Schema.load

item = Item.create(name: 'Hello', power: 50, coord: {x: 5, y: 9}, is_big: true)
binding.pry
#
# class Schema
#
#   def start(str)
#     reset if str == 'reset'
#     open if str == 'open'
#   end
#
#   def reset
#     File.delete("test.db")
#     # $sqldb.results_as_hash = true
#     $sqldb.execute <<-SQL
#       CREATE TABLE board(
#         depth INTEGER PRIMARY KEY UNIQUE NOT NULL,
#         dungeon TEXT
#       );
#     SQL
#     $sqldb.execute <<-SQL
#       CREATE TABLE item(
#         id INTEGER PRIMARY KEY UNIQUE NOT NULL,
#         name TEXT,
#         x INTEGER,
#         y INTEGER
#       );
#     SQL
#   end
#
#   def open
#     $sqldb = SQLite3::Database.open "test.db"
#   end
#
#   def create_board(width, height)
#     board = Array.new(height) {Array.new(width) {rand(2) == 0 ? '  ' : '# '}}
#     display = board.map {|row| row.join('')}.join('\n')
#     $sqldb.execute "INSERT INTO board(Dungeon) VALUES (?)", display
#   end
#
#   def create_item(name, coord)
#     $sqldb.execute "INSERT INTO item(name, x, y) VALUES (?, ?, ?)", name, coord[:x], coord[:y]
#   end
#
#   def find_board(id)
#     board = []
#     $sqldb.execute( "SELECT * FROM board WHERE Depth = ?", id ) do |raw_board|
#       board = raw_board["dungeon"].split('\n').map {|row| row.scan(/../)}
#     end
#     board
#   end
#
#   def draw_board(id)
#     board = find_board(id)
#     board.each {|row| puts row.join('')}
#     nil
#   end
#
#   def close
#
#   end
#
# end
#
# s = Schema.new
# s.start('open')
# # s.start('reset')
#
# s.create_board(34, 20)
# s.create_item("Sword", {x: 5, y: 10})
#
# $sqldb.close
