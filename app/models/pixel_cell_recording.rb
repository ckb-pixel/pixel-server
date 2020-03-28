  # frozen_string_literal: true

  class PixelCellRecording < ApplicationRecord
    MAX_PAGINATES_PER = 10
    paginates_per 1
    max_paginates_per MAX_PAGINATES_PER
    enum status: { forked: 0, normal: 1 }

    def record
      block_hash = SyncInfo.recent.completed.first.tip_block_hash
      cell_ids = Output.pixel.live.official_pixels.ids
      PixelCellRecording.create(block_hash: block_hash, cell_ids: cell_ids, status: "normal")
    end
  end

# == Schema Information
#
# Table name: pixel_cell_recordings
#
#  id         :bigint           not null, primary key
#  block_hash :string
#  cell_ids   :integer          is an Array
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
