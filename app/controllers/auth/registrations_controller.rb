
  class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?

      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          render :create, status: :ok
        else
          expire_data_after_sign_in!
          render :create, status: :ok
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
