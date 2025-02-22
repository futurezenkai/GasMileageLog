class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_car_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_car_path
  end
end
