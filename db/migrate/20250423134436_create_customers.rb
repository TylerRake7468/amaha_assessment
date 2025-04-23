class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.string :name
      t.float :latitude
      t.float :longitude
      t.float :distance

      t.timestamps
    end
  end
end
