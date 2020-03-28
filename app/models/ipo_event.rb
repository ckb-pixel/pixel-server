# frozen_string_literal: true

class IpoEvent < ApplicationRecord
  enum status: { forked: 0, pending: 1, processed: 2 }
  scope :recent, -> { order(id: :desc) }
end

# == Schema Information
#
# Table name: ipo_events
#
#  id              :bigint           not null, primary key
#  block_hash      :string
#  block_number    :string
#  block_timestamp :string
#  capacity        :decimal(30, )
#  from_address    :string
#  status          :integer          default("pending")
#  to_address      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
