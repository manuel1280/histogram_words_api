# == Schema Information
#
# Table name: client_files
#
#  id              :bigint           not null, primary key
#  histogram_words :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class ClientFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
