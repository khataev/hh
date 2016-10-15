class CreateVacanciesAbilities < ActiveRecord::Migration
  def change
    create_table :vacancies_abilities, id: false do |t|
      t.belongs_to :ability, index: true
      t.belongs_to :vacancy, index: true

      t.timestamps null: false
    end
  end
end
