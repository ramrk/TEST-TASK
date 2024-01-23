class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.integer :employee_id
      t.string :phone
      t.boolean :primary, default: false
      t.timestamps
    end
  end
end
