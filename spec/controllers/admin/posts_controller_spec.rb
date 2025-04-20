# frozen_string_literal: true

RSpec.describe Admin::PostsController do
  describe "GET index" do
    it "prepares the ransack results" do
      get :index

      expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
    end

    context "when an invalid search term is provided" do
      it "shows an alert message", :aggregate_failures do
        get :index, params: { "q[title2_cont]" => "test", "q[category_eq]" => "news" }

        expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
        expect(flash[:alert]).to eq 'Invalid search term title2_cont'
      end
    end

    context "when an invalid_search_callback method is defined and an invalid search term is provided" do
      controller do
        def invalid_search_callback(error)
          raise "Some error: #{error.message}"
        end
      end

      it "executes the callback method" do
        expect {
          get :index, params: { "q[title2_cont]" => "test" }
        }.to raise_exception("Some error: Invalid search term title2_cont")
      end
    end
  end
end
