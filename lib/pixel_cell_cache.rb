# frozen_string_literal: true

require_relative "../config/environment"

loop do
  CellCache.new.call
end
