class IpoEventSerializer
  include FastJsonapi::ObjectSerializer
  attributes :from_address, :capacity, :block_hash, :block_number, :block_timestamp
end
