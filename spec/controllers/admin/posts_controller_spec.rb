# frozen_string_literal: true

RSpec.describe Admin::PostsController, type: :controller do
  describe "GET index" do
    it "prepares the ransack results" do
      get :index

      expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
    end
  end
end
