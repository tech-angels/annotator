# Attributes:
# * id [integer, primary, not null] - primary key
# * boo_id [integer] - belongs to :boo
# * created_at [datetime, not null] - creation time
# * deleted_at [datetime, not null] - delete time
# * foo_id [integer] - my handcrafted description
# * poly_id [integer] - belongs to :poly (polymorphic)
# * poly_type [string] - belongs to :poly (polymorphic)
# * updated_at [datetime, not null] - last update time
class Roo < ActiveRecord::Base
  belongs_to :boo
  belongs_to :poly, :polymorphic => true
  belongs_to :foo
end
