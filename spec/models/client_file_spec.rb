require 'rails_helper'

RSpec.describe ClientFile, type: :model do
  let!(:client_file) { create(:client_file) }

  describe 'validations' do
    it { should have_db_column(:histogram_words) }
  end

  describe 'associations' do
    it { should have_one_attached(:file) }
  end

  describe "validates content type is plain text" do
    context 'when file is image/jpeg' do
      before { client_file.file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test.jpg'), 'image/jpg') }
      subject { client_file.save }

      it 'returns invalid format errors' do
        subject
        expect(client_file.errors.messages).to have_key(:file)
        expect(client_file.errors[:file]).to eq(['file should be one of text/plain'])
      end
    end
  end

  describe "validates file has minimum content" do
    context 'when file has 1 words' do
      before { client_file.file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test_short.txt'), 'text/plain') }
      subject { client_file.save }

      it 'returns invalid content' do
        subject
        expect(client_file.errors.messages).to have_key(:file)
        expect(client_file.errors[:file]).to eq(['body content most have more than one word'])
      end
    end
  end

  describe "file_attached" do
    it "should have a file attached" do
      expect(client_file.file.attached?).to be true
    end
  end

  describe '#update_histogram!' do
    context 'when file is valid and has attachment' do
      before { client_file.update_columns(histogram_words: {}) }
      subject { client_file.update_histogram! }
      let(:expected_histogram_words) do
      	[
      	  { 'word': 'lumu', 'count': 6 }.with_indifferent_access,
      	  { 'word': 'illuminates', 'count': 3 }.with_indifferent_access,
      	  { 'word': 'attacks', 'count': 2 }.with_indifferent_access,
      	  { 'word': 'and', 'count': 2 }.with_indifferent_access,
      	  { 'word': 'adversaries', 'count': 2 }.with_indifferent_access,
      	  { 'word': 'all', 'count': 1 }.with_indifferent_access
      	]
      end

      it 'updates histogram words' do
        subject
        expect(client_file.histogram_words).to be_present
        expect(client_file.histogram_words).to eq(expected_histogram_words)
      end
    end
  end

  describe "#get_histogram" do
    context 'when call method' do
      let(:expected_response) do
      	[
      	  { word: 'lumu', count: 6 },
      	  { word: 'illuminates', count: 3 },
      	  { word: 'attacks', count: 2 },
      	  { word: 'and', count: 2 },
      	  { word: 'adversaries', count: 2 },
      	  { word: 'all', count: 1 }
      	]
      end
      subject { client_file.get_histogram }

      it "should return an histogram sorted" do
        expect(subject).to eq(expected_response)
      end
    end
  end
end
