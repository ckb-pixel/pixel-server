class CreateOutputs < ActiveRecord::Migration[6.0]
  def change
    create_table :outputs do |t|
      t.string :block_hash
      t.decimal :capacity, precision: 30
      t.boolean :cellbase
      t.string :lock_args
      t.string :lock_code_hash
      t.string :lock_hash_type
      t.string :type_args
      t.string :type_code_hash
      t.string :type_hash_type
      t.integer :cell_index
      t.string :tx_hash
      t.binary :data
      t.integer :output_data_len
      t.integer :cell_type, default: 0
      t.string :lock_hash
      t.string :type_hash
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
