class CustomersController < ApplicationController
  def import
    file = params[:file]
    return render json: { error: 'File is missing' }, status: :bad_request unless file

    customers = Customers::FilterService.new(file).process_file

    render json: customers, status: :ok
  end
end
