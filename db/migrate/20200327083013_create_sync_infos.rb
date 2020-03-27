# frozen_string_literal: true

class CreateSyncInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :sync_infos do |t|
      t.bigint :tip_block_number
      t.string :tip_block_hash
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
