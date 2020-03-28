# frozen_string_literal: true

class Api::V1::PixelCellsController < ApplicationController
  before_action :pagination_params, only: :index
  def index
    pixel_cells = generate_fake_pixel_cells # Output.pixel.live.page(@page).per(@page_size)
    render json: OutputSerializer.new(pixel_cells)
  end

  private
    def pagination_params
      @page = params[:page] || 1
      @page_size = params[:page_size] || Output.default_per_page
    end

    def generate_fake_pixel_cells
      outputs = []
      (0..50).each do |x|
        (0..50).each do |y|
          r, g, b = rand(0..255), rand(0..255), rand(0..255)
          output =
            Output.new(
              block_hash: "0x#{SecureRandom.hex(32)}", capacity: 666*10**8, cell_index: 0, cell_type: "pixel",
              cellbase: false, epoch_number: rand(100), lock_args: "0x#{SecureRandom.hex(32)}",
              lock_code_hash: "0x#{SecureRandom.hex(32)}", lock_hash_type: "data", status: "live",
              tx_hash: "0x#{SecureRandom.hex(32)}", type_args: "0x#{SecureRandom.hex(32)}", type_code_hash: "0x#{SecureRandom.hex(32)}",
              type_hash_type: "data"
            )
          output.data = output.generate_pixel_data(x, y, r, g, b)
          output.output_data_len = CKB::Utils.hex_to_bin(output.data).bytesize
          outputs << output
        end
      end

      outputs
    end
end
