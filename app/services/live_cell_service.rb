# frozen_string_literal: true

class LiveCellService
  attr_reader :address, :need_capacity, :lock_hash, :live_cells, :current_epoch_number

  def initialize(address:, need_capacity:)
    @address = address
    @need_capacity = need_capacity.to_i
    @lock_hash = CKB::AddressParser.new(address).parse.script.compute_hash
    @current_epoch_number = Api.instance.get_current_epoch.number
    @live_cells = []
  end

  def find!
    collector.each do |output|
      @live_cells << output

      return if capacity_enough?
    end

    raise "collected inputs not enough"
  end

  private
    def capacity_enough?
      puts "live_cells_capacity: #{live_cells_capacity}"
      live_cells_capacity >= need_capacity
    end

    def collector
      collector = Collector.new.default_scanner(lock_hash)
      Enumerator.new do |result|
        loop do
          output = collector.next
          if output.output_data_len == 0 && output.type_code_hash.nil?
            next if output.cellbase && (current_epoch_number - output.epoch_number <= 4)

            result << output
          end
          result << output
        rescue StopIteration
          break
        end
      end
    end

    def live_cells_capacity
      live_cells.map(&:capacity).sum
    end
end
