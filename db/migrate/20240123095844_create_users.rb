class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :user_code_id
      t.string :user_code
      t.string :first_name
      t.string :last_name
      t.string :email
      t.float :salary
      t.datetime :date_of_join
      t.timestamps
    end
  end
end
