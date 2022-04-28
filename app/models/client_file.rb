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
  validate :file_has_minimum_content

  def update_histogram!
    self.update_columns(histogram_words: get_histogram)
  end

  def get_histogram
    words_array = self.get_content_normalized.split(' ')
    histogram = words_array.uniq.map do |word|
      { word: word, count: words_array.count(word) }
    end
    histogram.sort_by{|e| -e[:count]}
  end

  def get_content_normalized
    text = self.file.attachment.blob.download.squish
    text = I18n.transliterate(text)
    text = text.downcase
    text.gsub(/[^0-9A-Za-z]/, ' ')
  end

  private

  def file_has_minimum_content
    text = self.attachment_changes['file']&.attachable.try(:read) || self.file.attachment.blob.download
    if text.split(' ').count < 2
      errors.add(:file, 'body content most have more than one word')
    end
  end
end
