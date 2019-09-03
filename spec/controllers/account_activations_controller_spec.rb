require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
	describe "post #edit" do 
		# already active user
		let(:active_user) { create(:user) }
		# not active user
		let(:non_active_user) { create(:user, :non_active) }

		let(:invalid_params) do 
			{ params: { email: active_user.email, id: '' } } 
		end
		context "when user params are wrong" do
			it "should redirect to root url" do 
				get :edit, invalid_params
				expect(response).to redirect_to(root_url)
			end
		end
		context "when all is well" do 
			it "should activate the user and redirect to user page" do 
				non_active_user
				get :edit, {params: {
					email: non_active_user.email,
					id: non_active_user.activation_token
				}}
				expect(response).to redirect_to(non_active_user)
				expect(non_active_user.reload.activated?).to be true
			end
		end
	end 
end