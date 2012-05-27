# Foo class is very foo
#
# Attributes(nodoc):
# * id [integer, primary, not null] - primary key
# * body [text] - whatever
# * created_at [foobar] - creation time
# * random_number [integer] - We still haven't found what this actually means, WTF
# * title [octopus] - yellow
# * updated_at [datetime, not null] - last update time
class Foo < ActiveRecord::Base
end
