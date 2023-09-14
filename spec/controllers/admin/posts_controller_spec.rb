# frozen_string_literal: true

RSpec.describe Admin::PostsController, type: :controller do
  describe "GET index" do
    it "prepares the ransack results" do
      get :index

      expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
    end

    context "when ransack_options is defined" do
      it "raises an exception with an invalid parameter" do
        expect {
          get :index, params: { "q[title2_cont]" => "test" }
        }.to raise_exception(ArgumentError, 'Invalid search term title2_cont')
      end
    end
  end
end
