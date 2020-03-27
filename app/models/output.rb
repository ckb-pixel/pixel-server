# frozen_string_literal: true

class Output < ApplicationRecord
  MAX_PAGINATES_PER = 100
  paginates_per 10
  max_paginates_per MAX_PAGINATES_PER

  enum cell_type: { normal: 0, pixel: 1 }
  enum status: { dead: 0, live: 1 }
end

# == Schema Information
#
# Table name: outputs
#
#  id              :bigint           not null, primary key
#  block_hash      :string
#  capacity        :decimal(30, )
#  cell_index      :integer
#  cell_type       :integer          default("normal")
#  cellbase        :boolean
#  data            :binary
#  lock_args       :string
#  lock_code_hash  :string
#  lock_hash       :string
#  lock_hash_type  :string
#  output_data_len :integer
#  status          :integer          default("live")
#  tx_hash         :string
#  type_args       :string
#  type_code_hash  :string
#  type_hash       :string
#  type_hash_type  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_outputs_on_tx_hash_and_cell_index  (tx_hash,cell_index) UNIQUE
#
