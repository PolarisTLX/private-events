class AddDefaultValueToEventsAcceptedColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :invites, :accepted, :boolean, default: false
  end
end
