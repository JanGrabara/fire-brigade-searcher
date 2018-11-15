class CreateFirestations < ActiveRecord::Migration[5.1]
  def change
    create_table :firestations do |t|
      t.string :email
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :website
      t.string :fax
      t.string :street
      t.string :street_nr
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
