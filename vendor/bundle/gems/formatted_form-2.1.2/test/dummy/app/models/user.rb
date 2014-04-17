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