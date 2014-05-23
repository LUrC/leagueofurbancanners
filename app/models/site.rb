class Site < ActiveRecord::Base
  attr_accessible :city, :latitude, :longitude, :lurc_contact_id, :note, :owner_id, :secondary_owner_id, :status, :street, :zipcode
  attr_accessible :lat, :lon, :gmaps, :street_number, :street_name, :owner_contacted
  attr_accessible :rating
  # geocoded_by :address
  # after_validation :geocode, :if => :street_changed? || :city_changed? || :zipcode_changed?

  acts_as_gmappable :lat => "lat", :lng => "lon"

  belongs_to :owner, :class_name => 'Person'
  belongs_to :secondary_owner, :class_name => 'Person'
  belongs_to :lurc_contact, :class_name => 'Person'
  has_many :fruit_trees, :dependent => :destroy
  has_many :fruits, :through => :fruit_trees
  has_many :status_checks, :through => :fruit_trees
  has_many :harvests, :through => :fruit_trees
  has_many :prunings, :through => :fruit_trees

  scope :has_fruit_in, lambda { |fruit_ids| joins(:fruit_trees).where("fruit_trees.fruit_id in (?)", fruit_ids) }

  # Bad practice to accept nested attributes for a parent, but forms are set up so that only new owners can/will be selected
  # this way and existing owners cannot be edited from within a user.
  accepts_nested_attributes_for :owner, :reject_if => proc { |attributes| attributes['last_name'].blank? }
  accepts_nested_attributes_for :secondary_owner, :reject_if => proc { |attributes| attributes['last_name'].blank? }
  accepts_nested_attributes_for :lurc_contact, :reject_if => proc { |attributes| attributes['last_name'].blank? }
  attr_accessible :owner_attributes, :secondary_owner_attributes, :lurc_contact_attributes

  accepts_nested_attributes_for :fruit_trees, :reject_if => proc { |attributes| attributes['fruit_id'].blank? }
  attr_accessible :fruit_trees_attributes

  def self.by_street
      order('street_name ASC, street_number ASC')
  end

  @@STATUSES = ['need to coordinate date/time with owner', '24 hour notice with reply required', '24 hour notice with no reply required', 'permission to harvest denied']
  def self.STATUSES
     @@STATUSES
  end

  @@SITE_FILTERS = ['Coordinated', 'Not Coordinated']
  def self.SITE_FILTERS
      @@SITE_FILTERS
  end

  @@RATINGS = [{:value => 0, :description => "Unrated"},
               {:value => 1, :description => "Unusable"},
               {:value => 2, :description => "Unknown, Uncontacted, Iffy Fruit"},
               {:value => 3, :description => "Good or Good Potential"},
               {:value => 4, :description => "Contacted, Harvested, Good Fruit"}]
  def self.RATINGS
    @@RATINGS
  end

  def self.zipcodes
      Site.all.collect { |s| s.zipcode }.uniq.compact.sort
  end

  def self.filter_sites_by(sites, site_filter)
      if (site_filter == 'Coordinated')
          sites.reject { |s| s.lurc_contact_id == nil }
      elsif (site_filter == 'Not Coordinated')
          sites.select { |s| s.lurc_contact_id == nil }
      else
          sites
      end
  end

  def self.filter_sites_by_zipcodes(sites, zipcodes)
      sites.select { |s| zipcodes.include?(s.zipcode) }
  end

  def self.closest_sites(centerlat, centerlng, limit, include_coordinated = false)
    if (include_coordinated)
      sites = Site.find_by_sql(["SELECT id, lat, lon, POW(69.1 * (lat - ?), 2) + POW(69.1 * (? - lon) * COS(lat / 57.3), 2) AS distance FROM sites ORDER BY distance LIMIT ?;", centerlat, centerlng, limit])
    else
      sites = Site.find_by_sql(["SELECT id, lat, lon, POW(69.1 * (lat - ?), 2) + POW(69.1 * (? - lon) * COS(lat / 57.3), 2) AS distance FROM sites WHERE lurc_contact_id is null ORDER BY distance LIMIT ?;", centerlat, centerlng, limit])
    end
    sites = sites.collect { |s| Site.find(s.id) }
  end

  def site_name
    if User.session_current_user && sees_street(User.session_current_user)
      street_name + " (##{street_number})"
    else
      street_name + " (#hidden)"
    end
  end

  def address
    "#{street_number} #{street_name}, #{city}, MA #{zipcode}"
  end

  def gmaps4rails_address
    "#{street_number} #{street_name}, #{city}, MA #{zipcode}"
  end

  def gmaps4rails_title
    "#{street_number} #{street_name} fruits: " + fruits.collect { |f| f.name }.join(", ")
  end

  def gmaps4rails_sidebar
    "<li>#{site_name}</li>" #put whatever you want here
  end

  def sees_street(user)
      user.admin? || user.organizer? || user.person == lurc_contact || user.person == owner || user.person == secondary_owner
  end

  def owner_contact_status
    if !owner
      "owner unknown"
    elsif (owner_name.blank?) && owner.phone.blank? && owner.email.blank?
      "no contact info"
    elsif owner.phone.blank? && owner.email.blank?
      "name only"
    elsif !owner.phone.blank? && owner.email.blank?
      "phone number"
    elsif !owner.email.blank? && owner.phone.blank?
      "email address"
    elsif !owner.email.blank? && !owner.phone.blank?
      "email and phone"
    else
      "unknown"  # ideally should not get here
    end
  end

  def owner_name
    owner ? owner.full_name : 'Unknown'
  end

  def secondary_owner_name
    secondary_owner ? secondary_owner.full_name : 'None'
  end

  def lurc_contact_name
    lurc_contact ? lurc_contact.full_name : 'None'
  end

end
