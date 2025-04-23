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
      File.foreach(@file.path) do |line|
        data = JSON.parse(line)
        lat = data["latitude"].to_f
        lng = data["longitude"].to_f

        distance = GeoDistance.haversine(MUMBAI_LAT, MUMBAI_LNG, lat, lng)

        customer = Customer.find_or_initialize_by(user_id: data["user_id"])
        customer.update!(
          name: data["name"],
          latitude: lat,
          longitude: lng,
          distance: distance
        )

        if distance <= MAX_DISTANCE_KM
          matching_customers << { user_id: customer.user_id, name: customer.name }
        end
      end

      matching_customers.sort_by { |c| c[:user_id] }
    end
  end
end
