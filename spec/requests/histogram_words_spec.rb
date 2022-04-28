require 'rails_helper'

RSpec.describe Api::V1::HistogramWordsController, type: :request do

  describe 'POST /api/v1/histogram_words' do
    subject { post api_v1_histogram_words_path, params: { file: file } }
    
    context 'when file is valid' do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test.txt'), 'text/plain') }
      let(:expected_response) do
        {
          'id': 8,
          'data': [
      	    { 'word': 'lumu', 'count': 6 }.with_indifferent_access,
      	    { 'word': 'illuminates', 'count': 3 }.with_indifferent_access,
      	    { 'word': 'attacks', 'count': 2 }.with_indifferent_access,
      	    { 'word': 'and', 'count': 2 }.with_indifferent_access,
      	    { 'word': 'adversaries', 'count': 2 }.with_indifferent_access,
      	    { 'word': 'all', 'count': 1 }.with_indifferent_access
      	  ]
        }.to_json
      end

      it 'returns histogram words' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when format files is invalid' do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test.jpg'), 'image/jpg') }
      let(:expected_response) do
        {
            "file": [
                "file should be one of text/plain"
            ]
        }.to_json
      end

      it 'returns error invalid format' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when file has less than 2 words' do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'words_test_short.txt'), 'text/plain') }
      let(:expected_response) do
        {
            "file": [
                "body content most have more than one word"
            ]
        }.to_json
      end

      it 'returns error invalid format' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(expected_response)
      end
    end
  end

  describe 'GET /api/v1/histogram_words/:id' do
    let!(:client_file) { create(:client_file) }
    subject { get api_v1_histogram_word_path(id: client_file_id)}

    context 'when request for specific record' do
      before { client_file.update_histogram! }
      let(:client_file_id) { client_file.id }
      let(:expected_response) do
        [
          { 'word': 'lumu', 'count': 6 }.with_indifferent_access,
          { 'word': 'illuminates', 'count': 3 }.with_indifferent_access,
          { 'word': 'attacks', 'count': 2 }.with_indifferent_access,
          { 'word': 'and', 'count': 2 }.with_indifferent_access,
          { 'word': 'adversaries', 'count': 2 }.with_indifferent_access,
          { 'word': 'all', 'count': 1 }.with_indifferent_access
        ].to_json
      end
      it 'returns file data' do
      	subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expected_response)
      end
    end
    
    context 'when not found resource' do
      let(:client_file_id) { 10000000 }
      let(:expected_response) { { 'id': '10000000' }.to_json }
      
      it 'returns status not found' do
        subject
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(expected_response)
      end
    end
  end
end
