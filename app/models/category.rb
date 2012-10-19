class Category
  include Mongoid::Document

  field :category_id
  field :title
  field :app_type

  belongs_to :parent,         :class_name => 'Category'
  has_many   :sub_categories, :class_name => 'Category', :foreign_key => :parent_id

  def self.of_type(type)
    Category.where(:app_type => type).map(&:category_id).compact
  end
end
