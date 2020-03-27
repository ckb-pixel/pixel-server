# frozen_string_literal: true

class Api::V1::LiveCellsController < ApplicationController
  before_action :validate_query_params

  def show
    live_cell_service = LiveCellService.new(address: params[:id], need_capacity: params[:need_capacity])
    live_cell_service.find!
    live_cells = live_cell_service.live_cells

    render json: OutputSerializer.new(live_cells)

  rescue RuntimeError => error
    render json: error, status: 200
  end

  private
    def validate_query_params
      if params[:need_capacity].blank?
        render json: "capacity cannot be blank", status: 200
      end
    end
end
