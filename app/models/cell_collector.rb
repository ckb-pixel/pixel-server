# frozen_string_literal: true

class CellCollector
  attr_reader :api
  def initialize(api)
    @api = api
  end
  def default_scanner(lock_hash)
    cell_metas = []
    cell_meta_index = 0
    page = 0
    total_pages = Output.where(lock_hash: lock_hash).page(page).per(100).total_pages
    Enumerator.new do |result|
      loop do
        if cell_meta_index < cell_metas.size
          result << cell_metas[cell_meta_index]
          cell_meta_index += 1
        else
          cell_meta_index = 0
          cell_metas = Output.where(lock_hash: lock_hash).live.page(page).per(100).map do |cell|
            output_data_len = cell.output_data_len
            cellbase = cell.cellbase
            lock = CKB::Types::Script.new(code_hash: cell.lock_code_hash, args: cell.lock_args, hash_type: cell.lock_hash_type)
            type = cell.type_code_hash.present? ? CKB::Types::Script.new(code_hash: cell.type_code_hash, args: cell.type_args, hash_type: cell.type_hash_type) : nil
            CKB::CellMeta.new(api: api, out_point: CKB::Types::OutPoint.new(tx_hash: cell.tx_hash, index: cell.cell_index), output: CKB::Types::Output.new(capacity: cell.capacity, lock: lock, type: type), output_data_len: output_data_len, cellbase: cellbase)
          end
          page += 1
        end
        raise StopIteration if page > total_pages
      end
    end
  end
end
