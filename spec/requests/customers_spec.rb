require 'rails_helper'

RSpec.describe "Customers API", type: :request do
  let(:endpoint) { "/customers/import" }
  let(:file_path) { Rails.root.join("spec/fixtures/files/upload_test.txt") }

  before do
    Customer.destroy_all
  end

  context "when file is uploaded with valid data" do
    it "returns filtered customers within 100km" do
      File.write(file_path, <<~DATA)
        {"user_id": 3, "name": "User A", "latitude": "19.0600", "longitude": "72.7600"}
        {"user_id": 1, "name": "User B", "latitude": "19.0580", "longitude": "72.7540"}
        {"user_id": 2, "name": "Far User", "latitude": "10.0000", "longitude": "75.0000"}
      DATA

      file = fixture_file_upload(file_path, 'text/plain')
      post endpoint, params: { file: file }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body["customers"]).to eq([
        { "user_id" => 1, "name" => "User B" },
        { "user_id" => 3, "name" => "User A" }
      ])
      expect(body["errors"]).to eq([])
    end
  end

  context "when no file is uploaded" do
    it "returns 400 bad request" do
      post endpoint
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ "error" => "File is missing" })
    end
  end

  context "when file have invalid JSON line" do
    it "ignores invalid line and returns valid filtered customers" do
      File.write(file_path, <<~DATA)
        {"user_id": 1, "name": "Valid User", "latitude": "19.0580", "longitude": "72.7540"}
        {sm,gnks vskl skl kf}
      DATA

      file = fixture_file_upload(file_path, 'text/plain')
      post endpoint, params: { file: file }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body["customers"]).to eq([
        { "user_id" => 1, "name" => "Valid User" }
      ])
      expect(body["errors"]).to eq(["Line 2: Invalid JSON format"])
    end
  end
end
