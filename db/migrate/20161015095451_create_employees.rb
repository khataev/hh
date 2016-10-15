class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :search_status
      t.integer :salary
      t.text :contacts

      t.timestamps null: false
    end
  end
end
