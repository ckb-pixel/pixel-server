# frozen_string_literal: true

class Api::V1::PixelCellsController < ApplicationController
  def index
    pixel_cells = Output.pixel.live.official_pixels
    render json: OutputSerializer.new(pixel_cells)
  end
end
