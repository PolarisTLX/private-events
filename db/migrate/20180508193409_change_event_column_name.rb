class ChangeEventColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :name, :title
  end
end
