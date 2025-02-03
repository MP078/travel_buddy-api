# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: %i[update]
  include RackSessionFix
 respond_to :json
 before_action :configure_permitted_parameters, if: :devise_controller?


 protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :password_confirmation, :name, :user_name, :address, :bio, :phone_number, :gender ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :password, :password_confirmation, :current_password, :name, :user_name, :address, :bio, :phone_number, :gender ])
  end


private
  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: { message: "Signed up sucessfully." },
        data: resource
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { message: "Account deleted successfully." }
      }, status: :ok
    #
    elsif request.method == "PUT" || request.method == "PATCH"
      if resource.errors.empty?
        render json: {
          status: { message: "Password updated successfully." }
        }, status: :ok
      else
        render json: {
          status: { message: "Password update failed. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
