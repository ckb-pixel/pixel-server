# frozen_string_literal: true

class CellCache
  PIXEL_LOCK_CODE_HASH = "0xb75dae11082145889da100b87305b5579213b55a7df72818d5f57a735eb9a6e4"
  PIXEL_TYPE_CODE_HASH = "0x295c725e14ddd32019d09b1a72876d688d494281a1a973aa19eaf9a9d2e84bd1"

  def call
    sync_info = SyncInfo.recent.completed.first
    tip_block_number = Api.instance.get_tip_block_number
    target_block_number = sync_info.present? ? sync_info.tip_block_number + 1 : 0
    return if target_block_number > tip_block_number
    puts "block_number: #{target_block_number}"

    target_block = Api.instance.get_block_by_number(target_block_number)

    if !forked?(target_block, sync_info)
      process_block(target_block)
    else
      revert_sync_info(sync_info)
    end
  end

  private
    def revert_sync_info(sync_info)
      ApplicationRecord.transaction do
        sync_info.update(status: "forked")
        Output.where(block_hash: sync_info.tip_block_hash).delete_all
      end
    end

    def process_block(target_block)
      ApplicationRecord.transaction do
        create_sync_info(target_block)
        create_output(target_block)
      end
    end

    def create_output(target_block)
      target_block.transactions.each_with_index do |transaction, tx_index|
        consume_cell(transaction)
        save_outputs(target_block.header.hash, tx_index, transaction)
      end
    end

    def save_outputs(block_hash, tx_index, transaction)
      outputs, outputs_data = transaction.outputs, transaction.outputs_data
      attributes =
        outputs.each_with_index.map do |output, cell_index|
          {
            block_hash: block_hash, capacity: output.capacity, cell_index: cell_index,
            cell_type: cell_type(output), cellbase: cellbase(tx_index), data: outputs_data[cell_index],
            lock_hash: output.lock.compute_hash, lock_args: output.lock.args, lock_code_hash: output.lock.code_hash,
            lock_hash_type: output.lock.hash_type, type_hash: output.type&.compute_hash, type_args: output.type&.args,
            type_code_hash: output.type&.code_hash, type_hash_type: output.type&.hash_type,
            output_data_len: output.calculate_bytesize(outputs_data[cell_index]), tx_hash: transaction.hash,
            created_at: Time.now, updated_at: Time.now
          }
        end
      return if attributes.blank?

      Output.insert_all!(attributes)
    end

    def cellbase(tx_index)
      tx_index.zero?
    end

    def cell_type(output)
      if output.lock.compute_hash == PIXEL_LOCK_CODE_HASH && output.type.compute_hash == PIXEL_TYPE_CODE_HASH
        Output.cell_types[:pixel]
      else
        Output.cell_types[:normal]
      end
    end

    def consume_cell(transaction)
      inputs = transaction.inputs.select { |input| input.previous_output.tx_hash != "0x0000000000000000000000000000000000000000000000000000000000000000" }
      attributes = inputs.map do |input|
        { tx_hash: input.previous_output.tx_hash, cell_index: input.previous_output.index, status: Output.statuses[:dead], created_at: Time.now, updated_at: Time.now }
      end
      return if attributes.blank?

      Output.upsert_all(attributes, unique_by: :index_outputs_on_tx_hash_and_cell_index)
    end

    def create_sync_info(target_block)
      SyncInfo.create!(tip_block_number: target_block.header.number, tip_block_hash: target_block.header.hash, status: "completed")
    end

    def forked?(target_block, sync_info)
      return false if sync_info.blank?

      target_block.header.parent_hash != sync_info.tip_block_hash
    end
end
