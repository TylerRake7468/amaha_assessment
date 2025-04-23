module Customers
  class FilterService
    MUMBAI_LAT = 19.0590317
    MUMBAI_LNG = 72.7553452
    MAX_DISTANCE_KM = 100

    def initialize(file)
      @file = file
    end

    def process_file
      matching_customers = []
      errors = []

      File.foreach(@file.path).with_index(1) do |line, index|
        begin
          data = JSON.parse(line)
          lat = data["latitude"].to_f
          lng = data["longitude"].to_f
          distance = GeoDistance.haversine(MUMBAI_LAT, MUMBAI_LNG, lat, lng)

          customer = Customer.create!(
            user_id: data["user_id"],
            name: data["name"],
            latitude: lat,
            longitude: lng,
            distance: distance
          )

          if distance <= MAX_DISTANCE_KM
            matching_customers << { user_id: customer.user_id, name: customer.name }
          end

        rescue JSON::ParserError => e
          errors << "Line #{index}: Invalid JSON format"
        rescue ActiveRecord::RecordInvalid => e
          errors << "Line #{index}: #{e.record.errors.full_messages.join(', ')}"
        end
      end

      { matching_customers: matching_customers.sort_by { |c| c[:user_id] }, errors: errors }
    end
  end
end
