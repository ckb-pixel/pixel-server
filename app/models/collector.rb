# frozen_string_literal: true

class Collector
  def default_scanner(lock_hash)
    outputs = []
    output_index = 0
    page = 0
    total_pages = Output.where(lock_hash: lock_hash).page(page).per(100).total_pages
    Enumerator.new do |result|
      loop do
        if output_index < outputs.size
          result << outputs[output_index]
          output_index += 1
        else
          output_index = 0
          outputs = Output.where(lock_hash: lock_hash).live.page(page).per(100).to_a
          page += 1
        end
        raise StopIteration if page > total_pages
      end
    end
  end
end
