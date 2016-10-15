class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :name
      t.date :valid_till
      t.integer :salary
      t.text :contacts

      t.timestamps null: false
    end
  end
end
