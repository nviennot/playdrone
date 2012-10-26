class App
  include Mongoid::Document

  belongs_to :searched_category, :class_name => 'Category', :foreign_key => :category_id

  alias_attribute :package_name, :_id

  field :app_id
  field :title
  field :app_type,     :type => Symbol
  field :creator
  field :version
  field :rating,       :type => Float
  field :rating_count, :type => Integer
  field :description
  field :permissions,  :type => Array
  field :install_size, :type => Integer
  field :category
  field :contact_email
  field :downloads_count_text
  field :contact_phone
  field :contact_website
  field :screenshots_count, :type => Integer
  field :promo_text
  field :recent_changes
  field :promo_video

  field :package_name
  field :version_code

  field :price_currency
  field :price
end
