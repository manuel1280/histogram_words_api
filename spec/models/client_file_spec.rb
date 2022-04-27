require 'rails_helper'

RSpec.describe ClientFile, type: :model do
  before(:each) do
    file = ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join('spec', 'files', 'words_test.txt'), 'rb'),
        filename: 'words_test.txt',
        content_type: 'text/plain'
    )
    ClientFile.create!(file: file)
  end

  describe "creation" do
    it "should have one item created" do
      expect(ClientFile.all.count).to eq(1)
    end
  end

  describe "file_attached" do
    it "should have a file attached" do
      expect(ClientFile.last.file.attached?).to be true
    end
  end
end
