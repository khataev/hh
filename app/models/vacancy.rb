class Vacancy < ActiveRecord::Base
  has_and_belongs_to_many :abilities

  validates :name, presence: true
  validates :contacts, presence: true
  validates :salary, presence: true
  validates :abilities, presence: true
  validates :valid_till, presence: true
end
