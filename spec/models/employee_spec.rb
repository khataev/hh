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

  describe 'Vacancy search' do
    context 'Method1' do
      let(:a1) { create(:ability, name: 'ability 1') }
      let(:a2) { create(:ability, name: 'ability 2') }
      let(:a3) { create(:ability, name: 'ability 3') }

      let(:emp) { build(:employee, salary: 10) }
      let(:vac1) { build(:vacancy, salary: 10) }
      let(:vac2) { build(:vacancy, salary: 10) }

      before do
        emp.abilities << a1
        emp.abilities << a2
        emp.abilities << a3

        vac1.abilities << a1
        vac1.abilities << a2
        vac1.abilities << a3

        vac2.abilities << a1
        vac2.abilities << a2

        emp.save!
        vac1.save!
        vac2.save!
      end

      it 'Complete match' do
        expect(emp.vacancies_complete_match_m1).to include vac1
        expect(emp.vacancies_complete_match_m1).to_not include vac2
      end

      it 'Partial match' do
        expect(emp.vacancies_partial_match_m1).to include vac2
        expect(emp.vacancies_partial_match_m1).to_not include vac1
      end

    end
  end
end
