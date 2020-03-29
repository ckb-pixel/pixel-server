# frozen_string_literal: true

class Api::V1::PixelCellRecordingsController < ApplicationController
  before_action :pagination_params, only: :index

  def index
    recordings = PixelCellRecording.normal
    render json: PixelCellRecordingSerializer.new(recordings)
  end

  private
    def pagination_params
      @page = params[:page] || 1
      @page_size = params[:page_size] || PixelCellRecording.default_per_page
    end
end
