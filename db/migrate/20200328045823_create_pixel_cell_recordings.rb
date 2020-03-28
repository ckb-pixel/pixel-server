# frozen_string_literal: true

class CreatePixelCellRecordings < ActiveRecord::Migration[6.0]
  def change
    create_table :pixel_cell_recordings do |t|
      t.string :block_hash
      t.integer :cell_ids, array: true
      t.integer :status

      t.timestamps
    end
  end
end
