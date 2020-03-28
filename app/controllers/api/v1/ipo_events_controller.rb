class Api::V1::IpoEventsController < ApplicationController
  def index
    ipo_events = IpoEvent.recent.pending.limit(15)
    render json: IpoEventSerializer.new(ipo_events)
  end
end
