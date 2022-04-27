class Api::V1::HistogramWordsController < ApplicationController

  def create

  end

  def show
    @client_histogram = ClientFile.find(params[:id]).histogram_words
    render json: @client_histogram
  end

  private

  def client_file_params
    params.permit(:file)
  end
end
