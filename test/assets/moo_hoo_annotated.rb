# Some existing stupid comment

# Attributes:
# * id [integer, primary, not null] - primary key
# * body [text]
# * created_at [datetime, not null] - creation time
# * random_number [integer] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
module Moo
  class Hoo < ActiveRecord::Base
    self.table_name = 'foos'
  end
end
