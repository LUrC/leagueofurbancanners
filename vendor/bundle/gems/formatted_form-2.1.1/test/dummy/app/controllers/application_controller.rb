class User
  
  include ActiveModel::Validations
  
  attr_accessor :name, :bio, :gender, :single, :colors, 
                :is_awesome, :is_terrible, :income, :extra, :exception
  
  def to_key
    nil
  end
  
  def persisted?
    false
  end
  
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def test
    @user = User.new
    @user.errors.add(:exception, 'terrible error')
    @user.errors.add(:is_terrible, 'not checked')
  end
  
end
