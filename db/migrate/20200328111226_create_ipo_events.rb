# frozen_string_literal: true

class CreateIpoEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :ipo_events do |t|
      t.string :from_address
      t.string :to_address
      t.decimal :capacity, precision: 30
      t.string :block_hash
      t.integer :status, default: 1
      t.string :block_timestamp
      t.string :block_number

      t.timestamps
    end
  end
end
