require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  describe "GET /disclaimer" do
    it "returns http success" do
      get "/static_pages/disclaimer"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      get "/static_pages/privacy"
      expect(response).to have_http_status(:success)
    end
  end

end
