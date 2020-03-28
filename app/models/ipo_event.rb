# frozen_string_literal: true

class IpoEvent < ApplicationRecord
  enum status: { forked: 0, processed: 1 }
end

# == Schema Information
#
# Table name: ipo_events
#
#  id           :bigint           not null, primary key
#  block_hash   :string
#  capacity     :decimal(30, )
#  from_address :string
#  status       :integer          default("processed")
#  to_address   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
