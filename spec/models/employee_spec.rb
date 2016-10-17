require 'rails_helper'

RSpec.describe Employee, type: :model do
  # associations
  it { should have_and_belong_to_many :abilities }

  # validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :contacts }
  it { should validate_presence_of :salary }
  it { should validate_presence_of :search_status }

  describe 'validates correctness of Name' do
    let!(:ability) {create(:ability)}

    context 'with invalid name' do
      let(:emp) { build(:employee) }

      it 'does not save latin 1 word name' do
        emp.name = 'John'
        emp.abilities << ability
        expect {emp.save}.to_not change(Employee, :count)
      end

      it 'does not save latin 3 word name' do
        emp.name = 'John Doe Doe'
        emp.abilities << ability
        expect {emp.save}.to_not change(Employee, :count)
      end

      it 'does not save cyrillic 4 word name' do
        emp.name ='Иванов Иван Иванович оглы'
        emp.abilities << ability
        expect {emp.save}.to_not change(Employee, :count)
      end
    end

    context 'with valid name' do
      let(:emp) { build(:employee, name: 'Иванов Иван Иванович') }
      it 'saves' do
        emp.abilities << ability
        expect {emp.save}.to change(Employee, :count)
      end
    end

  end
end
