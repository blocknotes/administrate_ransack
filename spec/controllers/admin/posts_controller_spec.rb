# frozen_string_literal: true

RSpec.describe Admin::PostsController do
  describe "GET index" do
    it "prepares the ransack results" do
      get :index

      expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
    end

    context "when ransack_options is defined" do
      context "when you want to handle the error manualy" do
        controller do
          def handle_ransack_argument_error(error)
            raise error
          end
        end

        it "raises an exception with an invalid parameter" do
          expect {
            get :index, params: { "q[title2_cont]" => "test" }
          }.to raise_exception(ArgumentError, 'Invalid search term title2_cont')
        end
      end

      context "when you want to reset the ransack result and display a flash message on error" do
        it "resets the ransack result and displays a flash message" do
          get :index, params: { "q[title2_cont]" => "test" }

          expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
          expect(assigns(:ransack_results).result).to be_empty
          expect(flash[:alert]).to eq 'Invalid search term title2_cont'
        end
      end

      context "when you want to not reset the ransack result on error" do
        controller do
          def reset_ransack_result_on_error(super_scoped_resource)
            super_scoped_resource
          end
        end

        it "does not reset the ransack result" do
          get :index, params: { "q[title2_cont]" => "test" }

          expect(assigns(:ransack_results)).to be_instance_of Ransack::Search
          expect(assigns(:ransack_results).result).to_not be_empty
        end
      end
    end
  end
end
