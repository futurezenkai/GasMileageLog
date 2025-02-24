class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ログイン成功後、/cars にリダイレクトする
  def after_sign_in_path_for(resource)
    cars_path
  end
end
