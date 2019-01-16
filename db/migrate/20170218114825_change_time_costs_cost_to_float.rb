class ChangeTimeCostsCostToFloat < ActiveRecord::Migration
  def change
    change_column :time_costs, :cost, :float
  end
end
