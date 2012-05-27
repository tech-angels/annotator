# Foo class is very foo
#
# Attributes:
# * id [integer, primary, not null] - primary key
# * body [text] - whatever
# * created_at [datetime, not null] - creation time
# * random_number [integer] - We still haven't found what this actually means, WTF
# * title [string]
# * updated_at [datetime, not null] - last update time
class Foo < ActiveRecord::Base
end
