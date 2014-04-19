class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    '/people/' + resource.person.id + "/site_chooser"
  end
end
