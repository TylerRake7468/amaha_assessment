require "rails_helper"

RSpec.describe Customers::FilterService do
  let(:file_path){Rails.root.join("spec/fixtures/files/test_customers.txt")}
  let(:file){Rack::Test::UploadedFile.new(file_path, 'text/plain')}

  describe "#process_file" do
    before do
      Customer.destroy_all
    end

    context "When file contain valid data and near by customer" do
      it "Return customer near by 100km in sorted by user_id" do
        File.write(file_path, <<~DATA)
          {"user_id": 2, "name": "Test2", "latitude": "19.0600", "longitude": "72.7600"}
          {"user_id": 1, "name": "Test1", "latitude": "19.0580", "longitude": "72.7540"}
        DATA

        result = described_class.new(file).process_file
      	
      	expect(result[:matching_customers]).to eq([
      		{user_id: 1, name: "Test1"},
      		{user_id: 2, name: "Test2"}
      	])
      	expect(result[:errors]).to be_empty
      	expect(Customer.count).to eq(2)
      end
    end

    context "when file contains invalid JSON line" do
      it "adds a JSON parsing error to errors array" do
        File.write(file_path, <<~DATA)
          {"user_id": 1, "name": "Valid", "latitude": "19.0580", "longitude": "72.7540"}
          {sdjfm sdksdkl sd}
        DATA

        result = described_class.new(file).process_file

        expect(result[:matching_customers].size).to eq(1)
        expect(result[:errors]).to include(/Invalid JSON format/)
        expect(Customer.count).to eq(1)
      end
    end

 	context "when file contains record with missing fields" do
      it "adds validation error to errors array" do
        File.write(file_path, <<~DATA)
          {"user_id": 1, "name": "Valid", "latitude": "19.0580", "longitude": "72.7540"}
          {"name": "kuch bhi", "latitude": "19.0580", "longitude": "72.7540"}
        DATA

        result = described_class.new(file).process_file

        expect(result[:matching_customers].size).to eq(1)
        expect(result[:errors].first).to match(/User can't be blank|User has already been taken/)
        expect(Customer.count).to eq(1)
      end
    end

    context "when customers are far from Mumbai" do
      it "does not include them in the result" do
        File.write(file_path, <<~DATA)
          {"user_id": 1, "name": "Far Away", "latitude": "10.0000", "longitude": "75.0000"}
        DATA

        result = described_class.new(file).process_file

        expect(result[:matching_customers]).to be_empty
        expect(Customer.count).to eq(1)
      end
    end

  end
end