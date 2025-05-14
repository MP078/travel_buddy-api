# frozen_string_literal: true

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :validate_and_populate_email, only: [ :create ]

  def create
    if params[:email].nil?
      return render_create_error("Email is required.")
    end

    @resource = resource_class.new(sign_up_params)

    if @resource.save
      yield @resource if block_given?

      if active_for_authentication?
        @token = @resource.create_token
        @resource.save!
        update_auth_header
      end

      render_create_success
    else
      clean_up_passwords @resource
      render_create_error
    end
  end

  private

    # Validate and populate email based on the user parameter
    def validate_and_populate_email
      login_info = params[:email]

      if login_info.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
        params[:email] = login_info
      else
        render_create_error("Please provide a valid email address.")
      end
    end

    # Define permitted parameters for sign-up (phone removed)
    def sign_up_params
      params.permit(:email, :password, :password_confirmation, :name, :username, :avatar)
    end
end
