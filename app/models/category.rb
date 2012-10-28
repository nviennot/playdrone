class Category
  include Mongoid::Document

  field :_id, :as => :category_id
  field :title
  field :app_type

  belongs_to :parent,         :class_name => 'Category'
  has_many   :sub_categories, :class_name => 'Category', :foreign_key => :parent_id
  has_many   :apps

  def self.of_type(type)
    Category.where(:app_type => type).map(&:category_id).compact
  end
end
