# frozen_string_literal: true

class PixelCellRecordingSerializer
  include FastJsonapi::ObjectSerializer
  attribute :pixel_cells do |object|
    Output.where(id: object.cell_ids).pluck(:data)
  end
end
