class RemoveSportFromActivitiesOneMoreTime < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :sport
  end
end
