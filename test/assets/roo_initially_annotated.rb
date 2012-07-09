# Attributes:
# * id [integer, primary, not null] - primary key
# * boo_id [integer] - TODO: document me
# * created_at [datetime, not null] - creation time
# * foo_id [integer] - my handcrafted description
# * poly_id [integer] - TODO: document me
# * poly_type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
class Roo < ActiveRecord::Base
  belongs_to :boo
  belongs_to :poly, :polymorphic => true
  belongs_to :foo
end
