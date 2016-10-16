class RecreateJoinTables < ActiveRecord::Migration
  def change

    drop_table :employees_abilities
    drop_table :vacancies_abilities

    create_table :abilities_employees, id: false do |t|
      t.belongs_to :ability, index: true
      t.belongs_to :employee, index: true

      t.timestamps null: false
    end

    create_table :abilities_vacancies, id: false do |t|
      t.belongs_to :ability, index: true
      t.belongs_to :vacancy, index: true

      t.timestamps null: false
    end
  end
end
