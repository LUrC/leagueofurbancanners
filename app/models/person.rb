class Person < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone
  attr_accessible :city, :latitude, :longitude, :zipcode
  attr_accessible :lat, :lon, :gmaps, :street_number, :street_name
  attr_accessible :user_id

  geocoded_by :address, :latitude => :lat, :longitude => :lon
  after_validation :geocode

  default_scope order('last_name ASC, first_name ASC')

  belongs_to :user

  has_many :owned_sites, :class_name => 'Site', :foreign_key => 'owner_id', :dependent => :nullify
  has_many :secondary_owned_sites, :class_name => 'Site', :foreign_key => 'secondary_owner_id', :dependent => :nullify
  has_many :contact_sites, :class_name => 'Site', :foreign_key => 'lurc_contact_id', :dependent => :nullify
  has_many :harvestings, :foreign_key => 'harvester_id'
  has_many :harvests, :order => 'harvests.date DESC', :through => :harvestings
  has_many :person_interests
  has_many :interests, :through => :person_interests

  accepts_nested_attributes_for :person_interests, :allow_destroy => true
  attr_accessible :person_interests_attributes

  validates_presence_of :last_name
  before_save :copy_email_from_user

  acts_as_gmappable :lat => "lat", :lng => "lon"

  def full_name
    (first_name? ? first_name : "") + " " + (last_name? ? last_name : "")
  end

  def merge_in(other_person)
    owned_sites << other_person.owned_sites
    secondary_owned_sites << other_person.secondary_owned_sites
    contact_sites << other_person.contact_sites
    self.email = other_person.email unless self.email
    self.first_name = other_person.first_name unless self.first_name
    self.phone = other_person.phone unless self.phone
    self.city = other_person.city unless self.city
    self.street_number = other_person.street_number unless self.street_number
    self.street_name = other_person.street_name unless self.street_name
    self.zipcode = other_person.zipcode unless self.zipcode
    save!
    other_person.destroy
  end

  def all_sites
    (owned_sites + secondary_owned_sites + contact_sites).uniq
  end

  def site_role(site)
    res = []
    res << "owner" if site.owner == self
    res << "secondary owner" if site.secondary_owner == self
    res << "site coordinator" if site.lurc_contact == self
    res.join(", ")
  end

  def copy_email_from_user
    self.email = self.user.email if self.email == nil && self.user_id?
  end

  def address
    "#{street_number} #{street_name}, #{city}, MA #{zipcode}"
  end

  def gmaps4rails_address
    "#{street_number} #{street_name}, #{city}, MA #{zipcode}"
  end

  def gmaps4rails_title
    "#{full_name}"
  end

  def gmaps4rails_sidebar
    "<li>#{full_name}</li>" #put whatever you want here
  end

  def gmaps4rails_marker_picture
    picpath = "/assets/person.png"
    {
     "picture" => picpath,
     "width" => 30,
     "height" => 30,
     "marker_anchor" => [ 5, 10],
    }
  end

  def past_harvestings
    harvestings.reject { |h| h.harvest.upcoming? }
  end

  def upcoming_harvestings
    harvestings.select { |h| h.harvest.upcoming? }
  end

  def past_harvests
    past_harvestings.map(&:harvest)
  end

  def upcoming_harvests
    upcoming_harvestings.map(&:harvest)
  end

end
