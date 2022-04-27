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
  validates :file, file_content_type: { allow: ['text/plain'] }

  def get_histogram
    {'hola': self.file.attachment.blob.download.to_s}
  end
end
