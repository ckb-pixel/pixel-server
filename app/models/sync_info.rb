# frozen_string_literal: true

class SyncInfo < ApplicationRecord
  enum status: { pending: 0, completed: 1, forked: 2 }

  scope :recent, -> { order(tip_block_number: :desc) }
end

# == Schema Information
#
# Table name: sync_infos
#
#  id               :bigint           not null, primary key
#  status           :integer          default("pending")
#  tip_block_hash   :string
#  tip_block_number :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
