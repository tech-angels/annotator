# encoding: utf-8
class Boo < ActiveRecord::Base
  belongs_to :foo
  belongs_to :poly, :polymorphic => true
end
