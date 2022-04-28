FactoryBot.define do
  factory :client_file do
    histogram_words { { 'lumu': 10, 'illuminates': 5, 'adversaries': 4, 'threat': 3 } }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test.txt'), 'text/plain') }
  end
end
