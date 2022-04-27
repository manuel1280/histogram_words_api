class Api::V1::HistogramWordsController < ApplicationController

  def create
    @client_file = ClientFile.new
    @client_file.file.attach(client_file_params[:file])
    if @client_file.save
      render json: @client_file.get_histogram, status: :ok
    else
      render json: @client_file.errors.messages, status: :not_acceptable
    end
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
