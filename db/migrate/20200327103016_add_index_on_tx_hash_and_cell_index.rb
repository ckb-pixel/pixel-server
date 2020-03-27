# frozen_string_literal: true

class AddIndexOnTxHashAndCellIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :outputs, [:tx_hash, :cell_index], unique: true
  end
end
