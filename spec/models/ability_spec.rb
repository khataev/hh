require 'rails_helper'

RSpec.describe Ability, type: :model do
  # associations
  it { should have_and_belong_to_many :employees }
  it { should have_and_belong_to_many :vacancies }

  # validations
  it { should validate_presence_of :name }
end
