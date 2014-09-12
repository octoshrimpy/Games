class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :pin
      t.string :card

      t.timestamps
    end
  end
end
