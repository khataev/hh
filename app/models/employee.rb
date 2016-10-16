class Employee < ActiveRecord::Base
  has_and_belongs_to_many :abilities

  validates :name, presence: true
  validates :contacts, presence: true
  validates :salary, presence: true
  validates :abilities, presence: true
end
