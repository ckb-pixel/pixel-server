class GeneratePixelCanvas
  attr_reader :pixel_data, :key_address_pairs, :api, :contexts, :input_script

  def initialize(pixel_data, key_address_pairs, api)
    @api = api
    @pixel_data = pixel_data
    @key_address_pairs = key_address_pairs
    @contexts = [key_address_pairs[0]]
    @input_script = CKB::AddressParser.new(key_address_pairs[1]).parse.script
  end

  def call
    tx_generator = build(contexts: contexts)
    tx = sign(tx_generator: tx_generator, contexts: contexts)
    api.send_transaction(tx)
  end

  private

  def build(contexts: [], fee_rate: 1)
    cell_outputs = outputs.dup
    cell_outputs_data = outputs_data.dup
    if cell_outputs.all? { |output| output.capacity > 0 }
      cell_outputs << CKB::Types::Output.new(capacity: 0, lock: input_script, type: nil)
      cell_outputs_data << "0x"
    end
    pixel_lock_cell_dep = CKB::Types::CellDep.new(out_point: CKB::Types::OutPoint.new(tx_hash: "0x42bbf1806f8baf8bd6b16c0682157dc717c3d021644aae108e03e452479199b1", index: 0))
    pixel_type_cell_dep = CKB::Types::CellDep.new(out_point: CKB::Types::OutPoint.new(tx_hash: "0x57c2344716e4ac7ef23fe84d9ebe9bf6f51079347c8f7e7796eba1dc22903b28", index: 0))
    transaction = CKB::Types::Transaction.new(
      version: 0, cell_deps: [pixel_lock_cell_dep, pixel_type_cell_dep], header_deps: [], inputs: [],
      outputs: cell_outputs, outputs_data: cell_outputs_data, witnesses: []
    )
    tx_generator = CKB::TransactionGenerator.new(api, transaction)
    tx_generator.generate(collector: collector, contexts: [input_script.compute_hash].zip(contexts).to_h, fee_rate: fee_rate)
    tx_generator
  end

  def sign(tx_generator:, contexts:)
    tx_generator.sign([input_script.compute_hash].zip(contexts).to_h)
    tx_generator.transaction
  end

  def outputs
    @outputs ||=
      begin
        pixel_lock = CKB::Types::Script.new(code_hash: "0xe959ac726354858d598c9ea1ceb5f617e409b1b0a4a3baa25aa08b6da7b95091", args: input_script.args, hash_type: "type")
        pixel_type = CKB::Types::Script.new(code_hash: "0x295c725e14ddd32019d09b1a72876d688d494281a1a973aa19eaf9a9d2e84bd1", args: input_script.compute_hash, hash_type: "data")
        (0...2500).map do
          CKB::Types::Output.new(capacity: 666*10**8, lock: pixel_lock, type: pixel_type)
        end
      end
  end

  def outputs_data
    outputs.each_with_index.map do |output, index|
      if index < 2500
        x, y, r, g, b = pixel_data[index]["coordinates"][0] / 16, pixel_data[index]["coordinates"][1] / 16, pixel_data[index]["color"][0], pixel_data[index]["color"][1], pixel_data[index]["color"][2]
        generate_pixel_data(x, y, r, g, b)
      end
    end.compact
  end

  def collector
    collector = CellCollector.new(api).default_scanner(input_script.compute_hash)
    Enumerator.new do |result|
      loop do
        cell_meta = collector.next
        if cell_meta.output_data_len == 0 && cell_meta.output.type.nil?
          result << cell_meta
        end
      rescue StopIteration
        break
      end
    end
  end

  def generate_pixel_data(x, y, r, g, b)
    result = [x, y, r, g, b].pack("C*").unpack1("H*")
    "0x#{result}"
  end
end
