class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.float :money, scale: 2
      t.integer :pin

      t.timestamps
    end
  end
end
