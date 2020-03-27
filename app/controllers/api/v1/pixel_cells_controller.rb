# frozen_string_literal: true

class Api::V1::PixelCellsController < ApplicationController
  before_action :pagination_params, only: :index
  def index
    pixel_cells = Output.pixel.live.page(@page).per(@page_size)
    render json: OutputSerializer.new(pixel_cells)
  end

  private
    def pagination_params
      @page = params[:page] || 1
      @page_size = params[:page_size] || Output.default_per_page
    end
end
