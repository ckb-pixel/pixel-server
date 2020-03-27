# frozen_string_literal: true

class OutputSerializer
  include FastJsonapi::ObjectSerializer
  attributes :block_hash, :cellbase

  attribute :capacity do |object|
    object.capacity.to_s
  end

  attribute :lock do |object|
    {
      args: object.lock_args,
      code_hash: object.lock_code_hash,
      hash_type: object.lock_hash_type
     }
  end

  attribute :type do |object|
    {
      args: object.type_args,
      code_hash: object.type_code_hash,
      hash_type: object.type_hash_type
     }
  end

  attribute :out_point do |object|
    { index: object.cell_index.to_s, tx_hash: object.tx_hash }
  end

  attribute :output_data do |object|
    object.data
  end

  attribute :output_data_len do |object|
    object.output_data_len.to_s
  end
end
