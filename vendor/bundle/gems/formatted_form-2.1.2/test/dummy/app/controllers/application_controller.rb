class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def test
    @user = User.new
    @user.errors.add(:exception, 'terrible error')
    @user.errors.add(:is_terrible, 'not checked')
  end
  
end
