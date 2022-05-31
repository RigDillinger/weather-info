# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false, default: ""

      t.timestamps
    end

    add_index :locations, :name, unique: true
  end
end
