# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * foo_id [integer] - belongs to Foo
# * updated_at [datetime, not null] - last update time
class Boo < ActiveRecord::Base
  belongs_to :foo
end
