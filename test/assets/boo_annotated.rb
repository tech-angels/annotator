# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * foo_id [integer] - belongs to :foo
# * poly_id [integer] - belongs to :poly (polymorphic)
# * poly_type [string] - belongs to :poly (polymorphic)
# * updated_at [datetime, not null] - last update time
class Boo < ActiveRecord::Base
  belongs_to :foo
  belongs_to :poly, :polymorphic => true
end
