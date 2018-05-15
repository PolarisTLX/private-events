class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.date :date
      # t.references :host, foreign_key: true
      t.integer :host_id, index: true 

      t.timestamps
    end
  end
end
