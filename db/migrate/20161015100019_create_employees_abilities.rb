class CreateEmployeesAbilities < ActiveRecord::Migration
  def change
    create_table :employees_abilities, id: false do |t|
      t.belongs_to :ability, index: true
      t.belongs_to :employee, index: true

      t.timestamps null: false
    end
  end
end
