# frozen_string_literal: true

class AddEpochNumberToOutputs < ActiveRecord::Migration[6.0]
  def change
    add_column :outputs, :epoch_number, :integer
  end
end
