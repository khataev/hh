class Vacancy < ActiveRecord::Base
  has_and_belongs_to_many :abilities
end
