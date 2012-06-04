require 'pp'

# Attributes:
# * id [integer, primary, not null] - primary key
# * body [text]
# * created_at [datetime, not null] - creation time
# * random_number [integer] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
class Foo < ActiveRecord::Base
end
