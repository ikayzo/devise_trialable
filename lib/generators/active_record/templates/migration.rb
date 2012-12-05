class DeviseTrialableAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def up
    change_table :<%= table_name %> do |t|
      t.datetime :enrolled_at
    end
  end

  def down
    change_table :<%= table_name %> do |t|
      t.remove enrolled_at
    end
  end
end