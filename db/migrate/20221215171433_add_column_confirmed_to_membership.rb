class AddColumnConfirmedToMembership < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :confirmed, :boolean, default: true
  end
end
