require 'rails_helper'

RSpec.describe ClientFile, type: :model do
  before(:all) do
    @file = ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join('spec', 'files', 'words_test.txt'), 'rb'),
        filename: 'words_test.txt',
        content_type: 'text/plain'
    )
    @bad_file = ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join('spec', 'files', 'words_test.jpg')),
        filename: 'words_test.jpg',
        content_type: 'image/jpg'
    )
    @bad_file_short = ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join('spec', 'files', 'words_test_short.txt')),
        filename: 'words_test_short.txt',
        content_type: 'text/plain'
    )
  end

  before(:each) do
    ClientFile.create!(file: @file)
  end

  it "validates content type is plain text" do
    client_file = ClientFile.new(file: @bad_file)
    client_file.save
    expect(client_file.errors[:file]).to eq(["file should be one of text/plain"])
  end

  it "validates file has minimum content" do
    client_file = ClientFile.new(file: @bad_file_short)
    client_file.save
    expect(client_file.errors[:file]).to eq(["body content most have more than one word"])
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

  describe "#get_histogram" do
    it "should return an histogram sorted" do
      expected = [
          { word: 'lumu', count: 6 },
          { word: 'illuminates', count: 3 },
          { word: 'attacks', count: 2 },
          { word: 'and', count: 2 },
          { word: 'adversaries', count: 2 },
          { word: 'all', count: 1 }
      ]
      expect(ClientFile.last.get_histogram).to eq(expected)
    end
  end
end
