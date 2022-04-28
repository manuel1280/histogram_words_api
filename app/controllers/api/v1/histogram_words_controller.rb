class Api::V1::HistogramWordsController < ApplicationController

  def create
    @client_file = ClientFile.new
    @client_file.file.attach(client_file_params[:file])
    if @client_file.save
      @client_file.update_histogram!
      render json: { 'id': @client_file.id, 'data': @client_file.histogram_words }, status: :ok
    else
      render json: @client_file.errors.messages, status: :unprocessable_entity
    end
  end

  def show
    @client_histogram = ClientFile.find_by(id: params[:id])
    if @client_histogram.present? && @client_histogram.histogram_words
      render json: @client_histogram.histogram_words
    else
      render json: {'id': params[:id]}, status: :not_found
    end
  end

  private

  def client_file_params
    params.permit(:file)
  end
end
