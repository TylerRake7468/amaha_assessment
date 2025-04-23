class CustomersController < ApplicationController
  def import
    file = params[:file]
    return render json: { error: 'File is missing' }, status: :bad_request unless file

    result = Customers::FilterService.new(file).process_file

    render json: {
      customers: result[:matching_customers],
      errors: result[:errors]
    }, status: :ok
  end
end
