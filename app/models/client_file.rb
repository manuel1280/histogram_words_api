# == Schema Information
#
# Table name: client_files
#
#  id              :bigint           not null, primary key
#  histogram_words :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ClientFile < ApplicationRecord

  has_one_attached :file
  #validates :id_front, content_type: { in: %w(text/plain) }
end
